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
    var recipes: [Recipe] = [] {
        didSet {
            showRecipesIngredients = Array(repeating: false, count: recipes.count)
        }
    }
    /// Loaded recipes without removed recipes.
    private var recipesToDisplay: [Recipe] {
        var recipesToDisplay: [Recipe] = []
        for recipe in recipes {
            if recipe.title != "" { recipesToDisplay.append(recipe) }
        }
        return recipesToDisplay
    }
    /// Recipe selected by user.
    private var selectedRecipe: Recipe?
    /// Used to know if ingredients have to be displayed in cells.
    private var showRecipesIngredients: [Bool]?
    /// Used to know if favorite recipes are going to be loaded.
    private var isSearching: Bool = true {
        didSet {
            isSearching ? activityIndicator.animate() : activityIndicator.stopAnimating()
        }
    }
    /// Activity indicator to display while loading favorites.
    lazy private var activityIndicator = RecipeActivityIndicator(superview: view)

    // MARK: - Viewdidload
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set title depending on the method used by the recipe getter
        navigationItem.title = recipeGetter?.method.title
    }
    
    // MARK: - View did appear
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // load recipes depending on the method used by the recipe getter
        switch recipeGetter?.method {
        case .manager:
            loadRecipes()
        default:
            isSearching = false
        }
    }
    /// Load recipes.
    private func loadRecipes() {
        isSearching = true
        recipeGetter?.getRecipes(completionHandler: weakify({ (strongSelf, result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let recipes):
                    strongSelf.recipes = recipes
                case .failure(let error):
                    strongSelf.showAlert(error: error)
                    strongSelf.recipes = []
                }
                strongSelf.tableView.reloadData()
                strongSelf.isSearching = false
            }
        }))
    }
}

extension ResultsTableViewController {

    // MARK: - Table view data source
    
    // number of rows = recipes count
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipesToDisplay.count
    }
    // cell to display in a specific row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath) as? ResultTableViewCell else { return UITableViewCell() }
        setCell(cell, indexPath.row)
        return cell
    }
    private func setCell(_ cell: ResultTableViewCell, _ row: Int) {
        guard let showRecipesIngredients = showRecipesIngredients else { return }
        cell.recipe = recipesToDisplay[row]
        cell.delegate = self
        cell.index = row
        cell.ingredientsAreShown = showRecipesIngredients[row]
    }
    // row selection : set selectedRecipe with the recipe which is displayed by the selected row and present recipe controller
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRecipe = recipesToDisplay[indexPath.row]
        performSegue(withIdentifier: "ResultsToRecipeSegue", sender: self)
    }
    // prepare for segue : recipe and recipeGetter transmission
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? RecipeViewController, let recipe = selectedRecipe {
            controller.recipe = recipe
            controller.recipeGetter = recipeGetter
        }
    }
    
    // MARK: - Add favorites instructions
    
    /// Tableview's footer used to display instructions when tableview is empty.
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        // no recipes means no favorites: show instructions to add favorites
        isSearching ? activityIndicator.animate() : activityIndicator.stopAnimating()
        return isSearching ? UIView() : getInstructionsView(title: "no favorites so far", instructions: ["> to add favorites:", "  - do a research;", "  - open a recipe;", "  - hit star button on the top right."], isHidden: recipes.count > 0)
    }
    /// Tableview's sections footer's height depending on tableview's emptyness.
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return recipes.count > 0 ? 0 : tableView.frame.height
    }
}
extension ResultsTableViewController: ToggleIngredientsDelegate {
    
    // MARK: - Toggle ingredients delegate
    
    /// Method called when user hit the *show ingredients* button.
    /// - parameter index: index in the showRecipesIngredients property.
    func toggleIngredients(index: Int) {
        guard let value = showRecipesIngredients?[index] else { return }
        showRecipesIngredients?.remove(at: index)
        showRecipesIngredients?.insert(!value, at: index)
        tableView.reloadData()
    }
}
