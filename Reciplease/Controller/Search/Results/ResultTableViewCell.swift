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
        resultView.layer.shadowColor = #colorLiteral(red: 0.6704671637, green: 0.6704671637, blue: 0.6704671637, alpha: 1)
        resultView.layer.shadowOpacity = 0.5
        resultPictureView.layer.cornerRadius = resultView.layer.cornerRadius
        resultPictureView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner]
    }

    func setCell(recipe: RecipeDetailsJSONStructure, image: UIImage) {
        resultTitleLabel.text = recipe.title
        resultPictureView.image = image
        personsLabel.text = "\(recipe.yield)"
        timeLabel.text = "\(Int(recipe.totalTime)) min."
        timeStack.isHidden = recipe.totalTime == 0
        
        ingredientsLabel.text = recipe.ingredients.joined(separator: ", ")
    }

}
