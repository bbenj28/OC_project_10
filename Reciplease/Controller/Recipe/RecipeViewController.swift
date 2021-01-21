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
        case title, picture, ingredients, health, cautions
        var cellIdentifier: String {
            switch self {
            case .title:
                return "TitleCell"
            case .picture:
                return "PictureCell"
            case .ingredients, .health, .cautions:
                return "TextCell"
            }
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
        if let recipe = recipe {
            switch lineType {
            case .title:
                cell.textLabel?.text = recipe.0.title
                return cell
            case .picture:
                if indexPath.row == 1, let cell = cell as? PictureCellTableViewCell {
                    let details = recipe.0
                    let pictureData = recipe.1
                    guard let data = pictureData, let image = UIImage(data: data) else {
                        guard let image = UIImage(named: "meal") else { fatalError() }
                        cell.setCell(details: details, picture: image)
                        return cell
                    }
                    cell.setCell(details: details, picture: image)
                    return cell
                }
            case .ingredients:
                cell.textLabel?.text = "Ingredients:"
                cell.detailTextLabel?.text = recipe.0.ingredients.map({"- \($0)"}).joined(separator: "\n")
                return cell
            case .health:
                cell.textLabel?.text = "Health indications:"
                cell.detailTextLabel?.text = recipe.0.healthLabels.map({"- \($0)"}).joined(separator: "\n")
                return cell
            case .cautions:
                cell.textLabel?.text = "Contains:"
                cell.detailTextLabel?.text = recipe.0.cautions.map({"- \($0)"}).joined(separator: "\n")
                return cell
            }
        }
        return cell
    }

    
}
