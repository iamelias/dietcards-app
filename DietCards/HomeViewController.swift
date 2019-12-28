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

class HomeViewController: UIViewController {
    
    var selectedCard = 8 //default card setting
    
    var retrievedCalSum = 0.0
    
    var permType = "" //will change to indicate permission type group creator or member
    
    var userEmail = "" //user details
    var userUid = ""
    
    var getGroupNameInput = ""
    
    var updatedAlert: Bool = false
    
    var firstTimeRun: Bool = true
    
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
       NotificationCenter.default.removeObserver(self)
                
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
            //sleep(1)
            pulseAnim()
        }
        
        
        if firstTimeRun == true {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            let weekDay = dateFormatter.string(from: Date())
            
            
        
        collectionView.selectItem(at: [0,Days2[weekDay]!], animated: false, scrollPosition: .centeredHorizontally) //Displaying current weekday at center of view
            
            firstTimeRun = false
        }
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
    
//    @IBAction func dayButtonTapped(_ sender: Any) {
//
//
//        collectionView.contentOffset = CGPoint(x: 50.0, y: 0.0)
//        let button = sender as! UIButton
//        print("Button: \(button.tag) was pressed")
//        collectionView.reloadData()
//
//        switch button.tag { //positions when day button is tapped
//        case 1: collectionView.contentOffset = CGPoint(x: 0.0, y: 0.0)
//        case 2: collectionView.contentOffset = CGPoint(x: 150.0, y: 0.0)
//        case 3: collectionView.contentOffset = CGPoint(x: 385.0, y: 0.0)
//        case 4: collectionView.contentOffset = CGPoint(x: 625.0, y: 0.0)
//        case 5: collectionView.contentOffset = CGPoint(x: 830.0, y: 0.0)
//        case 6: collectionView.contentOffset = CGPoint(x: 1075.0, y: 0.0)
//        case 7: collectionView.contentOffset = CGPoint(x: 1360.0, y: 0.0)
//        default:
//            collectionView.contentOffset = CGPoint(x: 0.0, y: 0.0)
//        }
//    }
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
        
        if joinGroupButton.titleLabel?.text == "Join Group" {
            cell.backgroundColor = .red
        }
        
        cell.configureCell(data[indexPath.row])
        return cell
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
    
    
}

extension HomeViewController: TypeOfUserDelegate {
    
    func didSelectUser(type: String, groupName: String) { //recieving group type and email
        updatedAlert = true
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
