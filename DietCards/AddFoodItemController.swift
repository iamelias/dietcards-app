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

class AddFoodItemController: UIViewController {
    //@IBOutlet weak var label: UILabel!
    @IBOutlet weak var foodText: UITextField! //food entered
    @IBOutlet weak var mealText: UITextField! //breakfast, lunch, dinner, snacks selected
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let pickerMeals: [String] = ["Breakfast", "Lunch", "Dinner", "Snack"] //value used for mealText assignment
    var selectedMeal: String?
    var passedInDay: Int = 0 // Day of the Week passed in as Int
    var passedInGroupName: String = ""
    var ref: DatabaseReference! // reference to Firebase database
    
    // giving passedInDay a string value using daysDict
    var daysDict:[Int:String] = [0: "Monday", 1: "Tuesday", 2: "Wednesday", 3: "Thursday", 4: "Friday", 5: "Saturday", 6: "Sunday"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        foodText.delegate = self
        activityIndicator.isHidden = true
       
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddFoodItemController.action)) //when view is tapped picker/keyboard is dismissed
        
        view.addGestureRecognizer(tapGesture)
        
        setUpPickerView()
        makePickerToolbar()
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        action() //dismisses keyboard/picker before returning to previous controller.
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findFoodTapped(_ sender: Any) { //when find food is tapped
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        FoodClient.getFood(foodID: self.foodText.text ?? "", completion: self.getFoodResponse(success: foodID: error:)) //calling nutrionix api
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func getFoodResponse(success: Bool, foodID: NutritionData, error: Error?) { //Network response
        
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        if success { //if response is sucessful

            ref = Database.database().reference() //connecting to firebase database
            let key = ref.child("\(passedInGroupName)/\(daysDict[passedInDay]!)/\(mealText.text!)").childByAutoId().key

//            let key = ref.child("\(daysDict[passedInDay]!)/\(mealText.text!)").childByAutoId().key

            let data = [ //data to be added to database
                "foodid": key!, //unique key
                "foodName": foodID.foodName, //from Network response
                "nutrition": foodID.nutrition, //from Network response
                "dayCard": passedInDay, //from HomeViewController
                "mealTime": mealText.text! //selected in pickerView
                ] as [String : Any]
            
           
//            ref.child("\(daysDict[passedInDay]!)/\(mealText.text!)/\(key!)").setValue(data)
            ref.child("\(passedInGroupName)/\(daysDict[passedInDay]!)/\(mealText.text!)/\(key!)").setValue(data)
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { //dismissing keyboard
    
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
        mealText.text = selectedMeal //updating mealText textfield with selectedMeal from pickerView
    }
    
}
