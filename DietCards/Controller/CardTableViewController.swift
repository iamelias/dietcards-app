//
//  CardDetailViewController.swift
//  DietCards
//
//  Created by Elias Hall on 11/16/19.
//  Copyright © 2019 Elias Hall. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseUI

class CardTableViewController: UIViewController {
    
    var ref: DatabaseReference! // reference to Firebase database
    var retrievedFood: NutritionData?
    var tempFoodIdHolder = ""
    var selectedCard: Int = 0 //selected card num from previous controller 0-6(Mon-Sun)
    var groupName: String = "" //current user email or group's email - from previous vc
    var usrPerm: String = "" //usr permission type "leader"/"follower" - from previous vc
    var uid: String = "" //will use to find leaders data branch. This is group leaders uid
    var currentUsrUid = "" //This is current usrs uid
    //var currentDay = ""
    
    //4 arrays below are populated with Firebase saved food data
    var breakfastArray: [NutritionData] = []
    var lunchArray: [NutritionData] = []
    var dinnerArray: [NutritionData] = []
    var snackArray: [NutritionData] = []
    
    
    var calSum: Double = 0 //for future project addition
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! //displayed during download
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem! //used to control access to AddFoodController
    @IBOutlet weak var navTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isHidden = true
        navTitle.text = DaysDictionary[selectedCard]
        navTitle.textAlignment = .center
        
        let currentUsrUid = getCurrentUsrUid()
        
        if currentUsrUid != uid { //if current usrs uid and group leaders uid are not equal
            addButton.isEnabled = false //current usr is not leader and he/she can't edit
        }
        activityIndicator.isHidden = false
        activityIndicator.startAnimating() //activity indicator animates during
        tableView.separatorColor = .black
        tableView.separatorStyle = .singleLine
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none //removes lines in between cells
        tableView.allowsSelection = false
        
    }
    
    func getDayFromCard() -> String {
        
        var fireBaseCard = "" //to be used for firebase call
        
        switch selectedCard { //choosing dayCard string using dayCard int, to be used for firebase read
        case 0: fireBaseCard = "Monday"
        case 1: fireBaseCard = "Tuesday"
        case 2: fireBaseCard = "Wednesday"
        case 3: fireBaseCard = "Thursday"
        case 4: fireBaseCard = "Friday"
        case 5: fireBaseCard = "Saturday"
        case 6: fireBaseCard = "Sunday"
        default: print("Error in selected card switch array")
        }
        
        return fireBaseCard
    }
    
    func getCurrentUsrUid() -> String { //getting current usrs uid for comparison.
        
        if Auth.auth().currentUser != nil {
            let user = Auth.auth().currentUser!
            currentUsrUid = user.uid
        }
        
        return currentUsrUid
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        calSum = 0.0 //is necessary?
        
        loadFirebaseData() //calling realtime database
        
        activityIndicator.isHidden = true
        
        tableView.reloadData()
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        
        
        dismiss(animated: true, completion: nil) //when back button dismiss
    }
    
    @IBAction func addFoodTapped(_ sender: Any) {  //when add button is tapped...
        
        let addFoodVC = storyboard?.instantiateViewController(withIdentifier: "AddFoodItemController") as! AddFoodItemController
        
        addFoodVC.passedInDay = selectedCard //sending selected day data to AddFoodItemController
        addFoodVC.passedInGroupName = groupName
        addFoodVC.uid = uid
        addFoodVC.modalPresentationStyle = .fullScreen
        
        present(addFoodVC, animated: true, completion: nil ) // presenting AddFoodItemController
        
    }
    
    func sumCalories(_ foodCal: Double) { //For future project addition-ignore
        
        self.calSum += foodCal
    }
}

// MARK: - TableView Delegate and DataSource - BEGIN

