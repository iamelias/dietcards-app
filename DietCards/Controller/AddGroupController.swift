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
import CoreData
import FirebaseUI

protocol TypeOfUserDelegate { //purpose is to return groupname and type of user back to HomeViewController
    
    func didSelectUser(type: String, groupName: String, uid: String, update: Bool)
}

class AddGroupController: UIViewController {
    
    @IBOutlet weak var createGroupButton: UIButton! //user options Create/Join Group
    @IBOutlet weak var joinGroupButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var chosenUser: TypeOfUserDelegate! //to return to HomeViewController, from HomeVC
    var getGroupName: String = "" //to return to HomeViewController, from HomeVC
    var usrPerm: String = ""
    var coreGroupName: [SavedGroup] = [] //to save/delete groupName from core data, from HomeVC
    var coreGroupName2: [SavedGroup] = [] //backup fore delete/save sequential move
    
    var uid = ""
    var currentUserUid = ""
    
    var dataController: DataController? //from HomeVC
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        // notify() //to run viewDidAppear when returning to HomeViewController
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    @IBAction func dismissVC(_ sender: Any) { //returning to HomeViewController
        dismiss(animated: true)
    }
    
    @IBAction func createGroupTapped(_ sender: Any) { //when create button is tapped
        usrPerm = "leader"
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        var passCreateObj = PromptObject()
        passCreateObj.title = "Create Group"
        passCreateObj.message =  "Pick a unique group name (use characters 0-9,A-Z,a-z only)."
        passCreateObj.submitTitle = "Add"
        passCreateObj.pMessage1 = "This group name has already been taken"
        passCreateObj.bool1 = true
        passCreateObj.bool2 = false
        prompt(passCreateObj)
    }
    
    
    @IBAction func joinGroupTapped(_ sender: Any) { //when join button is tapped
        usrPerm = "follower"
        var passJoinObj = PromptObject()
        passJoinObj.title = "Join Group"
        passJoinObj.message = "Enter group leader's username"
        passJoinObj.submitTitle = "Join"
        passJoinObj.pMessage1 = "This group doesn't exist"
        passJoinObj.bool1 = false
        passJoinObj.bool2 = true
        self.activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        prompt(passJoinObj)
    }
    
