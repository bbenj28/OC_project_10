//
//  ResultTableViewCell.swift
//  Reciplease
//
//  Created by Benjamin Breton on 20/01/2021.
//

import UIKit

class ResultTableViewCell: UITableViewCell, RecipeCell {
    
    // MARK: - Properties
    
    /// Recipe to display in the cell.
    var recipe: Recipe? {
        didSet {
            guard let recipe = recipe else { return }
            resultTitleLabel.text = recipe.title
            personsLabel.text = "\(recipe.yield)"
            timeLabel.text = recipe.totalTime > 0 ? "\(Int(recipe.totalTime)) min." : "no\ninfos"
            timeLabel.textColor = recipe.totalTime > 0 ? UIColor(named: "MiddleBack") : UIColor(named: "LightBack")
            timeStack.tintColor = timeLabel.textColor
            ingredientsLabel.text = "\(recipe.ingredients)\n"
            guard let data = recipe.pictureData, let image = UIImage(data: data) else {
                resultPictureView.image = UIImage(named: "default1")
                return
            }
            resultPictureView.image = image
            ingredientsAreShown = false
        }
    }
    /// Used to show ingredients on demand.
    var ingredientsAreShown: Bool? {
        didSet {
            guard let ingredientsAreShown = ingredientsAreShown else { return }
            ingredientsButton.setTitle(ingredientsAreShown ? "- hide ingredients -" : "+ show ingredients +", for: .normal)
            ingredientsLabel.isHidden = !ingredientsAreShown
        }
    }
    /// Index of this cell in the controller.
    var index: Int?
    /// Delegate used to toggle ingredients on demand.
    var delegate: ToggleIngredientsDelegate?
    
    // MARK: - Outlets
    
    /// Toggle ingredients button.
    @IBOutlet weak private var ingredientsButton: UIButton!
    /// Stack view containing time informations.
    @IBOutlet weak private var timeStack: UIStackView!
    /// Label containing ingredients list.
    @IBOutlet weak private var ingredientsLabel: UILabel!
    /// View containing all informations in the cell.
    @IBOutlet weak private var resultView: UIView!
    /// Label displaying the recipe's title.
    @IBOutlet weak private var resultTitleLabel: UILabel!
    /// View containing recipe's picture.
    @IBOutlet weak private var resultPictureView: UIImageView!
    /// Label displaying time's indications.
    @IBOutlet weak private var timeLabel: UILabel!
    /// Label displaying yield's indications.
    @IBOutlet weak private var personsLabel: UILabel!
    
    // MARK: - Awake from nib
    
    override func awakeFromNib() {
        super.awakeFromNib()
        resultView.layer.cornerRadius = 20
        resultPictureView.layer.cornerRadius = resultView.layer.cornerRadius
        resultPictureView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner]
    }
    
    // MARK: - Toggle ingredients
    
    @IBAction private func toggleIngredients(_ sender: Any) {
        guard let index = index, let delegate = delegate else { return }
        delegate.toggleIngredients(index: index)
    }
}

// MARK: - Toggle ingredients delegate

protocol ToggleIngredientsDelegate {
    func toggleIngredients(index: Int)
}
