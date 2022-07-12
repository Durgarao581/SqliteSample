//
//  File.swift
//  DemoSqlite
//
//  Created by Ganga Durgarao Kothapalli on 11/07/22.
//

import Foundation
import SQLite3

protocol backDelegate{
    func getData(userinfo:List,updateFlag:Bool)
}

class DBHelper {
    static let shared = DBHelper()
    
    var db : OpaquePointer?
    let databaseName = "demo.sqlite"
    
    
    
    init() {
        self.db = createDB()
    }

    deinit {
        sqlite3_close(db)
    }
    private func createDB() -> OpaquePointer? {
            var db: OpaquePointer? = nil
            do {
                let dbPath: String = try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false).appendingPathComponent(databaseName).path
                
                if sqlite3_open(dbPath, &db) == SQLITE_OK {
                    print("Successfully created DB. Path: \(dbPath)")
                    return db
                }
            } catch {
                print("Error while creating Database -\(error.localizedDescription)")
            }
            return nil
        }
    
    func createTable(){
            
            let query = """
               CREATE TABLE IF NOT EXISTS userData(
               id INTEGER PRIMARY KEY AUTOINCREMENT,
               name TEXT NOT NULL,
               age INT,
               phone_number TEXT,
               city TEXT
               );
               """
            var statement: OpaquePointer? = nil
            
            if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
                if sqlite3_step(statement) == SQLITE_DONE {
                    print("Creating table has been succesfully done. db: \(String(describing: self.db))")
                    
                }
                else {
                    let errorMessage = String(cString: sqlite3_errmsg(db))
                    print("\nsqlte3_step failure while creating table: \(errorMessage)")
                }
            }
            else {
                let errorMessage = String(cString: sqlite3_errmsg(self.db))
                print("\nsqlite3_prepare failure while creating table: \(errorMessage)")
            }
            
            sqlite3_finalize(statement)
        }
    func insertData(name: String, age: Int,phoneNumber:String,city:String)-> Int? {
        var lastRowId:Int?
          
            let insertQuery = "insert into userData (id,name, age,phone_number,city) values (?,?, ?, ?,?);"
            var statement: OpaquePointer? = nil
            
            if sqlite3_prepare_v2(self.db, insertQuery, -1, &statement, nil) == SQLITE_OK {
               
               sqlite3_bind_text(statement, 2, (name as NSString).utf8String, -1, nil)
                sqlite3_bind_int(statement, 3, Int32(age))
                sqlite3_bind_text(statement, 4, (phoneNumber as NSString).utf8String, -1, nil)
               sqlite3_bind_text(statement, 5, (city as NSString).utf8String, -1, nil)
                
            }
            else {
                print("sqlite binding failure")
            }
        
            
            if sqlite3_step(statement) == SQLITE_DONE {
                
                lastRowId = Int(sqlite3_last_insert_rowid(db))
            }
            else {
                print("sqlite step failure")
            }
        
        
        return lastRowId
        }
    
    
       func readData() -> [List] {
           let query: String = "select * from userData;"
           var statement: OpaquePointer? = nil
           
           var result: [List] = []

           if sqlite3_prepare(self.db, query, -1, &statement, nil) != SQLITE_OK {
               let errorMessage = String(cString: sqlite3_errmsg(db)!)
               print("error while prepare: \(errorMessage)")
               return result
           }
           while sqlite3_step(statement) == SQLITE_ROW {
               
               let id = sqlite3_column_int(statement, 0)
               let name = String(cString: sqlite3_column_text(statement, 1))
               print(name)
               let age = sqlite3_column_int(statement, 2)
               print(age)
               let number = String(cString: sqlite3_column_text(statement, 3))
               print(number)
               let city = String(cString: sqlite3_column_text(statement, 4))
               
               result.append(List(id: Int(id), name: String(name), age: Int(age),phoneNumber: String(number),city: String(city)))
           }
           sqlite3_finalize(statement)
           
           return result
       }
       
    func updateData(record:List) {
           var statement: OpaquePointer?
           
        let queryString = "UPDATE userData SET name = '\(record.name)', age = \(record.age ?? 0),phone_number = '\(record.phoneNumber ?? "")', city = '\(record.city ?? "")' WHERE id == \(record.id)"
           
          
           if sqlite3_prepare(db, queryString, -1, &statement, nil) != SQLITE_OK {
               onSQLErrorPrintErrorMessage(db)
               return
           }
           
           if sqlite3_step(statement) != SQLITE_DONE {
               onSQLErrorPrintErrorMessage(db)
               return
           }
           
           print("Update has been successfully done")
       }
       
       func deleteData(id: Int) {
           let queryString = "DELETE FROM userData WHERE id == \(id)"
           var statement: OpaquePointer?
           
           if sqlite3_prepare(db, queryString, -1, &statement, nil) != SQLITE_OK {
               onSQLErrorPrintErrorMessage(db)
               return
           }
           
          
           if sqlite3_step(statement) != SQLITE_DONE {
               onSQLErrorPrintErrorMessage(db)
               return
           }
           
           print("delete has been successfully done")
       }
      
       func deleteTable(tableName: String) {
           let queryString = "DROP TABLE \(tableName)"
           var statement: OpaquePointer?
           
           if sqlite3_prepare(db, queryString, -1, &statement, nil) != SQLITE_OK {
               onSQLErrorPrintErrorMessage(db)
               return
           }
           
          
           if sqlite3_step(statement) != SQLITE_DONE {
               onSQLErrorPrintErrorMessage(db)
               return
           }
           
           print("drop table has been successfully done")
           
       }
       
       private func onSQLErrorPrintErrorMessage(_ db: OpaquePointer?) {
           let errorMessage = String(cString: sqlite3_errmsg(db))
           print("Error preparing update: \(errorMessage)")
           return
       }
   
}
