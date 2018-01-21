//
//  SwampBoxUtils.swift
//  SwampBox
//
//  Created by Brett Wright on 1/20/18.
//  Copyright © 2018 brett wright. All rights reserved.
//

import Foundation
import UIKit
import MapKit


class SwampBoxUtils {
    
    static let shared = SwampBoxUtils()
    
    /// Sets an image view to an image stored at the provided url
    func set(imageView: UIImageView, withImageAtUrl url: URL) {
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if error != nil {
                print(error.debugDescription)
            } else if let data = data {
                DispatchQueue.main.async {
                    imageView.image = UIImage(data: data)
                }
            }
        }).resume()
    }
    
    /// Centers a map view on a location
    func center(mapView: MKMapView, onLocation location: CLLocation, withRadius radius: Double) {
        let coordinateSpan = MKCoordinateRegionMakeWithDistance(location.coordinate, radius, radius)
        mapView.setRegion(coordinateSpan, animated: true)
    }
    
    /// Creates sha256 hash
    func ccSha256(data: Data) -> Data {
        var digest = Data(count: Int(CC_SHA256_DIGEST_LENGTH))
        
        _ = digest.withUnsafeMutableBytes { (digestBytes) in
            data.withUnsafeBytes { (stringBytes) in
                CC_SHA256(stringBytes, CC_LONG(data.count), digestBytes)
            }
        }
        return digest
    }
    
}
