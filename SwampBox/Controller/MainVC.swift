//
//  MainVC.swift
//  SwampBox
//
//  Created by Brett Wright on 1/20/18.
//  Copyright © 2018 brett wright. All rights reserved.
//

import UIKit
import FirebaseAuthUI
import FirebaseGoogleAuthUI
import FirebaseFacebookAuthUI
import FirebasePhoneAuthUI


class MainVC: UIViewController {

    var authUI: FUIAuth?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAuth()
    }
    
    func configureAuth() {
        self.authUI = FUIAuth.defaultAuthUI()
        guard let _authUI = authUI else { return }
        // You need to adopt a FUIAuthDelegate protocol to receive callback
        _authUI.delegate = self as? FUIAuthDelegate
        
        let providers: [FUIAuthProvider] = [
            FUIGoogleAuth(),
            FUIFacebookAuth(),
            FUIPhoneAuth(authUI: _authUI),
            ]
        _authUI.providers = providers
        
        _ = Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                print("Logged in")
            } else {
                print("Not logged in")
                let authViewController = _authUI.authViewController()
                self.present(authViewController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func signOutBtnPressed(_ sender: Any) {
        guard let _authUI = authUI else { return }
        do {
         try _authUI.signOut()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}

