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
    
    func didSelectUser(type: String, email: String)
    
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
        chosenUser.didSelectUser(type: "leader", email: "")
        notify()
        dismiss(animated: true)
    }
    
    
    @IBAction func joinGroupTapped(_ sender: Any) {
      //  NotificationCenter.default.removeObserver("ViewDidAppear")
        promptForAnswer()
       // dismiss(animated: true)
    }
    
    func notify() {
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name("ViewDidAppear"), object: nil)
    }
    
    
    func promptForAnswer() {
       // self.amILeader = false
        let ac = UIAlertController(title: "Join Group", message: "Enter group leader's email address", preferredStyle: .alert)
        ac.addTextField()

        let submitAction = UIAlertAction(title: "Join", style: .default) { [unowned ac] _ in
            let answer = ac.textFields![0]
            
            self.getEmailInput = answer.text ?? ""
           // print(self.getEmailInput)
            
            self.chosenUser.didSelectUser(type: "follower", email: self.getEmailInput)
            self.notify()
            
            self.dismiss(animated: true)
        }

        ac.addAction(submitAction)

        present(ac, animated: true)
    }
    
    
    
    
    
    
}



