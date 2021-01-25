//
//  SearchNavigationViewController.swift
//  Reciplease
//
//  Created by Benjamin Breton on 25/01/2021.
//

import UIKit

class SearchNavigationViewController: UINavigationController, RecipeGetterProtocol {
    
    var recipeGetter: RecipeGetter?

    override func viewDidLoad() {
        super.viewDidLoad()
        if var controller = topViewController as? RecipeGetterProtocol {
            recipeGetter?.method = .service
            controller.recipeGetter = recipeGetter
        }
    }

}
