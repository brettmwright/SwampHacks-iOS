//
//  RentalBox.swift
//  SwampBox
//
//  Created by Brett Wright on 1/20/18.
//  Copyright © 2018 brett wright. All rights reserved.
//

import Foundation

class RentalBox: Decodable {
    
    
    var id: Int?
    var name: String?
    var image: String?
    var description: String?
    var price: String?
    var latitude: String?
    var longitude: String?
    var createdAt: String?
    var updatedAt: String?
    var available: Int?
    
    func getHourlyPrice() -> String {
        if let price = self.price {
            return "\(price)/HR"
        }
        return ""
    }
    
    func isAvailable() -> Bool {
        return available == 1 ? true : false
    }
}
