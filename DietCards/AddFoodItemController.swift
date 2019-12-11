//
//  AddFoodItemController.swift
//  DietCards
//
//  Created by Elias Hall on 11/24/19.
//  Copyright © 2019 Elias Hall. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

protocol GetFoodDelegate {
   // func didGetFood(foodName: String, foodCalories: Double)
    func didGetFoodData(food: NutritionData)
    
}

class AddFoodItemController: UIViewController {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var foodText: UITextField!
    @IBOutlet weak var mealText: UITextField! //either breakfast, lunch, dinner snacks
    
    var getFoodDelegate: GetFoodDelegate!
    let pickerMeals: [String] = ["Breakfast", "Lunch", "Dinner", "Snack"]
    var selectedMeal: String?
    var passedInDay: Int = 0 // the card's week day
    var ref: DatabaseReference! // reference to Firebase database
    
    var daysDict:[Int:String] = [0: "Monday", 1: "Tuesday", 2: "Wednesday", 3: "Thursday", 4: "Friday", 5: "Saturday", 6: "Sunday"]

    override func viewDidLoad() {
        super.viewDidLoad()
        foodText.delegate = self
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddFoodItemController.action)) //when view is tapped picker/keyboard is dismissed
        
        view.addGestureRecognizer(tapGesture)
        
        setUpPickerView()
        makePickerToolbar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        print("AddFood view will appear called")
        
    }
    
    func viewDidAppear() {

    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        action() //dismisses keyboard/picker before returning to previous controller.
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func findFoodTapped(_ sender: Any) { //when find food is tapped
        //Network call to retrieve Food name and coressponding nutrition
        //Add to persisted etc.
        //dismiss back to the tableView controller
    
        FoodClient.getFood(foodID: self.foodText.text ?? "", completion: self.getFoodResponse(success: foodID: error:)) //calling nutrionix api
        
        
        dismiss(animated: true, completion: nil)
    
    }
    
    func getFoodResponse(success: Bool, foodID: NutritionData, error: Error?) {
        
        if success {
            
            print("&&&&&&&&&&&&&&&&&&&&")
            print("FoodName: \(foodID.foodName)")
            print("Nutrition: \(foodID.nutrition)")
            print("&&&&&&&&&&&&&&&&&&&&")
            
            var passFoodID = NutritionData()
            passFoodID.foodName = foodID.foodName
            passFoodID.nutrition = foodID.nutrition
            passFoodID.mealTime = mealText.text! //mealText will always have value
            
           // getFoodDelegate.didGetFood(foodName: foodID.foodName, foodCalories: foodID.nutrition)
            getFoodDelegate.didGetFoodData(food: passFoodID)

            //**************************** FireBase start ********************************
            
            ref = Database.database().reference()

            //updating database with entry data
            //updating all at once
            
             let key = ref.child("\(daysDict[passedInDay]!)/\(mealText.text!)").childByAutoId().key
            
            let data = [
                "foodid": key!,
                "foodName": foodID.foodName,
                "nutrition": foodID.nutrition,
                "dayCard": passedInDay,
                "mealTime": mealText.text!
                ] as [String : Any]
            
           ref.child("\(daysDict[passedInDay]!)/\(mealText.text!)/\(key!)").setValue(data)
           // ref.child("\(daysDict[passedInDay]!)/\(mealText.text!)").childByAutoId().setValue(data)
            
            
//    ref.child("\(daysDict[passedInDay]!)/\(mealText.text!)/\(foodObject)").setValue(["foodName":"\(foodID.foodName)", "nutrition":"\(foodID.nutrition)", "dayCard":"\(passedInDay)", "mealTime":"\(mealText.text!)"])
           
            
            //option to update individual values
            // ref.child("\(daysDict[passedInDay])/\(mealText.text!)/foodName").setValue("\(foodID.foodName)")
            // ref.child("\(daysDict[passedInDay])/\(mealText.text!)/nutrition").setValue("\(foodID.nutrition)")
            // ref.child("\(daysDict[passedInDay])/\(mealText.text!)/dayCard").setValue("\(passedInDay)")
            // ref.child("\(daysDict[passedInDay])/\(mealText.text!)/mealTime").setValue("\(foodID.mealText)")


            
            
            
            //        ref.child("Monday/Breakfast/foodName").observeSingleEvent(of: .value){ (snapshot) in
            //            let name = snapshot.value as? String //retrieving from database
            
            
            //**************************** FireBase finish ********************************
        }
        else {
            
        }
        
        return
    }
    
    func setUpPickerView() {
        let myPicker = UIPickerView() //creating UIPicker
        myPicker.delegate = self
        mealText.inputView = myPicker //showing UIPicker
    }
    
    func makePickerToolbar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.action))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        mealText.inputAccessoryView = toolBar
    }
    @objc func action() {
        view.endEditing(true)
    }
}

//MARK: *UITextField*

extension AddFoodItemController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        foodText.resignFirstResponder()
        mealText.resignFirstResponder()
        return true
    }
}

//MARK: *UIPickerView*

extension AddFoodItemController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    
        return pickerMeals.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if mealText.text == "" {
        mealText.text = pickerMeals[0]
        }
        return pickerMeals[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedMeal = pickerMeals[row] //selecting either breakfast, lunch, dinner, snacks
        mealText.text = selectedMeal
    }
    
    //Project Tap Gesture Recognizer, and PickerView,
}
