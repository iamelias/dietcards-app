//
//  CardDetailViewController.swift
//  DietCards
//
//  Created by Elias Hall on 11/16/19.
//  Copyright © 2019 Elias Hall. All rights reserved.
//

// Stack: HomeViewController -> CardDetailController -> AddFoodController

import Foundation
import UIKit


class CardTableViewController: UIViewController {

    var retrievedFood: NutritionData?
    var foodsArray: [NutritionData] = [] //Stores food items
    var selectedCard: Int = 0 //retrieving selected card number from previous controller
    
//used for table population. Arrays hold full food Data.
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
//        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: UIApplication.shared.keyWindow!.safeAreaInsets.bottom, right: 0.0);
       // view.backgroundColor = .red

        
        print("&&&Selected Card: \(selectedCard)")
        tableView.separatorColor = .black
        //tableView.backgroundColor = .red
        tableView.separatorStyle = .singleLine
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none //removes lines in between cells
        tableView.allowsSelection = false

    }

    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
        print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^")
//        print("Food Name: \(newFoodName)")
//        print("Food Calories: \(newFoodCalories)")
        
        print("Food Name: \(retrievedFood?.foodName ?? "") ") //
        print("Calories: \(retrievedFood?.nutrition ?? 0.0)")
        print("Meal Time: \(retrievedFood?.mealTime ?? "")")
        print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^")

    }
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func addFoodTapped(_ sender: Any) {
        
        let addFoodVC = storyboard?.instantiateViewController(withIdentifier: "AddFoodItemController") as! AddFoodItemController
        
        addFoodVC.getFoodDelegate = self
        
      //  addFoodVC.modalPresentationStyle = .fullScreen
        
        present(addFoodVC, animated: true, completion: nil )
        
    }
    
    func sumCalories(_ foodCal: Double) {
    
        self.calSum += foodCal
        
    }
    
}

// Mark: - TableView Delegate and DataSource

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
            cell.detailTextLabel!.text = "\(breakfastArray[indexPath.row].nutrition) kcal"

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
    
}

//MARK: *GetFoodDelegate*

extension CardTableViewController: GetFoodDelegate {
    func didGetFoodData(food: NutritionData) {
        self.retrievedFood = food
        self.foodsArray.append(retrievedFood!) //storing food item in array.
        
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




//
//
//    var breakfast: [String] = ["Egg", "Sausage", "Hashbrowns", "Toast", "Orange Juice"]
//    var lunch: [String] = ["Hamburger", "Turkey Sandwich", "Orange Chicken", "Pad Thai"]
//    var dinner: [String] = ["Steak", "Roast Chicken", "Baked Potato", "Ceasar Salad"]
//    var snack: [String] = ["Cookie"]
