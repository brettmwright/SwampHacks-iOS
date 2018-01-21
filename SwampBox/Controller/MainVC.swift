//
//  MainVC.swift
//  SwampBox
//
//  Created by Brett Wright on 1/20/18.
//  Copyright © 2018 brett wright. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI
import FirebaseGoogleAuthUI
import FirebaseFacebookAuthUI
import FirebasePhoneAuthUI
import Alamofire

class MainVC: UIViewController {

    var authUI: FUIAuth?
    var boxArray: [RentalBox]?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        configureAuth()
        getBoxes()
        checkForAuthSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        boxArray = []
        DispatchQueue.main.async {
            self.getBoxes()
        }
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
    
    func getBoxes() {
        Alamofire.request("http://54.89.180.9:8080/getBoxes").responseJSON { (response) in
            if response.error != nil {
                print(response.error.debugDescription)
            }
            guard let json = response.result.value else { return }
            print("JSON: ", json)
            guard let data = response.data else { return }
            do {
                let boxesResult = try JSONDecoder().decode(GetBoxesResult.self, from: data)
                self.boxArray = boxesResult.message
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                self.collectionView.reloadData()
            } catch let err {
                print("ERROR Alamo:", err.localizedDescription)
            }
        }
    }
    
    func checkForAuthSetup() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let dbRef = Database.database().reference()
        dbRef.child("users/\(uid)/authSet").observeSingleEvent(of: .value) { (snapshot) in
            print(snapshot.value)
            if snapshot.value == nil || snapshot.value is NSNull {
                guard let boxAuthSetupVC = self.storyboard?.instantiateViewController(withIdentifier: "BoxAuthSetupVC") else { return }
                self.present(boxAuthSetupVC, animated: true, completion: nil)
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
    
    @IBAction func refreshBtnPressed(_ sender: Any) {
        boxArray = []
        getBoxes()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let boxVC = segue.destination as? BoxVC {
            if let box = sender as? RentalBox {
                boxVC.box = box
            }
        }
    }
}

extension MainVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = boxArray?.count {
            return count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RentalItemCell", for: indexPath) as? RentalItemCell {
            guard let boxArray = self.boxArray else { return cell }
            let box = boxArray[indexPath.row]
            cell.configureCell(withBox: box)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let boxArray = self.boxArray else { return }
        let box = boxArray[indexPath.row]
        performSegue(withIdentifier: "MainToBox", sender: box)
    }
}

