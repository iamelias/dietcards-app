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

class HomeViewController: UIViewController {
    
    var selectedCard = 8 //default card setting
    
    var retrievedCalSum = 0.0
    
    var permType = "" //will change to indicate permission type group creator or member
    
    var userEmail = "" //user details
    var userUid = ""
    
    var getGroupNameInput = ""
    
    var updatedAlert: Bool = false
    
    var firstTimeRun: Bool = true
    
    var gotCalTotals: Bool = false
    
    var currentWeekDay = ""
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var homeTitleLabel: UILabel!
    @IBOutlet weak var joinGroupButton: UIButton!
    @IBOutlet weak var hideColor: UIView!
    
    enum Days: Int {
        case Monday = 0
        case Tuesday = 1
        case Wednesday = 2
        case Thursday = 3
        case Friday = 4
        case Saturday = 5
        case Sunday = 6
    }
    
    var calTotalsArray:[Double] = []
    
    var Days2:[String:Int] = ["Monday": 0, "Tuesday": 1, "Wednesday": 2, "Thursday": 3, "Friday": 4, "Saturday": 5, "Sunday": 6]
    
    static let daysOfWeek: [String] = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
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
        
        hideColor.isHidden = false
        hideColor.backgroundColor = .gray
        //hideColor.isOpaque = false
        hideColor.alpha = 0.5
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
         
        if Auth.auth().currentUser != nil {
            let user = Auth.auth().currentUser!

            self.userEmail = user.email!
            self.userUid = user.uid
        
    }
        
        print("ViewWill Appear called")

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
print("aaaaaaaaaaaaaaaaaaaa")
       NotificationCenter.default.removeObserver(self)
                print("ViewDidAppear called")
 if updatedAlert == true {
    hideColor.isHidden = true
         if permType == "leader" {
            let message = "You've created: \(getGroupNameInput)"
            let updateTitle = "Created"

        createJoinAlert(updateTitle, message)
        }
        
        else if permType == "follower" {
        let message = "You've joined: \(getGroupNameInput)"
        let updateTitle = "Joined"

        createJoinAlert(updateTitle, message)
    }
     }
    
        if joinGroupButton.titleLabel?.text == "Join Group" {
            pulseAnim()
        }
        
        
        if firstTimeRun == true {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE" //weekday format ex. Monday
            let weekDay = dateFormatter.string(from: Date())
            currentWeekDay = weekDay //storing day of week
            
            
        
        collectionView.selectItem(at: [0,Days2[weekDay]!], animated: false, scrollPosition: .centeredHorizontally) //Displaying current weekday at center of view
            
            firstTimeRun = false
        }
        getCalTotalsFirebase()

        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for cell in collectionView.visibleCells {
            let indexPath = collectionView.indexPath(for: cell)
            print(indexPath!)
//            collectionView.selectItem(at: [3,0], animated: true, scrollPosition: .centeredHorizontally)
        }
    }
    
    
    @IBAction func joinGroupTapped(_ sender: Any) {
        
        joinGroupButton.isHighlighted = false

        let selectedVC = storyboard?.instantiateViewController(withIdentifier: "AddGroupController") as! AddGroupController
        selectedVC.chosenUser = self
                
        present(selectedVC, animated: true, completion: dismissResponse)
    }
    
    func dismissResponse() {
        
        //let a = collectionView.layer.position
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(viewDidAppear), name: Notification.Name("ViewDidAppear"), object: nil)
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
        
        //print("Cell Collection Called")
        
        let data = HomeViewController.daysOfWeek
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        
        if joinGroupButton.titleLabel?.text == "Join Group" {
            cell.backgroundColor = .red
        }
        
        if gotCalTotals == false {
        print("Made to 8")
        print("Made it 9")
            cell.configureCell(data[indexPath.row], 0.0)
            return cell
        }
        
        else if gotCalTotals == true {
            print(calTotalsArray)
            print("bbbbbbbbbbbbbbbbb")
        cell.configureCell(data[indexPath.row], calTotalsArray[indexPath.row])
        return cell
        }
        
        else {
            print("some error")
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard joinGroupButton.titleLabel?.text != "Join Group" else {
            return
        }
        performSegue(withIdentifier: "pushDetailView", sender: indexPath.row) //segue to CardTableViewController
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pushDetailView" { //segue used pushes to collectionView

            if segue.destination is CardTableViewController
            {
                let vc = segue.destination as? CardTableViewController //seguing to CardTableViewController
                
                vc?.uid = self.userUid // current user uid
                
                if permType == "leader" {
                    vc?.groupName = self.getGroupNameInput
                    
                }
                
                else if permType == "follower" {
                    
                    vc?.groupName = self.getGroupNameInput
                }
                
                vc?.selectedCard = sender as! Int //passing user selected day card as digit 0-6(Mon-Sun)
            }
        }
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
    
    func getCalTotalsFirebase() {
       // collectionView.reloadData()
        let ref = Database.database().reference()
        print("Made it 1")
        print(getGroupNameInput)
        print(selectedCard)
        
            ref.child("\("space")/\("calTotal")").observeSingleEvent(of: .value, with: { (snapshot) in
                
            print("Made it 2")
                print(snapshot.value)
        guard let value = snapshot.value as? NSDictionary else { //if there are no saved records return
            print("There are no saved records")
            print("Made it 3 - Error")
            return
        }
                print("made it 4")
           // for item in value {
                print("Made it 5")
                let detailDictionary = value //as! NSDictionary
                let mon = detailDictionary["0"] as? Double ?? 0.0 // ex. 0
                let tue = detailDictionary["1"] as? Double ?? 0.0 // ex. 0
                let wed = detailDictionary["2"] as? Double ?? 0.0 // ex. 0
                let thu = detailDictionary["3"] as? Double ?? 0.0 // ex. 0
                let fri = detailDictionary["4"] as? Double ?? 0.0 // ex. 0
                let sat = detailDictionary["5"] as? Double ?? 0.0 // ex. 0
                let sun = detailDictionary["6"] as? Double ?? 0.0 // ex. 0
                
                self.calTotalsArray.removeAll()
                
                self.calTotalsArray.append(mon)
                self.calTotalsArray.append(tue)
                self.calTotalsArray.append(wed)
                self.calTotalsArray.append(thu)
                self.calTotalsArray.append(fri)
                self.calTotalsArray.append(sat)
                self.calTotalsArray.append(sun)
                print("Made it 6")
                
                
                print(self.calTotalsArray[0])
                print(self.calTotalsArray[1])
                
                
                var calTotal = CalorieTotals()
                calTotal.Monday = mon
                calTotal.Tuesday = tue
                calTotal.Wednesday = wed
                calTotal.Thursday = thu
                calTotal.Friday = fri
                calTotal.Saturday = sat
                calTotal.Sunday = sun
                
               // self.collectionView.reloadData()
                self.gotCalTotals = true

                print("Made it 7")
            })
        
    }
    
}

extension HomeViewController: TypeOfUserDelegate {
    
    func didSelectUser(type: String, groupName: String) { //recieving group type and email
        getCalTotalsFirebase()
        updatedAlert = true
        gotCalTotals = true
        permType = type // retrieved userType from AddGroupController
        getGroupNameInput = groupName
        
        if type == "follower" {
        joinGroupButton.setTitle(getGroupNameInput, for: .normal)
    
        }
        
        else if type == "leader" {
            joinGroupButton.setTitle(getGroupNameInput, for: .normal)
        }
    }
}
