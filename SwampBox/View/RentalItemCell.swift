//
//  RentalItemCell.swift
//  SwampBox
//
//  Created by Brett Wright on 1/20/18.
//  Copyright © 2018 brett wright. All rights reserved.
//

import UIKit

class RentalItemCell: UICollectionViewCell {
    
    let imageView: CircleImageView = {
        let imageView = CircleImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let itemNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = label.font.withSize(21)
        return label
    }()
    
    let itemDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = label.font.withSize(14)
        return label
    }()
    
    let nameAndDescriptContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    let arrowImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "right-arrow")
        return imageView
    }()
    
    let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    let mainContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private func addSubviews() {
        addSubview(dividerView)
        addSubview(imageView)
        addSubview(nameAndDescriptContainer)
        addSubview(arrowImage)
        nameAndDescriptContainer.addSubview(itemNameLabel)
    }
    
    private func addConstraints() {
        nameAndDescriptContainer.addConstraintsWithFormat(format: "H:|[v0]|", views: itemNameLabel)
        nameAndDescriptContainer.addConstraintsWithFormat(format: "V:|[v0]|", views: itemNameLabel)
        
        
        addConstraintsWithFormat(format: "H:|-20-[v0(80)]-10-[v1]-10-[v2(30)]-20-|", views: imageView, nameAndDescriptContainer, arrowImage)
        addConstraintsWithFormat(format: "H:|[v0]|", views: dividerView)
        
        
        addConstraintsWithFormat(format: "V:|-10-[v0(80)]-10-|", views: imageView)
        addConstraintsWithFormat(format: "V:|[v0][v1(1)]|", views: nameAndDescriptContainer, dividerView)
        addConstraintsWithFormat(format: "V:|-35-[v0(30)]-35-|", views: arrowImage)
    }
    
    func setupViews() {
        addSubviews()
        addConstraints()
    }
    
    func configureCell(withBox box: RentalBox) {
        setupViews()
        if let imageUrlString = box.image, let url = URL(string: imageUrlString) {
            SwampBoxUtils.shared.set(imageView: self.imageView, withImageAtUrl: url)
        }
        DispatchQueue.main.async {
            self.itemNameLabel.text = box.name ?? ""
            self.itemDescriptionLabel.text = box.description ?? ""
        }
    }
    
}
