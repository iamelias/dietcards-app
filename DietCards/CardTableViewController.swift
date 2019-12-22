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
    
    var retrievedFood: NutritionData?
    var foodsArray: [NutritionData] = [] //Stores food items
    var selectedCard: Int = 0 //selected card num from previous controller 0-6(Mon-Sun)
    var ref: DatabaseReference! // reference to Firebase database
    
    var leader: Bool = false // if true we will create new user, if false we will call uid
    var email: String = "" //will use to find leaders data brach or
    var uid: String = "" //will use to find leaders data branch
    
    //4 arrays below are populated with Firebase saved food data
    var breakfastArray: [NutritionData] = []
    var lunchArray: [NutritionData] = []
    var dinnerArray: [NutritionData] = []
    var snackArray: [NutritionData] = []
    
    var calSum: Double = 0 //necessary?
    static var calorieSum: Double = 0 //necessary?
    
    enum MT: String { //Meal Types
        case Breakfast
        case Lunch
        case Dinner
        case Snack
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isHidden = true
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        print("Selected Card: \(selectedCard)") //from HomeViewController
        tableView.separatorColor = .black
        tableView.separatorStyle = .singleLine
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none //removes lines in between cells
        tableView.allowsSelection = false
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //tableView.reloadData()
        
//        if Auth.auth().currentUser != nil {
//            print("(((((()))))))********")
//           // print(Auth.auth().currentUser!)
//            print("(((((()))))))********")
//
//        }
        
        print("***********((((((((((&&&&&&&&&&&&&&&")
        print(leader)
        print(email)
        print(uid)
        print(selectedCard)
        
        print("***********((((((((((&&&&&&&&&&&&&&&")


        loadFirebaseData()
        
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        
        
        
    }
    
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addFoodTapped(_ sender: Any) {
        
        let addFoodVC = storyboard?.instantiateViewController(withIdentifier: "AddFoodItemController") as! AddFoodItemController
        
        addFoodVC.passedInDay = selectedCard //sending selected day data to AddFoodItemController
        addFoodVC.modalPresentationStyle = .fullScreen
        
        present(addFoodVC, animated: true, completion: nil ) // presenting AddFoodItemController
        
    }
    
    func sumCalories(_ foodCal: Double) { //function calculates sum of calories
        
        self.calSum += foodCal
    }
}

// MARK: - TableView Delegate and DataSource - BEGIN

extension CardTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell")!
        cell.detailTextLabel!.text = ""
        cell.isHighlighted = false
        //cell.textLabel!.text = breakfastArray[indexPath.row]
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
        
        if indexPath.section == 0 {
            cell.detailTextLabel!.isHidden = false
            cell.detailTextLabel!.textColor = .black
            if breakfastArray.count != 0 {
                
                cell.textLabel!.textColor = .black
                cell.textLabel!.text = breakfastArray[indexPath.row].foodName
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
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle:UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
            if breakfastArray.count == 1 || breakfastArray.count == 0 {
                breakfastArray.removeAll()
                
                
                tableView.reloadData()
            }
            else {
                breakfastArray.remove(at: indexPath.row)
                
                tableView.deleteRows(at: [indexPath], with: .fade)
                
            }
        }
        
        if indexPath.section == 1 {
            
            if lunchArray.count == 1 || lunchArray.count == 0 {
                lunchArray.removeAll()
                
                
                tableView.reloadData()
            }
            else {
                lunchArray.remove(at: indexPath.row)
                
                tableView.deleteRows(at: [indexPath], with: .fade)
                
            }
        }
        
        if indexPath.section == 2 {
            
            if dinnerArray.count == 1 || dinnerArray.count == 0 {
                dinnerArray.removeAll()
                
                
                tableView.reloadData()
            }
            else {
                dinnerArray.remove(at: indexPath.row)
                
                tableView.deleteRows(at: [indexPath], with: .fade)
                
            }
        }
        
        if indexPath.section == 3 {
            
            if snackArray.count == 1 || snackArray.count == 0 {
                snackArray.removeAll()
                
                
                tableView.reloadData()
            }
            else {
                snackArray.remove(at: indexPath.row)
                
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    func loadFirebaseData() { //reading all saved food items from firebase realtime database, saving them to breakfastArray,lunchArray,dinnerArray,andSnackArray. Then reloading the table to display data.
        
        ref = Database.database().reference() //connecting to database
        
        
        //clearing all array for fresh reload whenever view controller is called.
        breakfastArray.removeAll()
        lunchArray.removeAll()
        dinnerArray.removeAll()
        snackArray.removeAll()
        
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
        
        ref.child(fireBaseCard).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let value = snapshot.value as? NSDictionary else { //if there are no saved records return
                print("There are no saved records")
                return
            }
            
            //MARK: O(n^2) algorithm
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
                }
            }
        })
    }
}





