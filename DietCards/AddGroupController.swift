//
//  AddGroupController.swift
//  DietCards
//
//  Created by Elias Hall on 12/21/19.
//  Copyright © 2019 Elias Hall. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

protocol TypeOfUserDelegate {
    
    func didSelectUser(type: String, groupName: String)
}

class AddGroupController: UIViewController {
    
    @IBOutlet weak var createGroupButton: UIButton!
    @IBOutlet weak var joinGroupButton: UIButton!
    
    var chosenUser: TypeOfUserDelegate!
    var getGroupName: String = ""
    
    override func viewDidLoad() {
        notify()
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    @IBAction func dismissVC(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    
    @IBAction func createGroupTapped(_ sender: Any) {
        promptForCreate()

    }
    
    
    @IBAction func joinGroupTapped(_ sender: Any) {
        promptForJoin()
    }
    
    func notify() {
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name("ViewDidAppear"), object: nil)
    }
    
    func promptForCreate() {
        let ac = UIAlertController(title: "Create Group", message: "Pick a unique group name (use characters 0-9,a-z only). Note: Group name is reserved only after adding at least 1 food entry", preferredStyle: .alert)
        ac.addTextField()

        let submitAction = UIAlertAction(title: "Add", style: .default) { [unowned ac] _ in
            let answer = ac.textFields![0]
            
            self.getGroupName = answer.text ?? ""
            
            self.checkDatabase(self.getGroupName, completion: { group in
                
                print(group)
                if group == true {
                    self.presentAlert(self.getGroupName)
                    return
                }
                
                else if group == false {
                self.notify()
                self.dismiss(animated: true)
                }
            })
        }

        ac.addAction(submitAction)

        present(ac, animated: true)
    }
    
    
    func promptForJoin() {
        let ac = UIAlertController(title: "Join Group", message: "Enter group leader's username", preferredStyle: .alert)
        ac.addTextField()

        let submitAction = UIAlertAction(title: "Join", style: .default) { [unowned ac] _ in
            let answer = ac.textFields![0]
            
            self.getGroupName = answer.text ?? ""
           // print(self.getEmailInput)
                        
            self.checkDatabase2(self.getGroupName, completion: { group in

                print(group)
                if group == false {
                    self.presentAlert2(self.getGroupName)
                    return
                }

                else if group == true {
                self.notify()
                self.dismiss(animated: true)
                }
            })
            
        }

        ac.addAction(submitAction)

        present(ac, animated: true)
    }
    
    func checkDatabase(_ getGroupName: String,completion: @escaping (_ group: Bool) -> Void){
        let ref = Database.database().reference()

        
        print("^^^^^^^^^^^\(group.self)")
        var taken = false
        
        
        ref.child("\(getGroupName.self)").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                print("Username already taken")
               // group = true
                taken = true
                print("**** \(taken)")
            completion(taken)
                

            }
            else if !snapshot.exists() {
            print("Username doesn't exist")
            self.chosenUser.didSelectUser(type: "leader", groupName: self.getGroupName)
                
                //MARK: ADD FIREBASE POSTING FUNCTIONALITY
                self.addToFirebase(self.getGroupName)
                taken = false
                print("(((( \(taken)")
                completion(taken)
            }
        })
        
        }
    
    func checkDatabase2(_ getGroupName: String,completion: @escaping (_ group: Bool) -> Void){
        let ref = Database.database().reference()


        var taken = true


        ref.child("\(getGroupName.self)").observeSingleEvent(of: .value, with: { (snapshot) in
            if !snapshot.exists() { //if groupname doesn't exist
                print("Group doesn't exist")
               // group = true
                taken = false // doesn't exist
                print("**** \(taken)")
            completion(taken) //return false


            }
            else if snapshot.exists() {
                print("Added to group thank you!")
            self.chosenUser.didSelectUser(type: "follower", groupName: self.getGroupName)
                taken = true
                print("(((( \(taken)")
                completion(taken) //return true
            }
        })

        }

    func presentAlert(_ groupName: String) { //used when error has ben selected
        
        let alert = UIAlertController(title: "Error: \(groupName)", message: "This group name has already been taken", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Back", style: .default, handler: nil)
        
        alert.addAction(ok)
        
        present(alert, animated: true)
        
    }
    
    func presentAlert2(_ groupName: String) { //used when error has ben selected

        let alert = UIAlertController(title: "\(groupName)?", message: "This group doesn't exist", preferredStyle: .alert)

        let ok = UIAlertAction(title: "Back", style: .default, handler: nil)

        alert.addAction(ok)

        present(alert, animated: true)

    }
    
    func addToFirebase(_ groupName: String) {
        let ref = Database.database().reference()
        ref.child(groupName).setValue("reserved") //making a placeholder

    }
   


}
    
    
    
    
    
    




