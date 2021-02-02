//
//  RecipeTableViewController.swift
//  Reciplease
//
//  Created by Benjamin Breton on 21/01/2021.
//

import UIKit

class RecipeViewController: UIViewController, RecipeGetterProtocol {
    
    // MARK: - Properties
    
    /// Recipe getter used to save recipe.
    var recipeGetter: RecipeGetter?
    /// Displayed recipe.
    var recipe: Recipe?
    /// Typelines to display.
    private var lineTypes: [LineType] = [.title, .collection, .picture]
    /// Number of lines.
    private var numberOfLines: Int = 0
    /// Is this recipe a favorite one.
    private var isFavorite: Bool = false {
        didSet {
            if !isFavorite && tabBarController?.selectedIndex == 1 {
                navigationController?.popViewController(animated: true)
            }
            setFavoriteButton(true)
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak private var tableView: UITableView!
    
    // MARK: - View did load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        if let recipe = recipe {
            if recipe.ingredients.count > 0 { lineTypes.append(.ingredients) }
            if recipe.calories > 0 { lineTypes.append(.calories) }
            if recipe.totalWeight > 0 { lineTypes.append(.weight) }
            if recipe.healthLabels.count > 0 { lineTypes.append(.health) }
            if recipe.cautions.count > 0 { lineTypes.append(.cautions) }
        }
        setFavoriteButton(false)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ckeckIfIsFavorite()
    }
    /// Change favorite button regarding isFavorite property value.
    private func setFavoriteButton(_ isEnabled: Bool) {
        let imageName = isFavorite ? "star.added" : "star.add"
        guard let image = UIImage(named: imageName) else { return }
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(favoriteButtonHasBeenHitten))
        button.tintColor = isFavorite ? #colorLiteral(red: 1, green: 0.9374062272, blue: 0.3152640763, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        button.isEnabled = isEnabled
        navigationItem.rightBarButtonItems = [button]
    }
    private func ckeckIfIsFavorite() {
        guard let recipe = recipe else { return }
        recipeGetter?.checkIfIsFavorite(recipe, completionHandler: { (isFavorite) in
            self.isFavorite = isFavorite
        })
    }
    /// Actions to do when favorite button has been hitten.
    @objc
    private func favoriteButtonHasBeenHitten() {
        isFavorite ? removeFromFavorites() : addToFavorites()
    }
    /// Add a recipe to favorites.
    private func addToFavorites() {
        guard let recipe = recipe else { return }
        recipeGetter?.addToFavorites(recipe)
        isFavorite.toggle()
        showAlert(title: "Added !", message: "This recipe is now one of your favorites.")
    }
    /// Remove a recipe from favorite.
    private func removeFromFavorites() {
        guard let recipe = recipe else { return }
        recipeGetter?.removeFromFavorites(recipe)
        showAlert(title: "Removed", message: "This recipe has been removed from your favorites.", okHandler:  weakify({ (strongSelf, _) in
            strongSelf.isFavorite.toggle()
        }))
    }
    /// Open a safari page containing the recipe's directions.
    @IBAction private func getDirections(_ sender: Any) {
        if let recipe = recipe, let url = URL(string: recipe.url) {
            UIApplication.shared.open(url, options: [:])
        }
    }
}

extension RecipeViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Table's linetypes
    
    /// Enumeration containing the differents linetypes of the tableview.
    enum LineType {
        case title, collection, picture, ingredients, health, cautions, calories, weight
        /// Cell's identifier for a linetype.
        var cellIdentifier: String {
            switch self {
            case .title:
                return "TitleCell"
            case .collection:
                return "CollectionCell"
            case .picture:
                return "PictureCell"
            case .ingredients, .health, .cautions:
                return "TextCell"
            case .calories, .weight:
                return "DetailCell"
            }
        }
        /// Title to display for a linetype.
        func getTitle(_ recipe: Recipe) -> String {
            switch self {
            case .title:
                return recipe.title
            case .ingredients:
                return "Ingredients:"
            case .health:
                return "Health indications:"
            case .cautions:
                return "Contains:"
            case .calories:
                return "Calories:"
            case .weight:
                return "Weight:"
            default:
                return ""
            }
        }
        /// Details to display for a linetype.
        func getDetails(_ recipe: Recipe) -> String {
            switch self {
            case .ingredients:
                return recipe.ingredients
            case .health:
                return recipe.healthLabels
            case .cautions:
                return recipe.cautions
            case .calories:
                return formatNumber(NSNumber(value: recipe.calories))
            case .weight:
                return formatNumber(NSNumber(value: recipe.totalWeight))
            default:
                return ""
            }
        }
        /// Used by getDetails to concatenate informations.
        private func mapDetails(_ details: [String]) -> String {
            return details.map({ "- \($0)" }).joined(separator: "\n")
        }
        /// Used by getDetails to formatting a number.
        private func formatNumber(_ number: NSNumber) -> String {
            let formatter = NumberFormatter()
            formatter.maximumFractionDigits = 2
            formatter.minimumFractionDigits = 2
            guard let number = formatter.string(from: number) else { return "" }
            return number
        }
    }

    // MARK: - Tableview datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lineTypes.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let lineType = lineTypes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: lineType.cellIdentifier, for: indexPath)
        guard let recipe = recipe else { return cell }
        cell.textLabel?.text = lineType.getTitle(recipe)
        cell.detailTextLabel?.text = lineType.getDetails(recipe)
        if var recipeCell = cell as? RecipeCell { recipeCell.recipe = recipe }
        return cell
    }

}
protocol RecipeCell {
    var recipe: Recipe? { get set }
}
