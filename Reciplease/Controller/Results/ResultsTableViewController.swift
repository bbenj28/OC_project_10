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
    /// Ingredients choosen by the user in the search page.
    var choosenIngredients: [String] = []
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
    /// Is this controller actually searching for recipes.
    var isSearching: Bool = false {
        didSet {
            indicator.isHidden = !isSearching
        }
    }
    /// Activity indicator used when searching recipes.
    let indicator = RecipeActivityIndicator()

    // MARK: - Viewdidload
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = recipeGetter?.method.title
        loadRecipes()
    }
    /// Load recipes.
    private func loadRecipes() {
        showActivityIndicator()
        isSearching = true
        tableView.reloadData()
        recipeGetter?.getRecipes(ingredients: choosenIngredients, completionHandler: { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let recipes):
                    self.recipes = recipes
                    self.tableView.reloadData()
                    self.isSearching = false
                case .failure(let error):
                    self.isSearching = false
                    self.showAlert(error: error)
                    self.recipes = []
                }
            }
        })
    }
    private func showActivityIndicator() {
        tableView.tableFooterView = UIView()
        indicator.frame.size = CGSize(width: 150, height: 150)
        indicator.animate()
        indicator.center = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
        view.addSubview(indicator)
    }
    
    // MARK: - View will appear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
}

extension ResultsTableViewController {

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipesToDisplay.count
    }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = isSearching ? "" : recipesToDisplay.count == 0 ? "oops, no recipe has been found..." : ""
        label.font = UIFont(name: "Chalkduster", size: 17)
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return label
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath) as? ResultTableViewCell else { return UITableViewCell() }
        let result = recipesToDisplay[indexPath.row]
        cell.setCell(recipe: result)
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
