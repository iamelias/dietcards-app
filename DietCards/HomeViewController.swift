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
    
    var selectedCard = 8 //default card setting
    
    var retrievedCalSum = 0.0
    
    var permType = "" //will change to indicate permission type group creator or member
    
    var userEmail = "" //user details
    var userUid = ""
    
    var getUserEmailInput = ""
    
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
         
        if Auth.auth().currentUser != nil {
            let user = Auth.auth().currentUser!

            self.userEmail = user.email!
            self.userUid = user.uid
        
    }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
       NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func joinGroupTapped(_ sender: Any) {
      
        let selectedVC = storyboard?.instantiateViewController(withIdentifier: "AddGroupController") as! AddGroupController
        selectedVC.chosenUser = self
                
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
                
//MARK: DATA FOR CARDTABLECONTROLLER
                vc?.uid = self.userUid // current user uid
                
                if permType == "leader" {
                    vc?.email = self.userEmail                 }
                
                else if permType == "follower" {
                    
                    vc?.email = self.getUserEmailInput
                    
                }
                
              //  vc?.email = self.userEmail // current user email
                vc?.memberOfEmail = self.getUserEmailInput //for join group people
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
