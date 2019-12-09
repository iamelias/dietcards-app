//
//  CardDetailViewController.swift
//  DietCards
//
//  Created by Elias Hall on 11/16/19.
//  Copyright © 2019 Elias Hall. All rights reserved.
//

// Stack: HomeViewController -> CardDetailController -> AddFoodController

/*
 selectedCard corresponding ints:  Monday: 0, Tuesday: 1, Wednesday: 2, Thursday: 3, Friday: 4, Saturday: 5, Sunday: 6
 */

import Foundation
import UIKit
import FirebaseDatabase

class CardTableViewController: UIViewController {
    
    var retrievedFood: NutritionData?
    var foodsArray: [NutritionData] = [] //Stores food items
    var selectedCard: Int = 0 //retrieving selected card number from previous controller
    var ref: DatabaseReference! // reference to Firebase database

    
    //All arrays below will need to recieve persisted data
    var breakfastArray: [NutritionData] = []
    var lunchArray: [NutritionData] = []
    var dinnerArray: [NutritionData] = []
    var snackArray: [NutritionData] = []
    var calSum: Double = 0
    static var calorieSum: Double = 0
    
    enum MT: String { //Meal Types
        case Breakfast
        case Lunch
        case Dinner
        case Snack
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isHidden = true
        
        print("Selected Card: \(selectedCard)") //from HomeViewController
        tableView.separatorColor = .black
        tableView.separatorStyle = .singleLine
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none //removes lines in between cells
        tableView.allowsSelection = false
        
//        ref = Database.database().reference()

        // ref.child("Monday/Breakfast/foodName").setValue("kiwi") // changing value in database
        

//        ref.child("Monday/Breakfast/foodName").observeSingleEvent(of: .value){ (snapshot) in
//            let name = snapshot.value as? String //retrieving from database
        
//        ref.child("Monday/Breakfast").observeSingleEvent(of: .value){ (snapshot) in
//            let name = snapshot.value as? [String: Any]  //retrieving from database
        
//        ref.child("Monday/Breakfast/foodName").observeSingleEvent(of: .value){ (snapshot) in
//            let name = snapshot.value as? String  //retrieving from database
            
//
//            print("*************************")
//            print(name!)
//            //print(name)
//            print("*************************")
//
//        }

    }

    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
        print("Food Name: \(retrievedFood?.foodName ?? "") ") //
        print("Calories: \(retrievedFood?.nutrition ?? 0.0)")
        print("Meal Time: \(retrievedFood?.mealTime ?? "")")
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func addFoodTapped(_ sender: Any) {
        
        let addFoodVC = storyboard?.instantiateViewController(withIdentifier: "AddFoodItemController") as! AddFoodItemController
        
        addFoodVC.getFoodDelegate = self
        
        addFoodVC.passedInDay = selectedCard
        addFoodVC.modalPresentationStyle = .fullScreen
        
        present(addFoodVC, animated: true, completion: nil )
        
    }
    
    func sumCalories(_ foodCal: Double) {
    
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
    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
    
     func tableView(_ tableView: UITableView, commit editingStyle:UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if breakfastArray.count == 1 || breakfastArray.count == 0 {
            breakfastArray.removeAll()
            

            tableView.reloadData()
        }
        else {
//            breakfastArray.remove(at: 0)
            breakfastArray.remove(at: indexPath.row)

            //tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
         //   tableView.endUpdates()

        }
    }
    
}
// MARK: - TableView Delegate and DataSource - END


//MARK: *GetFoodDelegate* BEGIN

extension CardTableViewController: GetFoodDelegate {
    func didGetFoodData(food: NutritionData) {
        self.retrievedFood = food
        self.foodsArray.append(retrievedFood!) //storing food item in array.
        
        retrievedFood?.dayCard = selectedCard //holding the associated card
        
        self.calSum += retrievedFood!.nutrition //calculating total calories for day
        CardTableViewController.calorieSum += retrievedFood!.nutrition //unecessary
        
        print(calSum)
        
        
        
        switch food.mealTime {
        case MT.Breakfast.rawValue: breakfastArray.append(food)
        case MT.Lunch.rawValue: lunchArray.append(food)
        case MT.Dinner.rawValue: dinnerArray.append(food)
        case MT.Snack.rawValue: snackArray.append(food)
        default:
            return
        }
        
        print(breakfastArray)
    }
//    func didGetFoodData(foodName: String, foodCalories: Double) {
//
//        self.newFoodName = foodName
//        self.newFoodCalories = foodCalories
//
//    }
}
//MARK: *GetFoodDelegate* END


//
//    var breakfast: [String] = ["Egg", "Sausage", "Hashbrowns", "Toast", "Orange Juice"]
//    var lunch: [String] = ["Hamburger", "Turkey Sandwich", "Orange Chicken", "Pad Thai"]
//    var dinner: [String] = ["Steak", "Roast Chicken", "Baked Potato", "Ceasar Salad"]
//    var snack: [String] = ["Cookie"]
