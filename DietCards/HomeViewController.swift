//
//  HomeViewController.swift
//  DietCards
//
//  Created by Elias Hall on 11/15/19.
//  Copyright © 2019 Elias Hall. All rights reserved.
//

import UIKit
import FirebaseUI

class HomeViewController: UIViewController {
    
    // prompts user to answer if they are a Leader of Member? Leader = True, Member = False
    //sends response to next view controller along with selectedCard
    //Updates title Label to indicate if you are a member or leader
    
    //var leader: Bool = false //to pass to next view controller for database call
    var selectedCard = 8 //default card setting
    
    var retrievedCalSum = 0.0
    
    var permType = "" //will change to indicate permission type group creator or member
    
    
    var leader: Bool = false
    var userEmail = "" //user details
    var userUid = ""
    
    
    var getUserEmailInput = ""
    
    var amILeader:Bool = false

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var homeTitleLabel: UILabel!
    @IBOutlet weak var joinGroupButton: UIButton!
    
    enum Days: String {
        case Monday
        case Tuesday
        case Wednesday
        case Thursday
        case Friday
        case Saturday
        case Sunday
    }
    
    static let daysOfWeek: [String] = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.backItem?.backBarButtonItem = .none
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.locale = Locale(identifier: "en_US")
        homeTitleLabel.text = dateFormatter.string(from: Date())
        homeTitleLabel.textColor = .black
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        whatAreYou()
        print("^^^^&&&&****((((")
        print(amILeader)
       // print(amILeader)
        print("^^^^&&&&****((((")

        
        if Auth.auth().currentUser != nil {
            print("(((((()))))))********")
            let user = Auth.auth().currentUser!
            let myemail = user.email
            let myuserid = user.uid
            
            self.leader = true
            self.userEmail = user.email!
            self.userUid = user.uid
            
            
            //will use to create nodes and to determine access
            print(myemail!) //users email
            print(myuserid) //users uid
            
          
            print("(((((()))))))********")

            
        }
        
        print("Home View Will Appear Called")
    }
    
    override func viewDidAppear(_ animated: Bool) {

        print("@@@@@@@@@@")
        print(permType) //gets replaced with leader or follower when selected
        print(getUserEmailInput)
        
//        if getUserEmailInput != "" {
//
//            joinGroupButton.setTitle(getUserEmailInput, for: .normal)
//       // joinGroupButton.titleLabel?.text = getUserEmailInput
//        }

        print("@@@@@@@@@@")
        
       NotificationCenter.default.removeObserver(self)
    }
    
    func whatAreYou() { //This method asks if you are a leader or follower
        //returns if you are a follower or leader// will be used to determine
        
        //var isLeader: Bool = false //default is false =
        
        var isTrueLeader: Bool {
            
            return true
            
        }
        
        var isFollower: Bool {
            return false
        }
        
//
        
    }
    
//

    @IBAction func joinGroupTapped(_ sender: Any) {
        
        print("((((((((******&&&&&&&&&&&*****")
        print(getUserEmailInput)
        print("((((((((******&&&&&&&&&&&*****")
        
        let selectedVC = storyboard?.instantiateViewController(withIdentifier: "AddGroupController") as! AddGroupController
        selectedVC.chosenUser = self
        
        //selectedVC.
        
        present(selectedVC, animated: true, completion: dismissResponse)
    }
    
    func dismissResponse() {
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(viewDidAppear), name: Notification.Name("ViewDidAppear"), object: nil)
    }
    
    @IBAction func dayButtonTapped(_ sender: Any) {
        
        
        collectionView.contentOffset = CGPoint(x: 50.0, y: 0.0)
        let button = sender as! UIButton
        print("Button: \(button.tag) was pressed")
        collectionView.reloadData()
        
        switch button.tag { //positions when day button is tapped
        case 1: collectionView.contentOffset = CGPoint(x: 0.0, y: 0.0)
        case 2: collectionView.contentOffset = CGPoint(x: 150.0, y: 0.0)
        case 3: collectionView.contentOffset = CGPoint(x: 385.0, y: 0.0)
        case 4: collectionView.contentOffset = CGPoint(x: 625.0, y: 0.0)
        case 5: collectionView.contentOffset = CGPoint(x: 830.0, y: 0.0)
        case 6: collectionView.contentOffset = CGPoint(x: 1075.0, y: 0.0)
        case 7: collectionView.contentOffset = CGPoint(x: 1360.0, y: 0.0)
        default:
            collectionView.contentOffset = CGPoint(x: 0.0, y: 0.0)
        }
    }
}

//MARK: * Collection View Code *

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
        
        cell.configureCell(data[indexPath.row])
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "pushDetailView", sender: indexPath.row) //segue to CardTableViewController
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pushDetailView" { //segue used pushes to collectionView

            if segue.destination is CardTableViewController
            {
                let vc = segue.destination as? CardTableViewController //seguing to CardTableViewController
                
                vc?.leader = self.leader
                vc?.uid = self.userUid
                vc?.email = self.userEmail
                vc?.selectedCard = sender as! Int //passing user selected day card as digit 0-6(Mon-Sun)
            }
        }
    }
}

extension HomeViewController: TypeOfUserDelegate {
    
    func didSelectUser(type: String, email: String) { //recieving group type and email
        
        permType = type // retrieved userType from AddGroupController
        getUserEmailInput = email
        
        if type == "follower" {
        joinGroupButton.setTitle(getUserEmailInput, for: .normal)
        }
        
        else if type == "leader" {
            joinGroupButton.setTitle(userEmail, for: .normal)
        }
        

        
        
    }
}























//********************************

//    func promptForAnswer() {
//
//        self.amILeader = false
//        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
//        ac.addTextField()
//
//        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned ac] _ in
//            let answer = ac.textFields![0]
//
//            self.getUserEmailInput = answer.text ?? ""
//            // do something interesting with "answer" here
//        }
//
//        ac.addAction(submitAction)
//
//        present(ac, animated: true)
//    }

//************************************
        //promptForAnswer()
//
//        let alert = UIAlertController(title: "Leader or Follower?", message: "choose", preferredStyle: .alert)
//        let leaderOption = UIAlertAction(title: "Leader", style: .default, handler: { action in self.amILeader = true })
//
////        let followerOption = UIAlertAction(title: "Follower", style: .default, handler: {action in self.amILeader = false })
//
//        let followerOption = UIAlertAction(title: "Follower", style: .default, handler: {action in self.promptForAnswer()})
//
//
//
//        alert.addAction(leaderOption)
//        alert.addAction(followerOption)
//
//
//        present(alert, animated: true)
