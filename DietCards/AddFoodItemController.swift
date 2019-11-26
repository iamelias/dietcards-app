//
//  AddFoodItemController.swift
//  DietCards
//
//  Created by Elias Hall on 11/24/19.
//  Copyright © 2019 Elias Hall. All rights reserved.
//

import Foundation
import UIKit

class AddFoodItemController: UIViewController {
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {

        
    }
    
    func viewWillAppear() {
        
    }
    
    func viewDidAppear() {
        
    }
    
    @IBAction func findFoodTapped(_ sender: Any) { //when find food is tapped
        //Network call to retrieve Food name and coressponding nutrition
        //Add to persisted etc.
        //dismiss back to the tableView controller
        
        
//        FoodClient.getFood() //calling nutrionix api
        
        dismiss(animated: true)
    
    }
    
    
}
