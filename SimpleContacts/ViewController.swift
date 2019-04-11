//
//  ViewController.swift
//  SimpleContacts
//
//  Created by james luo on 4/11/19.
//  Copyright © 2019 james luo. All rights reserved.
//

import UIKit
import Contacts
class ViewController: UIViewController , UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate{
    @IBOutlet weak var DogImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var UISearch: UISearchBar!
    let contactStore = CNContactStore()
    var myContacts: [String:[Contact]] = [:]
    var ToLoadContacts = [Contact]()
    var allContact = [Contact]()
    var Fail = false
    var searching = false
    //var allContact = [Contact]()
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if Fail || (indexPath.row + 1).isMultiple(of: 3){
            let cell = tableView.dequeueReusableCell(withIdentifier: "Dog", for: indexPath)
            
            return cell
        }
        let cellIdentifier = "ContactCard"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ContactCard  else {
            fatalError("Error loading contact cards.")
        }
        cell.ContactInfo.text = ToLoadContacts[indexPath.row].Name + ": " + ToLoadContacts[indexPath.row].Number
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int ) -> Int{
        return ToLoadContacts.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Contacts Below"
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == ""{
            searching = false
            ToLoadContacts = allContact
            
            parseLoadData()
            self.tableView.reloadData()
            return
        }
        if searching{
            return
        }
        if  myContacts[searchBar.text!] == nil{
            ToLoadContacts = []
        }
        else{
            ToLoadContacts = myContacts[searchBar.text!]!
            searching = true
        }
        
        parseLoadData()
        self.tableView.reloadData()
    }
    //Press Search to end editing
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
    
        
            let myGroup = DispatchGroup()
            let contactStore = CNContactStore()
            myGroup.enter()
            let curTask = contactStore.requestAccess(for: .contacts) { (Success, err) in
                if Success{
                    print("good")
                    //self.getContacts()
                }
                myGroup.leave()
                
            }
            myGroup.notify(queue: .main) {
                self.getContacts()
                self.parseLoadData()
                
                self.DogImage.isHidden = true
                
                
                if self.Fail{
                    self.tableView.isHidden = true
                    self.DogImage.isHidden = false
                }
                
                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.tableView.reloadData()
                
            }
            
        
    }
        
        // Do any additional setup after loading the view.
    

    
    
    func getContacts(){
        let contactStore = CNContactStore()
        var contacts = [CNContact]()
        let keys = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey
            ] as [Any]
        let request = CNContactFetchRequest(keysToFetch: keys as! [CNKeyDescriptor])
        do {
            try contactStore.enumerateContacts(with: request){
                (contact, stop) in
                // Array containing all unified contacts from everywhere
                contacts.append(contact)
                for phoneNumber in contact.phoneNumbers {

                    let number = phoneNumber.value


                    if contact.givenName == "" || number.stringValue == ""{
                        continue
                    }

                    if self.myContacts[contact.givenName] == nil{
                        self.myContacts[contact.givenName] = [Contact(name: contact.givenName, lastName: contact.familyName, number: number.stringValue)]
                    }
                    else{
                        self.myContacts[contact.givenName]?.append(Contact(name: contact.givenName , lastName: contact.familyName, number: number.stringValue))
                    }
                    self.ToLoadContacts.append(Contact(name: contact.givenName, lastName: contact.familyName, number: number.stringValue))
                    //                        print("\(contact.givenName) \(number.stringValue)")


                }
            }

        } catch {
            Fail = true
            return
        }
        allContact = ToLoadContacts
    }
    func parseLoadData(){
        var newContactList = [Contact]()
        for contact in ToLoadContacts{
            if (contact.Number == ""  || contact.Name == ""){
                continue
            }
            newContactList.append(contact)
            if (newContactList.count + 1).isMultiple(of: 3){
                newContactList.append(contact)
            }
        }
        ToLoadContacts = newContactList
    }
}

