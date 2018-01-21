//
//  BoxAuthSetupVC.swift
//  SwampBox
//
//  Created by Brett Wright on 1/20/18.
//  Copyright © 2018 brett wright. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase
import Alamofire

class BoxAuthSetupVC: UIViewController {

    @IBOutlet weak var avatarImage: CircleImageView!
    @IBOutlet weak var pinTextField: UITextField!
    @IBOutlet weak var continueBtn: CustomButton!
    
    var imagePicker: UIImagePickerController!
    var imageSelected = false
    var spinner: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImagePicker()
    }
    
    func setupImagePicker() {
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
    }
    
    func addSpinner() {
        spinner = UIActivityIndicatorView()
        guard let _spinner = spinner else { return }
        view.addSubview(_spinner)
        _spinner.center = CGPoint(x: (view.frame.width / 2) - (spinner?.frame.width)!, y: (view.frame.height / 2))
        _spinner.activityIndicatorViewStyle = .whiteLarge
        _spinner.color = .darkGray
        _spinner.startAnimating()
        _spinner.isHidden = false
        continueBtn.isEnabled = false
    }
    
    func removeSpinner() {
        spinner?.removeFromSuperview()
        spinner?.isHidden = true
        continueBtn.isEnabled = true
    }

    @IBAction func addNewImageTouched(_ sender: Any) {
        let alert = UIAlertController(title: "Change Profile Picture", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Choose From Photo Library", style: .default, handler: { (alertAction: UIAlertAction) in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { (alertAction: UIAlertAction) in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func failureAlert() {
        let alertController = UIAlertController(title: "Oh No!", message: "Something went wrong, please try again.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alert) in
            
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func continueBtnPressed(_ sender: Any) {
        addSpinner()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let image = avatarImage.image, let data = UIImageJPEGRepresentation(image, 0.0) else { return }
        
        guard let pinValue = pinTextField.text else {
            print("Pin Cannot be blank")
            return
        }
        
        guard let pinData = pinValue.data(using: .utf8) else { return }
        
        let strData = SwampBoxUtils.shared.ccSha256(data: pinData)
        let hashedPin = strData.map { String(format: "%02hhx", $0) }.joined()
        
        let storageRef = Storage.storage().reference()
        let userImagesRef = storageRef.child("images/\(uid).jpg")
        
        
        // Upload the file to the path "images/rivers.jpg"
        _ = userImagesRef.putData(data, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                print(error.debugDescription)
                return
            }
            // Metadata contains file metadata such as size, content-type, and download URL.
            guard let downloadURL = metadata.downloadURL()?.absoluteString else { return }
            
            let parameters: Parameters = [
                "userId": uid,
                "faceImage": downloadURL,
                "pin": hashedPin
            ]
            
            
            Alamofire.request("http://54.89.180.9:8080/createUser", method: .post, parameters: parameters).responseJSON { (response) in
                print(response)
                switch response.result {
                case .success:
                    self.removeSpinner()
                    print("success")
                    let dbRef = Database.database().reference()
                    dbRef.child("users/\(uid)/authSet").setValue("true")
                    self.dismiss(animated: true, completion: nil)
                case .failure:
                    print("failure")
                    self.removeSpinner()
                    self.failureAlert()
                }
                
            }
            
        }
        
    }
}

extension BoxAuthSetupVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            avatarImage.image = image
            avatarImage.contentMode = .scaleAspectFill
            avatarImage.alpha = 1
            imageSelected = true
        } else {
            print("Error: Image could not be picked")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
