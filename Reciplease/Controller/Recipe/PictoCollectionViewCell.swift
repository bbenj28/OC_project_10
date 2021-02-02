//
//  PictoCollectionViewCell.swift
//  Reciplease
//
//  Created by Benjamin Breton on 26/01/2021.
//

import UIKit

class PictoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var picto: UIImageView!
    /// Informations to display.
    var informations: (UIImage?, String?) = (nil, nil) {
        didSet {
            guard let image = informations.0 else { return }
            picto.image = image
            label.text = informations.1
        }
    }
}
