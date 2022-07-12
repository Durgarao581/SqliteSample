//
//  ListViewController.swift
//  DemoSqlite
//
//  Created by Ganga Durgarao Kothapalli on 11/07/22.
//

import UIKit

class ListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var list:[List] = []
    var dbHelper = DBHelper.shared
    var delegate:backDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshData()
        
    }
    
    
    func refreshData(){
        list = dbHelper.readData()
        tableView.reloadData()
    }
    


}
extension ListViewController:UITableViewDelegate,UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = list[indexPath.row].name
        cell.detailTextLabel?.text = list[indexPath.row].city ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController.init(title: "Choose an action", message: nil, preferredStyle: .alert)
        
        let update = UIAlertAction(title: "Update", style: .default) { act in
            self.delegate?.getData(userinfo: self.list[indexPath.row], updateFlag: true)
            self.navigationController?.popViewController(animated: true)
               
         }
        let delete = UIAlertAction(title: "Delete", style: .default) { act in
            
            self.dbHelper.deleteData(id: self.list[indexPath.row].id)
            self.refreshData()
            
            
          }
        let cancel = UIAlertAction(title: "Cancel", style: .default) { act in
        }
        alert.addAction(update)
        alert.addAction(delete)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)

    }
    
    
}
struct List{
    let id:Int
    let name:String
    let age:Int?
    let phoneNumber:String?
    let city:String?
    
}
