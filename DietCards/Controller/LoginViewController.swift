//
//  LoginViewController.swift
//  DietCards
//
//  Created by Elias Hall on 12/14/19.
//  Copyright © 2019 Elias Hall. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseUI
import CoreData

class LoginViewController: UIViewController {
    
    var dataController: DataController?
    var coreGroupName: [SavedGroup] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveCoreData() //fetching persisted data
        //deleteCoreGroup() //If I want to delete persisted data for testing purposes
        
    }
    
    @IBAction func loginTapped(_ sender: Any) { //FirebaseUI Default Authentication using email
        
        let authUI = FUIAuth.defaultAuthUI() //using Firebase default authorization
        
        guard authUI != nil else { //if authUI is nil return
            return
        }
        
        authUI?.delegate = self
        
        let providers: [FUIAuthProvider] = [
            FUIEmailAuth() //email way of signing in
        ]
        
        authUI?.providers = providers
        
        let authVC = authUI!.authViewController() //using Firebase default Login View Controller
        
        present(authVC, animated: true, completion: nil) //presenting firebase View Controller
    }
    
    func deleteCoreGroup() { //deletes the saved groupName from core data- for testing purposes
        for i in 0..<coreGroupName.count {
            dataController!.viewContext.delete(coreGroupName[i])
            try? dataController!.viewContext.save()
        }
        coreGroupName.removeAll()
    }
    
    func retrieveCoreData() { //getting saved groupName from core Data - To pass to HomeVC
        let fetchRequest: NSFetchRequest<SavedGroup> = SavedGroup.fetchRequest()
        
        if let result = try? dataController?.viewContext.fetch(fetchRequest) { //fetching persisted pins
            coreGroupName = result //storing in pins array for use in class
            
            return
        }
        else {
            debugPrint("unable to fetch")
            return
        }
        
    }
}

extension LoginViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        guard error == nil else { // error == nil means there is no error, therefore can continue
            return
        }
        
        performSegue(withIdentifier: "toHomeSegue", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { //gets called if segue is used. After firebaseUI default auth auto segues to HomeViewController
        if segue.identifier == "toHomeSegue" { //segue used pushes to collectionView
            let key = segue.destination as! HomeViewController //data to be sent to PhotoAlbum Controller
            
            key.coreGroupName = coreGroupName //data to pass to next vc
            key.dataController = dataController
        }
    }
    
}

