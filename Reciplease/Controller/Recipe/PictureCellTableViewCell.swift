//
//  PictureCellTableViewCell.swift
//  Reciplease
//
//  Created by Benjamin Breton on 21/01/2021.
//

import UIKit

class PictureCellTableViewCell: UITableViewCell {

    @IBOutlet weak var timeStack: UIStackView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var personsLabel: UILabel!
    @IBOutlet weak var pictureView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        pictureView.layer.cornerRadius = 20
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(recipe: Recipe) {
        personsLabel.text = "\(recipe.yield)"
        timeStack.isHidden = recipe.totalTime == 0
        timeLabel.text = "\(Int(recipe.totalTime)) min."
        guard let data = recipe.pictureData, let image = UIImage(data: data) else {
            pictureView.image = UIImage(named: "default2")
            return
        }
        pictureView.image = image
    }

}
