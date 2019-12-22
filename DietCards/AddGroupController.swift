//
//  AddGroupController.swift
//  DietCards
//
//  Created by Elias Hall on 12/21/19.
//  Copyright © 2019 Elias Hall. All rights reserved.
//

import Foundation
import UIKit

protocol TypeOfUserDelegate {
    
    func didSelectUser(type: String)
    
}

class AddGroupController: UIViewController {
    
    @IBOutlet weak var createGroupButton: UIButton!
    @IBOutlet weak var joinGroupButton: UIButton!
    
    var chosenUser: TypeOfUserDelegate!
    var getEmailInput: String = ""
    
    override func viewDidLoad() {
        notify()
        super.viewDidLoad()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    
    @IBAction func createGroupTapped(_ sender: Any) {
      //  NotificationCenter.default.removeObserver("ViewDidAppear")
        chosenUser.didSelectUser(type: "leader")
        notify()
        dismiss(animated: true)
        
        
    }
    
    
    @IBAction func joinGroupTapped(_ sender: Any) {
      //  NotificationCenter.default.removeObserver("ViewDidAppear")
        promptForAnswer()
        chosenUser.didSelectUser(type: "follower")
        notify()
       // dismiss(animated: true)
    }
    
    func notify() {
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name("ViewDidAppear"), object: nil)
    }
    
    
    func promptForAnswer() {
        
       // self.amILeader = false
        let ac = UIAlertController(title: "Enter Group Leader's email", message: nil, preferredStyle: .alert)
        ac.addTextField()

        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned ac] _ in
            let answer = ac.textFields![0]
            
            self.getEmailInput = answer.text ?? ""
            
            self.dismiss(animated: true)
        }

        ac.addAction(submitAction)

        present(ac, animated: true)
    }
    
    
    
    
    
    
}



