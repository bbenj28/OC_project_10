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
    var recipesToDisplay: [Recipe] {
        var recipesToDisplay: [Recipe] = []
        for recipe in recipes {
            if recipe.title != "" { recipesToDisplay.append(recipe) }
        }
        return recipesToDisplay
    }
    /// Recipe selected by user.
    var selectedRecipe: Recipe?
    
    var showRecipesIngredients: [Bool]?

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
            break
        }
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
}

extension ResultsTableViewController {

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipesToDisplay.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath) as? ResultTableViewCell, let showRecipesIngredients = showRecipesIngredients else { return UITableViewCell() }
        let recipe = recipesToDisplay[indexPath.row]
        cell.recipe = recipe
        cell.delegate = self
        cell.index = indexPath.row
        cell.ingredientsAreShown = showRecipesIngredients[indexPath.row]
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
    
    // MARK: - Add favorites instructions
    
    /// Tableview's footer used to display instructions when tableview is empty.
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        // no recipes means no favorites: show instructions to add favorites
        let view = getInstructionsView(title: "no favorites so far", instructions: ["> to add favorites:", "  - do a research;", "  - open a recipe;", "  - hit star button on the top right."], isHidden: recipes.count > 0)
        return view
    }
    /// Tableview's sections footer's height depending on tableview's emptyness.
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return recipes.count > 0 ? 0 : tableView.frame.height
    }
}
extension ResultsTableViewController: ToggleIngredientsDelegate {
    func toggleIngredients(index: Int) {
        guard let value = showRecipesIngredients?[index] else { return }
        showRecipesIngredients?.remove(at: index)
        showRecipesIngredients?.insert(!value, at: index)
        tableView.reloadData()
    }
}
