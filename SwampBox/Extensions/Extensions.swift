//
//  Extensions.swift
//  SwampBox
//
//  Created by Brett Wright on 1/20/18.
//  Copyright © 2018 brett wright. All rights reserved.
//

import UIKit
import FirebaseAuthUI

extension UIView {
    func addConstraintsWithFormat(format:String, views: UIView...){
        var viewsDictionary = [String:UIView]()
        for (index, view) in views.enumerated(){
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
            
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}

extension FUIAuthBaseViewController {
    open override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.leftBarButtonItem = nil
    }
}

