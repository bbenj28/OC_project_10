//
//  ResultTableViewCell.swift
//  Reciplease
//
//  Created by Benjamin Breton on 20/01/2021.
//

import UIKit

class ResultTableViewCell: UITableViewCell {

    @IBOutlet weak var timeStack: UIStackView!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var resultTitleLabel: UILabel!
    @IBOutlet weak var resultPictureView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var personsLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        resultView.layer.cornerRadius = 20
        //resultView.layer.shadowRadius = 10
        //resultView.layer.shadowColor = #colorLiteral(red: 0.6704671637, green: 0.6704671637, blue: 0.6704671637, alpha: 1)
        //resultView.layer.shadowOpacity = 0.5
        resultPictureView.layer.cornerRadius = resultView.layer.cornerRadius
        resultPictureView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner]
    }
    var recipe: Recipe? {
        didSet {
            guard let recipe = recipe else { return }
            resultTitleLabel.text = recipe.title
            personsLabel.text = "\(recipe.yield)"
            timeLabel.text = "\(Int(recipe.totalTime)) min."
            timeStack.isHidden = recipe.totalTime == 0
            ingredientsLabel.text = recipe.ingredientsOnALine
            guard let data = recipe.pictureData, let image = UIImage(data: data) else {
                resultPictureView.image = UIImage(named: "default1")
                return
            }
            resultPictureView.image = image
        }
    }
}
