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
    
    class func getFood() {
        
        //Instant Search API url
        //        let urlString: String = "https://trackapi.nutritionix.com/v2/search/instant?query=apple"
        
        //Nutrition API url
        let urlString: String = "https://trackapi.nutritionix.com/v2/natural/nutrients"
        
        
        let url = URL(string: urlString)
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            "x-app-id": "257ebe77",
            "x-app-key": "bcce7c3f3c60be3c944af99a977197de",
            "x-remote-user-id": "0"
        ]
        
        let parameters = ["query": "orange"]
        
        
        
        //Nutrition API Config
        AF.request(url!, method: .post, parameters: parameters, encoder: URLEncodedFormParameterEncoder(destination: .httpBody), headers: headers).validate().responseJSON { (response) in
         //   debugPrint(response) printing full json response
            
            var data = NutritionData()

            switch response.result {
            case let .success(value):
                
                if let foods = value as? [String: Any] {

                    data.foodData = foods["foods"] as! Array //value of food key
                    let newfoodData = data.foodData.first as! [String: Any] //accessing value array
                    data.foodName = newfoodData["food_name"] as! String //calling food name key
                    data.nutrition = newfoodData["nf_calories"] as! Double //calling calorie key
                    
                    print("*****************")
                    print("FoodName: \(data.foodName)")
                    print("Nutrition: \(data.nutrition)")
                    print("*****************")
                }

            case .failure(_):
                print("Error")
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
