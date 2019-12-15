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

class LoginViewController: UIViewController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        
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
    
}

extension LoginViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        guard error == nil else { // error == nil means there is no error, therefore can continue
            return
        }

       // authDataResult?.user.uid

        performSegue(withIdentifier: "toHomeSegue", sender: self)

    }
}
