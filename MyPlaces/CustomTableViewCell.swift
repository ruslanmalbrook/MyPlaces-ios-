//
//  CustomTableViewCell.swift
//  MyPlaces
//
//  Created by Ruslan Malbrook on 11.06.2021.
//

import UIKit
import Cosmos

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageOfCell: UIImageView! {
        didSet {
            imageOfCell.layer.cornerRadius = imageOfCell.frame.size.height / 2
            imageOfCell.clipsToBounds = true
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var ratingCosmosView: CosmosView! {
        didSet {
            ratingCosmosView.settings.updateOnTouch = false
        }
    }
    
}