extension CardTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4 //Breakfast,Lunch,Dinner,Snack
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return array count for each section
        if section == 0 {
            guard breakfastArray.count != 0 else {
                return 1
            }
            return breakfastArray.count
        }
        if section == 1 {
            guard lunchArray.count != 0 else {
                return 1
            }
            return lunchArray.count
        }
        if section == 2 {
            guard dinnerArray.count != 0 else {
                return 1
            }
            return dinnerArray.count
        }
        if section == 3 {
            guard snackArray.count != 0 else {
                return 1
            }
            return snackArray.count
        }
        else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.backgroundColor = .clear
        
        label.font = .boldSystemFont(ofSize: 17)
        if section == 0 {
            label.text = "Breakfast"
        }
        if section == 1 {
            label.text = "Lunch"
        }
        if section == 2 {
            label.text = "Dinner"
        }
        if section == 3 {
            label.text = "Snack"
        }
        return label
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { //format of cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell")!
        cell.detailTextLabel!.text = ""
        cell.isHighlighted = false
        tableView.backgroundColor = .groupTableViewBackground
        
        cell.textLabel?.text = "empty"
        cell.detailTextLabel!.isHidden = true
        
        cell.textLabel?.textColor = .lightGray
        cell.layer.cornerRadius = 10 //rounding corners of cell
        cell.layer.masksToBounds = true
        cell.layer.shadowOffset = CGSize(width: 5, height: 5)
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.25
        cell.layer.shadowRadius = 4
        
        cell.detailTextLabel!.isHidden = false
        cell.detailTextLabel!.textColor = .black
        
        if indexPath.section == 0 {
            cell.detailTextLabel!.isHidden = false
            cell.detailTextLabel!.textColor = .black
            if breakfastArray.count != 0 {
                
                cell.textLabel!.textColor = .black
                cell.textLabel!.text = breakfastArray[indexPath.row].foodName
                tempFoodIdHolder = breakfastArray[indexPath.row].id
                if !breakfastArray.isEmpty {
                    cell.detailTextLabel!.text = "\(breakfastArray[indexPath.row].nutrition) kcal"
                }
            }
        }
        
        if indexPath.section == 1 {
            cell.detailTextLabel!.isHidden = false
            cell.detailTextLabel!.textColor = .black
            if lunchArray.count != 0 {
                cell.textLabel?.textColor = .black
                cell.textLabel!.text = lunchArray[indexPath.row].foodName
                cell.detailTextLabel!.text = "\(lunchArray[indexPath.row].nutrition) kcal"
            }
        }
        
        if indexPath.section == 2 {
            cell.detailTextLabel!.isHidden = false
            cell.detailTextLabel!.textColor = .black
            if dinnerArray.count != 0 {
                cell.textLabel?.textColor = .black
                cell.textLabel!.text = dinnerArray[indexPath.row].foodName
                cell.detailTextLabel!.text = "\(dinnerArray[indexPath.row].nutrition) kcal"
            }
        }
        if indexPath.section == 3 {
            cell.detailTextLabel!.isHidden = false
            cell.detailTextLabel!.textColor = .black
            if snackArray.count != 0 {
                cell.textLabel?.textColor = .black
                cell.textLabel!.text = snackArray[indexPath.row].foodName
                cell.detailTextLabel!.text = "\(snackArray[indexPath.row].nutrition) kcal"
                
            }
        }
        activityIndicator.stopAnimating()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle:UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard currentUsrUid == uid else {
            return
        }
        
        if indexPath.section == 0 {
            
            
            if breakfastArray.count == 1 || breakfastArray.count == 0 {
                if breakfastArray.isEmpty {
                    return
                }
                firebaseDelete(breakfastArray[indexPath.row].id, "Breakfast") //passing in foodid unique to the indexpath.row
                breakfastArray.removeAll()
                
                tableView.reloadData()
            }
            else {
                
                firebaseDelete(breakfastArray[indexPath.row].id, "Breakfast") //passing in foodid unique to the indexpath.row
                breakfastArray.remove(at: indexPath.row)
                
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
        if indexPath.section == 1 {
            if lunchArray.count == 1 || lunchArray.count == 0 {
                if lunchArray.isEmpty {
                    return
                }
                firebaseDelete(lunchArray[indexPath.row].id, "Lunch") //passing in foodid unique to the indexpath.row
                lunchArray.removeAll()
                tableView.reloadData()
            }
            else {
                firebaseDelete(lunchArray[indexPath.row].id, "Lunch") //passing in foodid unique to the indexpath.row
                lunchArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
        
        if indexPath.section == 2 {
            if dinnerArray.count == 1 || dinnerArray.count == 0 {
                if dinnerArray.isEmpty {
                    return
                }
                //MARK: Where I want to delete from database
                firebaseDelete(dinnerArray[indexPath.row].id, "Dinner") //passing in foodid unique to the indexpath.row
                dinnerArray.removeAll()
                tableView.reloadData()
            }
            else {
                firebaseDelete(dinnerArray[indexPath.row].id, "Dinner")
                //passing in foodid unique to the indexpath.row
                dinnerArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
        
        if indexPath.section == 3 {
            if snackArray.count == 1 || snackArray.count == 0 {
                if snackArray.isEmpty {
                    return
                }
                firebaseDelete(breakfastArray[indexPath.row].id, "Snack") //passing in foodid unique to the indexpath.row
                snackArray.removeAll()
                tableView.reloadData()
            }
            else {
                firebaseDelete(snackArray[indexPath.row].id, "Snack") //passing in foodid unique to the indexpath.row
                snackArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    func firebaseDelete(_ uniqueID: String,_ mealType: String){ //deletes indexpath
        
        let fireBaseCard = getDayFromCard()//to be used for firebase call
        let ref = Database.database().reference()
        ref.child("\("\(groupName)")/\(uid)/\("\(groupName)")/\("\(fireBaseCard)")/\(mealType)/\("\(uniqueID)")").setValue(nil)
    }
    
    func loadFirebaseData() { //reading all saved food items from firebase realtime database, saving them to breakfastArray,lunchArray,dinnerArray,andSnackArray. Then reloading the table to display data.
        let ref = Database.database().reference()
        
        //clearing all array for fresh reload whenever view controller is called.
        breakfastArray.removeAll()
        lunchArray.removeAll()
        dinnerArray.removeAll()
        snackArray.removeAll()
        
        let fireBaseCard = getDayFromCard() //to be used for firebase call
        
        ref.child("\(groupName)/\(uid)/\(groupName)/\(fireBaseCard)").observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let value = snapshot.value as? NSDictionary else { //if there are no saved records return
                print("There are no saved records")
                //                self.loadFirebaseData()
                return
            }
            
            for item in value { // iterating through breakfast,lunch,dinner,snack
                let uniqueKey = item.value as! NSDictionary // mealtime value is unique key
                
                for innerItem in uniqueKey { //for each unique key...
                    let detailDictionary = innerItem.value as! NSDictionary// detail Key ex. foodName,nutrition
                    
                    //storing detail Key values in constants.
                    let dayCard = detailDictionary["dayCard"] as? Int ?? 0 // ex. 0
                    let foodName = detailDictionary["foodName"] as? String  ?? ""//ex. "apple"
                    let foodid = detailDictionary["foodid"] as? String ?? "" // ex. "kjsfakl;fjkla;dfkal;f"
                    let mealTime = detailDictionary["mealTime"] as?  String ?? "" // ex. "Breakfast"
                    let nutrition = detailDictionary["nutrition"] as?  Double ?? 0.0 // ex. 56.43
                    
                    var foodItem = NutritionData() //making foodItem object type NutritionData
                    foodItem.dayCard = dayCard
                    foodItem.foodName = foodName
                    foodItem.id = foodid
                    foodItem.mealTime = mealTime
                    foodItem.nutrition = nutrition
                    
                    switch mealTime { //sorting foodObject into corresponding array for table population
                    case "Breakfast": self.breakfastArray.append(foodItem)
                    case "Lunch": self.lunchArray.append(foodItem)
                    case "Dinner": self.dinnerArray.append(foodItem)
                    case "Snack": self.snackArray.append(foodItem)
                    default: print("Error in adding foodItem to tableView")
                    }
                    self.tableView.reloadData() //reload table after each arrayappend for visual
                    self.sumCalories(foodItem.nutrition) // calculates sum
                }
            }
        })
    }
}
