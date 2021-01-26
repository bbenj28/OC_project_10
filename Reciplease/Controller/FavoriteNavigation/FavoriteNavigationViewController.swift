//
//  FavoriteNavigationViewController.swift
//  Reciplease
//
//  Created by Benjamin Breton on 25/01/2021.
//

import UIKit

class FavoriteNavigationViewController: UINavigationController, RecipeGetterProtocol {
    /// Property used by other controllers to get recipes.
    var recipeGetter: RecipeGetter?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if var controller = topViewController as? RecipeGetterProtocol {
            // set recipeGetter's method to manager, and transmit it
            recipeGetter?.method = .manager
            controller.recipeGetter = recipeGetter
        }
    }

}
