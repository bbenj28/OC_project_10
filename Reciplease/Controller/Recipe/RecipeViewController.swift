//
//  RecipeTableViewController.swift
//  Reciplease
//
//  Created by Benjamin Breton on 21/01/2021.
//

import UIKit
import SafariServices

class RecipeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var recipe: RecipeService.RecipeDetails?
    var lineTypes: [LineType] = [.title, .picture]
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
        if let recipe = recipe?.0 {
            if recipe.ingredients.count > 0 { lineTypes.append(.ingredients) }
            if recipe.calories > 0 { lineTypes.append(.calories) }
            if recipe.totalWeight > 0 { lineTypes.append(.weight) }
            if recipe.healthLabels.count > 0 { lineTypes.append(.health) }
            if recipe.cautions.count > 0 { lineTypes.append(.cautions) }
        }
        setFavouriteButton()
        
    }
    private func setFavouriteButton() {
        let imageName = isFavourite ? "star.added" : "star.add"
        guard let image = UIImage(named: imageName) else { return }
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(favouriteButtonHasBeenHitten))
        navigationItem.rightBarButtonItems = [button]
    }
    @objc
    private func favouriteButtonHasBeenHitten() {
        isFavourite.toggle()
    }
    @IBAction func getDirections(_ sender: Any) {
        if let recipe = recipe?.0, let url = URL(string: recipe.url) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }
    
    
}
extension RecipeViewController: UITableViewDelegate, UITableViewDataSource {
    
    enum LineType {
        case title, picture, ingredients, health, cautions, calories, weight
        var cellIdentifier: String {
            switch self {
            case .title:
                return "TitleCell"
            case .picture:
                return "PictureCell"
            case .ingredients, .health, .cautions:
                return "TextCell"
            case .calories, .weight:
                return "DetailCell"
            }
        }
        func getTitle(_ recipe: RecipeService.RecipeDetails) -> String {
            switch self {
            case .title:
                return recipe.0.title
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
        func getDetails(_ recipe: RecipeService.RecipeDetails) -> String {
            switch self {
            case .ingredients:
                return mapDetails(recipe.0.ingredients)
            case .health:
                return mapDetails(recipe.0.healthLabels)
            case .cautions:
                return mapDetails(recipe.0.cautions)
            case .calories:
                return formatNumber(NSNumber(value: recipe.0.calories))
            case .weight:
                return formatNumber(NSNumber(value: recipe.0.totalWeight))
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
        guard let pictureCell = cell as? PictureCellTableViewCell else { return cell }
        pictureCell.setCell(details: recipe.0, imageData: recipe.1)
        return pictureCell
    }

    
}
