//
//  HomeViewController.swift
//  DietCards
//
//  Created by Elias Hall on 11/15/19.
//  Copyright © 2019 Elias Hall. All rights reserved.
//

import UIKit
import FirebaseUI
import Foundation
import FirebaseDatabase
import CoreData

class HomeViewController: UIViewController {
    
    var selectedCard = 8 //default card setting
    var permType = "" //will change to indicate permission type group creator or member
    var userUid = ""
    var getGroupNameInput = "" //changed in delegate when returning from AddGroupController
    var updatedAlert: Bool = false//changed in delegate when returning from AddGroupContro..
    var firstTimeRun: Bool = true //changed in viewDidAppear after first run
    var gotCalTotals: Bool = false
    var coreGroupName: [SavedGroup] = [] //from LoginViewController
    var calTotalsArray:[Double] = [] //Stores total calories index = day card
    var useFirebase: Bool = false
    var currentUserUid = ""
    var dataController: DataController?
    let ref = Database.database().reference() //For Firebase database call
    
    
    enum Days: Int {
        case Monday = 0
        case Tuesday = 1
        case Wednesday = 2
        case Thursday = 3
        case Friday = 4
        case Saturday = 5
        case Sunday = 6
    }
    
    static let daysOfWeek: [String] = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    var Days2:[String:Int] = ["Monday": 0, "Tuesday": 1, "Wednesday": 2, "Thursday": 3, "Friday": 4, "Saturday": 5, "Sunday": 6]
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var homeTitleLabel: UILabel!
    @IBOutlet weak var joinGroupButton: UIButton!
    @IBOutlet weak var hideColor: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.backItem?.backBarButtonItem = .none
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.locale = Locale(identifier: "en_US")
        homeTitleLabel.text = dateFormatter.string(from: Date())
        homeTitleLabel.textColor = .black
        
        joinGroupButton.setTitle("Join Group", for: .normal) //default title
        
        hideColor.isHidden = false
        hideColor.backgroundColor = .gray
        hideColor.alpha = 0.5
        calTotalsArray = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0] //default
        
        if !coreGroupName.isEmpty { //if coreGroupName Array is not empty...
            //Join Group button's title to index 0 name
            var coreCheck = coreGroupName[0].name!
            permType = coreGroupName[0].permType!
            userUid = coreGroupName[0].uid!
            getGroupNameInput = coreCheck
            hideColor.isHidden = true
            print("coreGroupName[0].name: \(coreCheck)")
            
            if coreCheck == "" {
                print("reassigning empty string to Join Group")
                coreCheck = "Join Group"
            }
            joinGroupButton.setTitle(coreCheck, for: .normal) //setting join button title to savedCoreData name at index 0
            //getCalTotalsFirebase() //future project addition
        }
        else {
            print("coreGroupName is empty/ nothing saved in core data")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self) //removing notification observer
        
        if updatedAlert == true { // when returning from AddGroupController...
            joinGroupButton.setTitle(getGroupNameInput, for: .normal) //default title
            
            hideColor.isHidden = true //hide the hidecolor uiview
            if permType == "leader" { //alert if you created group
                let message = "You've created: \(getGroupNameInput)"
                let updateTitle = "Created"
                
                createJoinAlert(updateTitle, message) //calling alert
            }
                
            else if permType == "follower" { //message if you joined group
                let message = "You've joined: \(getGroupNameInput)"
                let updateTitle = "Joined"
                
                createJoinAlert(updateTitle, message) //calling alert
            }
            updatedAlert = false //resetting
        }
        
        if joinGroupButton.titleLabel?.text == "Join Group" {//making join button animate if Join Grop is the label
            pulseAnim() //calling pulse animation
        }
        
        if firstTimeRun == true { //Making scrollview middle cell, same as current day of the week.
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE" //weekday format ex. Monday
            let weekDay = dateFormatter.string(from: Date())
            
            collectionView.selectItem(at: [0,Days2[weekDay]!], animated: false, scrollPosition: .centeredHorizontally) //Displaying current weekday at center of view
            
            firstTimeRun = false
        }
        
        if useFirebase == true { //controlling use of firebase
            //getCalTotalsFirebase() //database recalled after updating AddGroup. Getting new nutrition
            useFirebase = false //resetting
        }
        
    }
    
    func getCurrentUserUID() {
        if Auth.auth().currentUser != nil {
            let user = Auth.auth().currentUser!
            currentUserUid = user.uid
            
        }
    }
    
    @IBAction func joinGroupTapped(_ sender: Any) {
        
        joinGroupButton.isHighlighted = false //turning off highlight at tap
        let selectedVC = storyboard?.instantiateViewController(withIdentifier: "AddGroupController") as! AddGroupController //seguing to AddGroupVC
        selectedVC.chosenUser = self //for didSelectUser delegate below
        selectedVC.dataController = dataController //passing dataController container
        selectedVC.coreGroupName = coreGroupName //passing persisted array
        selectedVC.uid = userUid
        selectedVC.currentUserUid = currentUserUid
        
        present(selectedVC, animated: true, completion: dismissResponse)
    }
    
    func dismissResponse() { //Set up condition to prevent firebase call when this called
        
        useFirebase = true
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(viewDidAppear), name: Notification.Name("ViewDidAppear"), object: nil)
    }
    
    func saveNameCore(){ //saving groupName to Core Data
        let coreSave = SavedGroup(context: dataController!.viewContext) //defining persisted pin attribute data
        coreSave.name = "space"
        try? dataController!.viewContext.save() //saving pin object and it's new attributes
        coreGroupName.append(coreSave)
    }
    
    func deleteCoreGroup() { //deletes the saved groupName from core data
        dataController!.viewContext.delete(coreGroupName[0])
        try? dataController!.viewContext.save()
        coreGroupName.removeAll()
    }
    
    func getCalTotalsFirebase() { //For future project addition- grader ignore method
        
        guard !coreGroupName.isEmpty else { //if coreGroup is empty don't execute anymore
            calTotalsArray = [0.0,0.0,0.0,0.0,0.0,0.0,0.0] //so doesn't crash
            //collectionView.reloadData()
            return
            
            //This function is never called if calling getCalTotalsFirebase from viewDidLoad
        }
        ref.child("\(getGroupNameInput)/\(userUid)/\(getGroupNameInput)").child("calTotal").observeSingleEvent(of: .value, with: { (snapshot) in //reading nutrition calories from space
            
            guard let value = snapshot.value as? NSDictionary else { //if there are no saved records return
                
                return
            }
            let detailDictionary = value //as! NSDictionary
            let mon = detailDictionary["0"] as? Double ?? 0.0 // ex. 0
            let tue = detailDictionary["1"] as? Double ?? 0.0 // ex. 0
            let wed = detailDictionary["2"] as? Double ?? 0.0 // ex. 0
            let thu = detailDictionary["3"] as? Double ?? 0.0 // ex. 0
            let fri = detailDictionary["4"] as? Double ?? 0.0 // ex. 0
            let sat = detailDictionary["5"] as? Double ?? 0.0 // ex. 0
            let sun = detailDictionary["6"] as? Double ?? 0.0 // ex. 0
            
            self.calTotalsArray.removeAll() //emptying array for each call
            
            self.calTotalsArray.append(mon)
            self.calTotalsArray.append(tue)
            self.calTotalsArray.append(wed)
            self.calTotalsArray.append(thu)
            self.calTotalsArray.append(fri)
            self.calTotalsArray.append(sat)
            self.calTotalsArray.append(sun)
            
            //                var calTotal = CalorieTotals() //**** Check if necessary
            //                calTotal.Monday = mon
            //                calTotal.Tuesday = tue
            //                calTotal.Wednesday = wed
            //                calTotal.Thursday = thu
            //                calTotal.Friday = fri
            //                calTotal.Saturday = sat
            //                calTotal.Sunday = sun
            
            self.gotCalTotals = true
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        })
    }
    
    func pulseAnim() { //making join button pulsate to catch users eye.
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.6 //time of animation
        pulse.fromValue = 1 //from size of 95%
        pulse.toValue = 0.95 // to 100%
        pulse.repeatCount = 2 //pulses 2 times
        pulse.initialVelocity = 0.04
        pulse.damping = 1.0
        pulse.autoreverses = true
        pulse.speed = 0.2
        
        joinGroupButton.layer.add(pulse, forKey: nil)
    }
    
    func createJoinAlert(_ useTitle: String, _ useMessage: String) {
        
        DispatchQueue.main.async {
            let alert1 = UIAlertController(title: useTitle, message: useMessage, preferredStyle: .alert) //alert for after creating or joining group
            
            let contAction = UIAlertAction(title: "Continue", style: .default, handler: nil)
            
            alert1.addAction(contAction)
            self.updatedAlert = false
            self.present(alert1, animated: true)
        }
        return
    }
}

