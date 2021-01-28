//
//  ResultsTableViewController.swift
//  Reciplease
//
//  Created by Benjamin Breton on 20/01/2021.
//

import UIKit

class ResultsTableViewController: UITableViewController, RecipeGetterProtocol {
    
    // MARK: - Properties
    
    /// Recipe getter.
    var recipeGetter: RecipeGetter?
    /// Loaded recipes.
    var recipes: [Recipe] = []
    /// Loaded recipes without removed recipes.
    var recipesToDisplay: [Recipe] {
        var recipesToDisplay: [Recipe] = []
        for recipe in recipes {
            if recipe.title != "" { recipesToDisplay.append(recipe) }
        }
        return recipesToDisplay
    }
    /// Recipe selected by user.
    var selectedRecipe: Recipe?

    // MARK: - Viewdidload
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = recipeGetter?.method.title
    }
    /// Load recipes.
    private func loadRecipes() {
        recipeGetter?.getRecipes() { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let recipes):
                    self.recipes = recipes
                case .failure(let error):
                    self.showAlert(error: error)
                    self.recipes = []
                }
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - View did appear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        switch recipeGetter?.method {
        case .manager:
            loadRecipes()
        default:
            break
        }
    }
}

extension ResultsTableViewController {

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipesToDisplay.count
    }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = recipesToDisplay.count == 0 ? "oops, no recipe has been found..." : ""
        label.font = UIFont(name: "Chalkduster", size: 17)
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return label
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath) as? ResultTableViewCell else { return UITableViewCell() }
        let recipe = recipesToDisplay[indexPath.row]
        cell.recipe = recipe
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRecipe = recipesToDisplay[indexPath.row]
        performSegue(withIdentifier: "ResultsToRecipeSegue", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? RecipeViewController, let recipe = selectedRecipe {
            controller.recipe = recipe
            controller.recipeGetter = recipeGetter
        }
    }
}
