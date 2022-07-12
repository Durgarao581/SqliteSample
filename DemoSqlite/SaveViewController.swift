//
//  ViewController.swift
//  DemoSqlite
//
//  Created by Ganga Durgarao Kothapalli on 11/07/22.
//

import UIKit

class SaveViewController: UIViewController, backDelegate {
    func getData(userinfo: List,updateFlag:Bool) {
    user = userinfo
        flag = updateFlag
    }
    

    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var phoneNumberTF: UITextField!
    @IBOutlet weak var ageTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    
    @IBOutlet weak var saveBtn: UIButton!
    let dbHelper = DBHelper.shared
    var user:List?
    var flag:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        ageTF.delegate = self
        nameTF.delegate  = self
        cityTF.delegate = self
        phoneNumberTF.delegate = self
        dbHelper.createTable()
        
        
    }
    
    func loadData(){
        if flag{
            ageTF.text = user?.age.map({String($0)})
            nameTF.text = user?.name
            phoneNumberTF.text = user?.phoneNumber
            cityTF.text = user?.city
            saveBtn.setTitle("Update", for: .normal)
            flag = false
        }else{
            nameTF.text = ""
            ageTF.text = ""
            phoneNumberTF.text = ""
            cityTF.text = ""
            saveBtn.setTitle("Save", for: .normal)
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
       
    }

    @IBAction func viewTapped(_ sender: UIBarButtonItem) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ListViewController") as? ListViewController
        vc?.delegate = self
        navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func saveTapped(_ sender: UIButton) {
       
        if saveBtn.title(for: .normal) == "Update"{
            if let use = user{
                dbHelper.updateData(record: use)
                flag = false
                user = nil
            }
            
        }else{
            let id =  dbHelper.insertData(name: nameTF.text ?? "", age: (ageTF.text! as NSString).integerValue, phoneNumber: phoneNumberTF.text ?? "", city: cityTF.text ?? "")
             print(id)
        }
       
        
    }
    
}
extension SaveViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
