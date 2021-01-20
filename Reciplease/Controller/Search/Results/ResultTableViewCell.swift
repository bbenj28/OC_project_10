//
//  ResultTableViewCell.swift
//  Reciplease
//
//  Created by Benjamin Breton on 20/01/2021.
//

import UIKit

class ResultTableViewCell: UITableViewCell {

    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var resultTitleLabel: UILabel!
    @IBOutlet weak var resultPictureView: UIImageView!
    @IBOutlet weak var resultIngredientsLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        resultView.layer.cornerRadius = 10
    }

    func setCell(title: String, image: UIImage?, ingredients: String) {
        resultTitleLabel.text = title
        resultPictureView.isHidden = image == nil
        if let image = image {
            resultPictureView.image = image
        }
        resultIngredientsLabel.text = ingredients
    }

}
