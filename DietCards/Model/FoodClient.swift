//
//  FoodClient.swift
//  DietCards
//
//  Created by Elias Hall on 11/21/19.
//  Copyright © 2019 Elias Hall. All rights reserved.
//

import Foundation
import Alamofire

class FoodClient {
    
    class func getFood(foodID: String, completion: @escaping (Bool, NutritionData, Error?) -> Void) { //add completion handler to return error
        
        //Nutrition API url
        let urlString: String = "https://trackapi.nutritionix.com/v2/natural/nutrients"
        
        
        let url = URL(string: urlString)
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            "x-app-id": "257ebe77",
            "x-app-key": "GET_API_KEY_FROM_NUTRITIONIX",
            "x-remote-user-id": "0"
        ]
        
        let parameters = ["query": foodID] //foodID is user inputted food item

        //Nutrition API Config
        AF.request(url!, method: .post, parameters: parameters, encoder: URLEncodedFormParameterEncoder(destination: .httpBody), headers: headers).validate().responseJSON { (response) in
            
            var data = NutritionData()

            switch response.result {
            case let .success(value):
                
                if let foods = value as? [String: Any] { //format of foods

                    data.foodData = foods["foods"] as! Array // assigning value of food key to foodData
                    let newfoodData = data.foodData.first as! [String: Any] //accessing value array
                    data.foodName = newfoodData["food_name"] as! String //calling food name key
                    data.nutrition = newfoodData["nf_calories"] as! Double //calling calorie key

                    DispatchQueue.main.async {
                    completion(true, data, nil) //returnining foodName and nutrition to calling controller
                    //return data completion handler
                    }
                }

            case .failure(_):
                print("Error")
                DispatchQueue.main.async {
                    completion(false, data, nil)
                }
            }
        }
    }
}


// *Notes*
//.validate() validates that status code is between 200..<300 range. Can be done manually

//                AF.request(url!, method: .get, headers: headers).responseJSON { response in
//                    debugPrint(response)
//
//    }


// Instant Search API Endpoint Config
//        AF.request(url!, method: .get, headers: headers).responseJSON { response in
//            debugPrint(response)
//        }
