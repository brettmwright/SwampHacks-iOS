//
//  BoxVC.swift
//  SwampBox
//
//  Created by Brett Wright on 1/20/18.
//  Copyright © 2018 brett wright. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import FirebaseAuth

class BoxVC: UIViewController {

    var box: RentalBox?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var rentButton: CustomButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var availabiltyLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    

    func setupView() {
        guard let box = self.box else { return }
        if let imageUrlString = box.image, let url = URL(string: imageUrlString) {
            SwampBoxUtils.shared.set(imageView: self.imageView, withImageAtUrl: url)
        }
        DispatchQueue.main.async {
            self.priceLabel.text = box.getHourlyPrice()
            self.titleLabel.text = box.name ?? ""
            self.descriptionLabel.text = box.description ?? ""
            self.setAvailibiltyLabel()
            self.addBoxLocationToMap()
        }
    }
    
    func setAvailibiltyLabel() {
        if let box = self.box, box.isAvailable() {
            availabiltyLabel.text = "Available"
            availabiltyLabel.textColor = .green
            rentButton.isEnabled = true
            rentButton.backgroundColor = GATOR_ORANGE
        } else {
            availabiltyLabel.text = "Not Available"
            availabiltyLabel.textColor = .red
            rentButton.isEnabled = false
            rentButton.backgroundColor = .lightGray
        }
    }
    
    func addBoxLocationToMap() {
        guard let box = self.box, let latString = box.latitude, let longString = box.longitude else { return }
        guard let lat = Double(latString), let long = Double(longString) else { return }
        let location = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let annotation = MapPin(coordinate: location)
        mapView.addAnnotation(annotation)
        let clLocation = CLLocation(latitude: lat, longitude: long)
        SwampBoxUtils.shared.center(mapView: mapView, onLocation: clLocation, withRadius: 500)
    }
    
    func rentalAlert(withTitle title: String, andMessage message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alert) in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func rentBtnPressed(_ sender: Any) {
        guard let boxId = box?.id, let uid = Auth.auth().currentUser?.uid else { return }
        
        let parameters: Parameters = [
            "userId": uid,
            "boxId": boxId
        ]
        
        Alamofire.request("http://54.89.180.9:8080/createRental", method: .post, parameters: parameters).responseData { (response) in
            guard let box = self.box, let boxName = box.name else {
                self.navigationController?.popViewController(animated: true)
                return
            }
            
            
            var title: String?
            var message: String?
            
            switch response.result {
            case .success:
                print("success")
                title = "Congrats!"
                message = "You rented \(boxName), go to location to pick up it up!"
            case .failure:
                print("failure")
                title = "Oh No"
                message = "You attempted to rent \(boxName), unfortunately something went wrong. Please try again soon."
            }
            guard let _title = title, let _message = message else {
                self.navigationController?.popViewController(animated: true)
                return
            }
            self.rentalAlert(withTitle: _title, andMessage: _message)
        }
    }
    
}
