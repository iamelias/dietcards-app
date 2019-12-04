//
//  HomeCollectionViewCell.swift
//  DietCards
//
//  Created by Elias Hall on 11/15/19.
//  Copyright © 2019 Elias Hall. All rights reserved.
//

import Foundation
import UIKit

class HomeCollectionViewCell: UICollectionViewCell
{
    @IBOutlet weak var cardTitleLabel: UILabel!
    @IBOutlet weak var cardColorView: UIView!
    

    func configureCell(_ dayOfWeek: String) {
        
        backgroundColor = .clear
        cardColorView.layer.cornerRadius = 20.0
        cardColorView.layer.masksToBounds = true
        cardTitleLabel.text = dayOfWeek
        cardTitleLabel.textAlignment = .center
        cardTitleLabel.textColor = .black
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 3.0
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 5, height: 10)
                
        self.clipsToBounds = false
    }
}



