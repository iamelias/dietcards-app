//
//  NutritionData.swift
//  DietCards
//
//  Created by Elias Hall on 11/25/19.
//  Copyright © 2019 Elias Hall. All rights reserved.
//

import Foundation

struct NutritionData {
    
    
    var foodName: String = "" //name
    var nutrition: Double = 0.0 //calorie count
    var mealTime: String = "" //breakfast/lunch...
    var foodData: [Any] = [] //used in client
    var dayCard: Int = 0 //day represent as int
    var id: String = ""
    
    
}

