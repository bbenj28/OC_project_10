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
    func setCell(picto: UIImage?, text: String?) {
        guard let image = picto else { return }
        self.picto.image = image
        label.isHidden = text == nil
        label.text = text
    }
    
}