//MARK:  Collection View Code

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 7
    }
    
    //MARK: CELL DEFINITION
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let data = HomeViewController.daysOfWeek
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        
        if gotCalTotals == false { //0.0 calorie label if nutrition not called
            cell.configureCell(data[indexPath.row], 0.0)
            gotCalTotals = false //resetting to false for next call
            return cell
        }
            
        else if gotCalTotals == true { //change cell calorie label to nutrition value
            cell.configureCell(data[indexPath.row], calTotalsArray[indexPath.row])
            if indexPath.row == 6 {
                gotCalTotals = true
            }
            return cell
        }
            
        else {
            print("error")
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard joinGroupButton.titleLabel?.text != "Join Group" else { //don't segue if join group label is "Join Group"
            return
        }
        performSegue(withIdentifier: "pushDetailView", sender: indexPath.row) // if label is not "Join Group" segue to CardTableViewController
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pushDetailView" { //segue used pushes to collectionView
            
            if segue.destination is CardTableViewController
            {
                let vc = segue.destination as? CardTableViewController //seguing to CardTableViewController
                
                vc?.uid = self.userUid // current user uid
                
                //could simplify below into one permtype send sending variables
                if permType == "leader" { //if permission type is leader...
                    vc?.groupName = self.getGroupNameInput //send leaders name to next vc
                    vc?.usrPerm = "leader"
                }
                    
                else if permType == "follower" { //if permission type is follower...
                    vc?.groupName = self.getGroupNameInput //send follower name to next vc
                    vc?.usrPerm = "follower"
                }
                
                vc?.selectedCard = sender as! Int //passing user selected day card as digit 0-6(Mon-Sun)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updatedAlert = false
    }
}

extension HomeViewController: TypeOfUserDelegate {
    
    func didSelectUser(type: String, groupName: String, uid: String, update: Bool) { //recieving group type and email
        
        updatedAlert = update //Control flow of viewDidAppear
        gotCalTotals = true //used to control whether firebase is called or not
        permType = type // permission type create group returns "leader", join group returns "follower"
        getGroupNameInput = groupName //assigning retrieved group name class variable
        userUid = uid
        
        if type == "follower" {
            joinGroupButton.setTitle(getGroupNameInput, for: .normal) //changing join button to group chosen in AddGroupController
        }
            
        else if type == "leader" {
            joinGroupButton.setTitle(getGroupNameInput, for: .normal)//changing join button to group chosen in AddGroupController
        }
    }
}