    func prompt(_ passObject: PromptObject) {
        let ac = UIAlertController(title: passObject.title, message: passObject.message, preferredStyle: .alert)
        ac.addTextField() //user inputs name of group
        
        let submitAction = UIAlertAction(title: passObject.submitTitle, style: .default) { [unowned ac] _ in
            let answer = ac.textFields![0]
            
            self.getGroupName = answer.text ?? "Join Group" //checking if entered name exists already
            if self.getGroupName == "" { //empty string will be reassigned to Join Group
                self.getGroupName = "Join Group"
            }
            
            guard self.getGroupName != "Join Group" else {// if Join Group is name chosen
                //self.notify()
                // self.dismiss(animated: true)
                let passMessage = "Choose different group name"
                self.presentAlert(self.getGroupName, passMessage) //alert to rechoose name
                return
            }
            
            if passObject.submitTitle == "Add" {
                self.presentInfoCreate(passObject)
            }
            else if passObject.submitTitle == "Join" {
                self.presentInfoJoin(passObject)
            }
        }
        
        ac.addAction(submitAction) // adding above action
        
        present(ac, animated: true, completion:{ //setting up tap gesture recognizer
            ac.view.superview?.isUserInteractionEnabled = true
            ac.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.acBackgroundTapped)))} )
    }
    
    func presentInfoCreate(_ passObject: PromptObject ) {
        self.checkDatabaseCreate(self.getGroupName, completion: { group in
            if group == passObject.bool1 { //if group name does exist
                let passMessage = passObject.pMessage1
                self.presentAlert(self.getGroupName, passMessage) //alert to say it already exists
                return
            }
            else if group == passObject.bool2 { //if doesn't already exist...
                self.notify() //notify to rerun viewDidAppear
                //delegate will pass back group name and permission type for firebase in HomeVC
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.dismiss(animated: true) //auto dismiss back to HomeVC
            }
        })
    }
    
    func presentInfoJoin(_ passObject: PromptObject ) {
        self.checkDatabaseJoin(self.getGroupName, completion: { group in
            if group == passObject.bool1 { //if group name does exist
                let passMessage = passObject.pMessage1
                self.presentAlert(self.getGroupName, passMessage) //alert to say it already exists
                return
            }
            else if group == passObject.bool2 { //if doesn't already exist...
                self.notify() //notify to rerun viewDidAppear
                //delegate will pass back group name and permission type for firebase in HomeVC
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.dismiss(animated: true) //auto dismiss back to HomeVC
            }
        })
    }
    
    @objc func acBackgroundTapped()
    {
        self.dismiss(animated: true, completion: nil) //dismissing alert at background tap
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    func checkDatabaseCreate(_ getGroupName: String,completion: @escaping (_ group: Bool) -> Void){ //checking database for createGroup
        let ref = Database.database().reference()
        
        var taken = false //group name is default not taken
        
        ref.child("\(getGroupName.self)").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() { //if username exists in database
                taken = true //reassign taken to true
                completion(taken) //exit closure pass true for taken
                
            }
            else if !snapshot.exists() { //if doesn't exist
                print("Group name doesn't exist") //assign delegates parameters
                let gotUid = self.getUid()
                self.chosenUser.didSelectUser(type: "leader", groupName: self.getGroupName, uid: gotUid, update: true)
                
                //MARK: ADD FIREBASE POSTING FUNCTIONALITY
                self.addToFirebase(self.getGroupName, gotUid) //adding new group name to database
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                taken = false
                completion(taken) //exist closure with false for group name is not taken
                
                
            }
        })
    }
    
    func checkDatabaseJoin(_ getGroupName: String,completion: @escaping (_ group: Bool) -> Void){
        let ref = Database.database().reference()
        
        var taken = true
        ref.child("\(getGroupName.self)").observeSingleEvent(of: .value, with: { (snapshot) in
            if !snapshot.exists() { //if group doesn't exist
                print("Group doesn't exist")
                taken = false
                completion(taken) //exiting closure passing false
            }
                
            else if snapshot.exists() { //if group does exist
                print("Added to group") //assigning delegate's parameters
                //below didselect may be unecessary
                self.chosenUser.didSelectUser(type: "follower", groupName: self.getGroupName, uid: self.uid, update: true) //returning type and groupName that will be used in HomeViewController
                print("\(getGroupName)")
                print("\(self.uid)") //may print old uid before
                
                //************** check creators node for leaders uid ***********
                
                ref.child("creators").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let value = snapshot.value as? NSDictionary
                    
                    let leaderUid = value?[getGroupName] as? String ?? ""
                    
                    self.chosenUser.didSelectUser(type: "follower", groupName: self.getGroupName, uid: leaderUid, update: true)
                    self.uid = leaderUid
                    // ...
                }) { (error) in
                    print(error.localizedDescription)
                }
                
                taken = true
                completion(taken) //exiting closure passing true
            }
        })
    }
    
    func presentAlert(_ groupName: String,_ passMessage: String) { //present alert group name is taken
        //
        
        let alert = UIAlertController(title: "Error: \(groupName)", message: passMessage, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Back", style: .default, handler: nil)
        
        alert.addAction(ok)
        
        present(alert, animated: true)
        
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    func addToFirebase(_ groupName: String,_ gotUid: String) { //adds a reserve placeholder in database
        
        //        guard currentUserUid == uid else {
        //            return
        //        }
        
        let ref = Database.database().reference()
        ref.child("\(groupName)/\(gotUid)/\(groupName)").setValue("reserved") //making a placeholder
        
        //Add to creators node
        print(gotUid)
        ref.child("creators/\(groupName)").setValue(gotUid)
    }
    
    func getUid() -> String {
        if Auth.auth().currentUser != nil {
            let user = Auth.auth().currentUser!
            
            self.uid = user.uid
            return user.uid
        }
        return "a" //won't ever execute
        
    }
    
    func saveNameCore(){ //saving groupName to Core Data
        let coreSave = SavedGroup(context: dataController!.viewContext) //defining persisted pin attribute data
        coreSave.name = getGroupName
        coreSave.permType = usrPerm
        coreSave.uid = uid
        
        try? dataController!.viewContext.save() //saving groupname object and it's attributes
        coreGroupName.append(coreSave)
    }
    
    func deleteCoreGroup() { //deletes everything from core Data everytime
        guard !coreGroupName.isEmpty else {
            return
        }
        for i in 0..<coreGroupName.count { //delete everything
            dataController!.viewContext.delete(coreGroupName[i])
            try? dataController!.viewContext.save()
        }
        coreGroupName.removeAll() //emptying array
    }
    
    func notify() { //notification to run viewDidAppear in HomeViewController
        coreGroupName2 = coreGroupName
        deleteCoreGroup() //deleting coreGroupName
        coreGroupName = coreGroupName2 //reassigning value for save
        saveNameCore() //saving new groupName to core data
        
        print(Thread.current)
        
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name("ViewDidAppear"), object: nil)
    }
    
}
