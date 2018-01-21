//
//  CustomHeaderView.swift
//  SwampBox
//
//  Created by Brett Wright on 1/20/18.
//  Copyright © 2018 brett wright. All rights reserved.
//

import Foundation
import UIKit

class CustomHeaderView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.backgroundColor = GATOR_ORANGE.cgColor
        layer.shadowColor = SHADOW_GRAY.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 2.0
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        layer.masksToBounds = false
    }
}
