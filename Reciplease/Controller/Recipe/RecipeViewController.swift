//
//  RecipeTableViewController.swift
//  Reciplease
//
//  Created by Benjamin Breton on 21/01/2021.
//

import UIKit
import SafariServices

class RecipeViewController: UIViewController, RecipeGetterProtocol {
    var recipeGetter: RecipeGetter?
    
    @IBOutlet weak var tableView: UITableView!
    var recipe: Recipe?
    var lineTypes: [LineType] = [.title, .collection, .picture]
    var numberOfLines: Int = 0
    var isFavourite: Bool = false {
        didSet {
            setFavouriteButton()
        }
    }
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
        if let recipe = recipe as? RecipeDetailsJSONStructure {
            recipeGetter?.checkIfIsFavorite(recipe, completionHandler: { (isFavourite) in
                self.isFavourite = isFavourite
            })
        } else {
            isFavourite = true
        }
        setFavouriteButton()
        
    }
    private func setFavouriteButton() {
        let imageName = isFavourite ? "star.added" : "star.add"
        guard let image = UIImage(named: imageName) else { return }
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(favouriteButtonHasBeenHitten))
        button.tintColor = isFavourite ? #colorLiteral(red: 1, green: 0.9374062272, blue: 0.3152640763, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        navigationItem.rightBarButtonItems = [button]
    }
    @objc
    private func favouriteButtonHasBeenHitten() {
        isFavourite ? removeFromFavourites() : addToFavourites()
    }
    private func addToFavourites() {
        guard let recipe = recipe else { return }
        recipeGetter?.addToFavorites(recipe, completionHandler: {
            self.isFavourite.toggle()
            self.showAlert(title: "Added !", message: "This recipe is now one of your favorites.")
        })
    }
    private func removeFromFavourites() {
        guard let recipe = recipe else { return }
        recipeGetter?.removeFromFavorites(recipe, completionHandler: { (hasToCloseTable) in
            showAlert(title: "Removed", message: "This recipe has been removed from your favorites.", okHandler:  { (_) in
                self.isFavourite.toggle()
                if hasToCloseTable {
                    self.navigationController?.popViewController(animated: true)
                }
            })
        })
    }
    @IBAction func getDirections(_ sender: Any) {
        if let recipe = recipe, let url = URL(string: recipe.url) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }
    
    
}
extension RecipeViewController: UITableViewDelegate, UITableViewDataSource {
    
    enum LineType {
        case title, collection, picture, ingredients, health, cautions, calories, weight
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
        func getDetails(_ recipe: Recipe) -> String {
            switch self {
            case .ingredients:
                return mapDetails(recipe.ingredients)
            case .health:
                return mapDetails(recipe.healthLabels)
            case .cautions:
                return mapDetails(recipe.cautions)
            case .calories:
                return formatNumber(NSNumber(value: recipe.calories))
            case .weight:
                return formatNumber(NSNumber(value: recipe.totalWeight))
            default:
                return ""
            }
        }
        private func mapDetails(_ details: [String]) -> String {
            return details.map({ "- \($0)" }).joined(separator: "\n")
        }
        private func formatNumber(_ number: NSNumber) -> String {
            let formatter = NumberFormatter()
            formatter.maximumFractionDigits = 2
            formatter.minimumFractionDigits = 2
            guard let number = formatter.string(from: number) else { return "" }
            return number
        }
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lineTypes.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let lineType = lineTypes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: lineType.cellIdentifier, for: indexPath)
        guard let recipe = recipe else { return cell }
        cell.textLabel?.text = lineType.getTitle(recipe)
        cell.detailTextLabel?.text = lineType.getDetails(recipe)
        if let pictureCell = cell as? PictureCellTableViewCell {
            pictureCell.setCell(recipe: recipe)
            return pictureCell
        } else if let collectionCell = cell as? CollectionTableViewCell {
            collectionCell.setCell(recipe)
            return collectionCell
        }
        
        return cell
    }

    
}
