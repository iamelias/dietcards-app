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

class CardDetailViewController: UIViewController {

    var retrievedFood: NutritionData?
    var foodsArray: [NutritionData] = [] //Stores food items
    
   // let animalsArray: [String] = ["Cat", "Dog", "Giraffe", "Camel", "Turtle", "Elephant", "Rhino", "Lion"]
    
    enum MealTypes: String {
        case breakfast
        case lunch
        case dinner
        case snack
    }
  
    var breakfast: [String] = ["Egg", "Sausage", "Hashbrowns", "Toast", "Orange Juice"]
    var lunch: [String] = ["Hamburger", "Turkey Sandwich", "Orange Chicken", "Pad Thai"]
    var dinner: [String] = ["Steak", "Roast Chicken", "Baked Potato", "Ceasar Salad"]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isHidden = true
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none //removes lines in between cells
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^")
//        print("Food Name: \(newFoodName)")
//        print("Food Calories: \(newFoodCalories)")
        
        print("Food Name: \(retrievedFood?.foodName ?? "") ") //
        print("Calories: \(retrievedFood?.nutrition ?? 0.0)")
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
    
}

// Mark: - TableView Delegate and DataSource

extension CardDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return animalsArray.count
       return breakfast.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.backgroundColor = .lightGray
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
        
        
        return label
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell")!
        cell.textLabel!.text = breakfast[indexPath.row]
        return cell
    }
}

extension CardDetailViewController: GetFoodDelegate {
    func didGetFoodData(food: NutritionData) {
        self.retrievedFood = food
        self.foodsArray.append(retrievedFood!) //storing food item in array.
    }
    
//    func didGetFoodData(foodName: String, foodCalories: Double) {
//
//        self.newFoodName = foodName
//        self.newFoodCalories = foodCalories
//
//    }
}




