//
//  NutritionData.swift
//  DietCards
//
//  Created by Elias Hall on 11/25/19.
//  Copyright © 2019 Elias Hall. All rights reserved.
//

import Foundation

struct NutritionData {
    
    
    var foodName: String = ""
    var nutrition: Double = 0.0
    var mealTime: String = ""
    var foodData: [Any] = [] //used in client
    var dayCard: Int = 0
    var id: String = ""
    
    
}

/*
 
 A food item will have:
 1. A name
 2. A calorie count
 3. A meal time (ex. breakfast/lunch/dinner/snack)
 4. A associated card chosen by user in HomeViewController
 
 
 */
