//
//  PictureCellTableViewCell.swift
//  Reciplease
//
//  Created by Benjamin Breton on 21/01/2021.
//

import UIKit

class PictureCellTableViewCell: UITableViewCell {
    
    var recipe: Recipe? {
        didSet {
            guard let recipe = recipe, let data = recipe.pictureData, let image = UIImage(data: data) else {
                pictureView.image = UIImage(named: "default2")
                return
            }
            pictureView.image = image
        }
    }
    @IBOutlet weak var pictureView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        pictureView.layer.cornerRadius = 20
        // Initialization code
    }
}
