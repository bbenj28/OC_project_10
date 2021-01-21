//
//  CurrencyResultStructure.swift
//  Reciplease
//
//  Created by Benjamin Breton on 20/10/2020.
//

import Foundation
// Structure of the fixer's JSON file
struct RecipeJSONStructure {
    let start: Int
    let end: Int
    let count: Int
    let hits: [HitJSONStructure]
}
extension RecipeJSONStructure: Decodable {
    enum CodingKeys: String, CodingKey {
        case start = "from"
        case end = "to"
        case count = "count"
        case hits = "hits"
    }
}
struct HitJSONStructure {
    let recipe: RecipeDetailsJSONStructure
}
extension HitJSONStructure: Decodable {
    enum CodingKeys: String, CodingKey {
        case recipe = "recipe"
    }
}
struct RecipeDetailsJSONStructure: Recipe {
    let title: String
    let imageURL: String
    let yield: Int
    let calories: Float
    let totalWeight: Float
    let totalTime: Float
    let ingredients: [String]
    let healthLabels: [String]
    let cautions: [String]
    let digest: [DigestJSONStructure]
}
extension RecipeDetailsJSONStructure: Decodable {
    enum CodingKeys: String, CodingKey {
        case title = "label"
        case imageURL = "image"
        case yield = "yield"
        case calories = "calories"
        case totalWeight = "totalWeight"
        case ingredients = "ingredientLines"
        case totalTime = "totalTime"
        case healthLabels = "healthLabels"
        case cautions = "cautions"
        case digest = "digest"
    }
}
struct IngredientJSONStructure {
    let title: String
    let imageURL: String
}
extension IngredientJSONStructure: Decodable {
    enum CodingKeys: String, CodingKey {
        case title = "text"
        case imageURL = "image"
    }
}
/*
 "label": "Carbs",
 "tag": "CHOCDF",
 "schemaOrgTag": "carbohydrateContent",
 "total": 279.14610302734985,
 "hasRDI": true,
 "daily": 93.04870100911661,
 "unit": "g",
 "sub": [
 */
struct DigestJSONStructure {
    let label: String
    let tag: String
    let total: Double
    let daily: Double
    let unit: String
    let sub: [DigestJSONStructure]?
}
extension DigestJSONStructure: Decodable {
    enum CodingKeys: String, CodingKey {
        case label = "label"
        case tag = "tag"
        case total = "total"
        case daily = "daily"
        case unit = "unit"
        case sub = "sub"
    }
}

/*
 "q": "chicken, rice",
     "from": 0,
     "to": 10,
     "more": true,
     "count": 18710,
     "hits": [
         {
             "recipe": {
                 "uri": "http://www.edamam.com/ontologies/edamam.owl#recipe_110880e24455ef15e2de76501fd5d26e",
                 "label": "Chicken & Rice Soup",
                 "image": "https://www.edamam.com/web-img/abe/abe60dc78fb74335135da20aa9f2b01b.jpg",
                 "source": "Epicurious",
                 "url": "https://www.epicurious.com/recipes/food/views/chicken-rice-soup-366990",
                 "shareAs": "http://www.edamam.com/recipe/chicken-rice-soup-110880e24455ef15e2de76501fd5d26e/chicken%2C+rice",
                 "yield": 4.0,
                 "dietLabels": [],
                 "healthLabels": [
                     "Peanut-Free",
                     "Tree-Nut-Free",
                     "Alcohol-Free"
                 ],
                 "cautions": [
                     "Gluten",
                     "Wheat",
                     "Sulfites",
                     "FODMAP"
                 ],
                 "ingredientLines": [
                     "low-sodium chicken broth 4 cups (32 fl oz/1 l)",
                     "long-grain white rice 1/3 cup (21/2 oz/75 g)",
                     "skinless, boneless chicken breast halves 2",
                     "carrot 1, peeled and diced",
                     "celery 1 stalk, diced",
                     "frozen peas 1 cup (5 oz/155 g)",
                     "garlic 1 clove, sliced",
                     "thyme, dill, or parsley 1/2 teaspoon dried or 1 teaspoon minced fresh",
                     "salt and ground pepper",
                     "fresh lemon juice (optional)"
                 ],
                 "ingredients": [
                     {
                         "text": "low-sodium chicken broth 4 cups (32 fl oz/1 l)",
                         "weight": 960.0000000000001,
                         "image": "https://www.edamam.com/food-img/2eb/2eb3c708f58f5fa1543022650ff0ae8d.png"
                     },
                     {
                         "text": "long-grain white rice 1/3 cup (21/2 oz/75 g)",
                         "weight": 297.6699928125,
                         "image": null
                     },
                     {
                         "text": "skinless, boneless chicken breast halves 2",
                         "weight": 544.0,
                         "image": "https://www.edamam.com/food-img/da5/da510379d3650787338ca16fb69f4c94.jpg"
                     },
                     {
                         "text": "carrot 1, peeled and diced",
                         "weight": 61.0,
                         "image": "https://www.edamam.com/food-img/121/121e33fce0bb9546ed7d060b6c114e29.jpg"
                     },
                     {
                         "text": "celery 1 stalk, diced",
                         "weight": 40.0,
                         "image": "https://www.edamam.com/food-img/d91/d91d2aed1c36d8fad54c4d7dc58f5a18.jpg"
                     },
                     {
                         "text": "frozen peas 1 cup (5 oz/155 g)",
                         "weight": 141.747615625,
                         "image": "https://www.edamam.com/food-img/c91/c9130a361d5c5b279bf48c69e2466ec2.jpg"
                     },
                     {
                         "text": "garlic 1 clove, sliced",
                         "weight": 3.0,
                         "image": "https://www.edamam.com/food-img/6ee/6ee142951f48aaf94f4312409f8d133d.jpg"
                     },
                     {
                         "text": "thyme, dill, or parsley 1/2 teaspoon dried or 1 teaspoon minced fresh",
                         "weight": 0.8,
                         "image": "https://www.edamam.com/food-img/3e7/3e7cf3c8d767a90b906447f5e74059f7.jpg"
                     },
                     {
                         "text": "salt and ground pepper",
                         "weight": 12.289305650625002,
                         "image": "https://www.edamam.com/food-img/694/6943ea510918c6025795e8dc6e6eaaeb.jpg"
                     },
                     {
                         "text": "salt and ground pepper",
                         "weight": 6.144652825312501,
                         "image": "https://www.edamam.com/food-img/c6e/c6e5c3bd8d3bc15175d9766971a4d1b2.jpg"
                     },
                     {
                         "text": "fresh lemon juice (optional)",
                         "weight": 0.0,
                         "image": "https://www.edamam.com/food-img/e31/e310952d214e78a4cb8b73f30ceeaaf2.jpg"
                     }
                 ],
                 "calories": 2039.268716747785,
                 "totalWeight": 2064.715254956897,
                 "totalTime": 0.0,
                 "totalNutrients": {
                     "ENERC_KCAL": {
                         "label": "Energy",
                         "quantity": 2039.268716747785,
                         "unit": "kcal"
                     },
                     "FAT": {
                         "label": "Fat",
                         "quantity": 22.749432102917694,
                         "unit": "g"
                     },
                     "FASAT": {
                         "label": "Saturated",
                         "quantity": 5.476301582284601,
                         "unit": "g"
                     },
                     "FATRN": {
                         "label": "Trans",
                         "quantity": 0.03808,
                         "unit": "g"
                     },
                     "FAMS": {
                         "label": "Monounsaturated",
                         "quantity": 7.031846384525935,
                         "unit": "g"
                     },
                     "FAPU": {
                         "label": "Polyunsaturated",
                         "quantity": 4.401626451399744,
                         "unit": "g"
                     },
                     "CHOCDF": {
                         "label": "Carbs",
                         "quantity": 279.14610302734985,
                         "unit": "g"
                     },
                     "FIBTG": {
                         "label": "Fiber",
                         "quantity": 10.456239867929064,
                         "unit": "g"
                     },
                     "SUGAR": {
                         "label": "Sugars",
                         "quantity": 11.832106559332,
                         "unit": "g"
                     },
                     "PROCNT": {
                         "label": "Protein",
                         "quantity": 170.3922214890812,
                         "unit": "g"
                     },
                     "CHOLE": {
                         "label": "Cholesterol",
                         "quantity": 397.12,
                         "unit": "mg"
                     },
                     "NA": {
                         "label": "Sodium",
                         "quantity": 4777.378351321446,
                         "unit": "mg"
                     },
                     "CA": {
                         "label": "Calcium",
                         "quantity": 198.08030529333968,
                         "unit": "mg"
                     },
                     "MG": {
                         "label": "Magnesium",
                         "quantity": 327.3197638151002,
                         "unit": "mg"
                     },
                     "K": {
                         "label": "Potassium",
                         "quantity": 3514.0227212689297,
                         "unit": "mg"
                     },
                     "FE": {
                         "label": "Iron",
                         "quantity": 9.663309130090823,
                         "unit": "mg"
                     },
                     "ZN": {
                         "label": "Zinc",
                         "quantity": 9.605656727065305,
                         "unit": "mg"
                     },
                     "P": {
                         "label": "Phosphorus",
                         "quantity": 1930.5331885139935,
                         "unit": "mg"
                     },
                     "VITA_RAE": {
                         "label": "Vitamin A",
                         "quantity": 705.7931003565843,
                         "unit": "µg"
                     },
                     "VITC": {
                         "label": "Vitamin C",
                         "quantity": 32.5703708125,
                         "unit": "mg"
                     },
                     "THIA": {
                         "label": "Thiamin (B1)",
                         "quantity": 1.1485355444888374,
                         "unit": "mg"
                     },
                     "RIBF": {
                         "label": "Riboflavin (B2)",
                         "quantity": 1.6118175872605625,
                         "unit": "mg"
                     },
                     "NIA": {
                         "label": "Niacin (B3)",
                         "quantity": 73.41448668401206,
                         "unit": "mg"
                     },
                     "VITB6A": {
                         "label": "Vitamin B6",
                         "quantity": 5.228606950268535,
                         "unit": "mg"
                     },
                     "FOLDFE": {
                         "label": "Folate equivalent (total)",
                         "quantity": 178.36112661467814,
                         "unit": "µg"
                     },
                     "FOLFD": {
                         "label": "Folate (food)",
                         "quantity": 178.36112661467814,
                         "unit": "µg"
                     },
                     "FOLAC": {
                         "label": "Folic acid",
                         "quantity": 0.0,
                         "unit": "µg"
                     },
                     "VITB12": {
                         "label": "Vitamin B12",
                         "quantity": 2.1024000000000003,
                         "unit": "µg"
                     },
                     "VITD": {
                         "label": "Vitamin D",
                         "quantity": 0.0,
                         "unit": "µg"
                     },
                     "TOCPHA": {
                         "label": "Vitamin E",
                         "quantity": 3.651653912508251,
                         "unit": "mg"
                     },
                     "VITK1": {
                         "label": "Vitamin K",
                         "quantity": 70.51738143441156,
                         "unit": "µg"
                     },
                     "WATER": {
                         "label": "Water",
                         "quantity": 1570.4489147798283,
                         "unit": "g"
                     }
                 },
                 "totalDaily": {
                     "ENERC_KCAL": {
                         "label": "Energy",
                         "quantity": 101.96343583738924,
                         "unit": "%"
                     },
                     "FAT": {
                         "label": "Fat",
                         "quantity": 34.99912631218107,
                         "unit": "%"
                     },
                     "FASAT": {
                         "label": "Saturated",
                         "quantity": 27.381507911423007,
                         "unit": "%"
                     },
                     "CHOCDF": {
                         "label": "Carbs",
                         "quantity": 93.04870100911661,
                         "unit": "%"
                     },
                     "FIBTG": {
                         "label": "Fiber",
                         "quantity": 41.824959471716255,
                         "unit": "%"
                     },
                     "PROCNT": {
                         "label": "Protein",
                         "quantity": 340.7844429781624,
                         "unit": "%"
                     },
                     "CHOLE": {
                         "label": "Cholesterol",
                         "quantity": 132.37333333333333,
                         "unit": "%"
                     },
                     "NA": {
                         "label": "Sodium",
                         "quantity": 199.05743130506025,
                         "unit": "%"
                     },
                     "CA": {
                         "label": "Calcium",
                         "quantity": 19.808030529333966,
                         "unit": "%"
                     },
                     "MG": {
                         "label": "Magnesium",
                         "quantity": 77.93327709883339,
                         "unit": "%"
                     },
                     "K": {
                         "label": "Potassium",
                         "quantity": 74.76644087806234,
                         "unit": "%"
                     },
                     "FE": {
                         "label": "Iron",
                         "quantity": 53.6850507227268,
                         "unit": "%"
                     },
                     "ZN": {
                         "label": "Zinc",
                         "quantity": 87.32415206423005,
                         "unit": "%"
                     },
                     "P": {
                         "label": "Phosphorus",
                         "quantity": 275.7904555019991,
                         "unit": "%"
                     },
                     "VITA_RAE": {
                         "label": "Vitamin A",
                         "quantity": 78.42145559517604,
                         "unit": "%"
                     },
                     "VITC": {
                         "label": "Vitamin C",
                         "quantity": 36.18930090277778,
                         "unit": "%"
                     },
                     "THIA": {
                         "label": "Thiamin (B1)",
                         "quantity": 95.71129537406979,
                         "unit": "%"
                     },
                     "RIBF": {
                         "label": "Riboflavin (B2)",
                         "quantity": 123.98596825081249,
                         "unit": "%"
                     },
                     "NIA": {
                         "label": "Niacin (B3)",
                         "quantity": 458.8405417750754,
                         "unit": "%"
                     },
                     "VITB6A": {
                         "label": "Vitamin B6",
                         "quantity": 402.20053463604114,
                         "unit": "%"
                     },
                     "FOLDFE": {
                         "label": "Folate equivalent (total)",
                         "quantity": 44.590281653669535,
                         "unit": "%"
                     },
                     "VITB12": {
                         "label": "Vitamin B12",
                         "quantity": 87.60000000000002,
                         "unit": "%"
                     },
                     "VITD": {
                         "label": "Vitamin D",
                         "quantity": 0.0,
                         "unit": "%"
                     },
                     "TOCPHA": {
                         "label": "Vitamin E",
                         "quantity": 24.344359416721673,
                         "unit": "%"
                     },
                     "VITK1": {
                         "label": "Vitamin K",
                         "quantity": 58.764484528676306,
                         "unit": "%"
                     }
                 },
                 "digest": [
                     {
                         "label": "Fat",
                         "tag": "FAT",
                         "schemaOrgTag": "fatContent",
                         "total": 22.749432102917694,
                         "hasRDI": true,
                         "daily": 34.99912631218107,
                         "unit": "g",
                         "sub": [
                             {
                                 "label": "Saturated",
                                 "tag": "FASAT",
                                 "schemaOrgTag": "saturatedFatContent",
                                 "total": 5.476301582284601,
                                 "hasRDI": true,
                                 "daily": 27.381507911423007,
                                 "unit": "g"
                             },
                             {
                                 "label": "Trans",
                                 "tag": "FATRN",
                                 "schemaOrgTag": "transFatContent",
                                 "total": 0.03808,
                                 "hasRDI": false,
                                 "daily": 0.0,
                                 "unit": "g"
                             },
                             {
                                 "label": "Monounsaturated",
                                 "tag": "FAMS",
                                 "schemaOrgTag": null,
                                 "total": 7.031846384525935,
                                 "hasRDI": false,
                                 "daily": 0.0,
                                 "unit": "g"
                             },
                             {
                                 "label": "Polyunsaturated",
                                 "tag": "FAPU",
                                 "schemaOrgTag": null,
                                 "total": 4.401626451399744,
                                 "hasRDI": false,
                                 "daily": 0.0,
                                 "unit": "g"
                             }
                         ]
                     },
                     {
                         "label": "Carbs",
                         "tag": "CHOCDF",
                         "schemaOrgTag": "carbohydrateContent",
                         "total": 279.14610302734985,
                         "hasRDI": true,
                         "daily": 93.04870100911661,
                         "unit": "g",
                         "sub": [
                             {
                                 "label": "Carbs (net)",
                                 "tag": "CHOCDF.net",
                                 "schemaOrgTag": null,
                                 "total": 268.6898631594208,
                                 "hasRDI": false,
                                 "daily": 0.0,
                                 "unit": "g"
                             },
                             {
                                 "label": "Fiber",
                                 "tag": "FIBTG",
                                 "schemaOrgTag": "fiberContent",
                                 "total": 10.456239867929064,
                                 "hasRDI": true,
                                 "daily": 41.824959471716255,
                                 "unit": "g"
                             },
                             {
                                 "label": "Sugars",
                                 "tag": "SUGAR",
                                 "schemaOrgTag": "sugarContent",
                                 "total": 11.832106559332,
                                 "hasRDI": false,
                                 "daily": 0.0,
                                 "unit": "g"
                             },
                             {
                                 "label": "Sugars, added",
                                 "tag": "SUGAR.added",
                                 "schemaOrgTag": null,
                                 "total": 0.0,
                                 "hasRDI": false,
                                 "daily": 0.0,
                                 "unit": "g"
                             }
                         ]
                     },
                     {
                         "label": "Protein",
                         "tag": "PROCNT",
                         "schemaOrgTag": "proteinContent",
                         "total": 170.3922214890812,
                         "hasRDI": true,
                         "daily": 340.7844429781624,
                         "unit": "g"
                     },
                     {
                         "label": "Cholesterol",
                         "tag": "CHOLE",
                         "schemaOrgTag": "cholesterolContent",
                         "total": 397.12,
                         "hasRDI": true,
                         "daily": 132.37333333333333,
                         "unit": "mg"
                     },
                     {
                         "label": "Sodium",
                         "tag": "NA",
                         "schemaOrgTag": "sodiumContent",
                         "total": 4777.378351321446,
                         "hasRDI": true,
                         "daily": 199.05743130506025,
                         "unit": "mg"
                     },
                     {
                         "label": "Calcium",
                         "tag": "CA",
                         "schemaOrgTag": null,
                         "total": 198.08030529333968,
                         "hasRDI": true,
                         "daily": 19.808030529333966,
                         "unit": "mg"
                     },
                     {
                         "label": "Magnesium",
                         "tag": "MG",
                         "schemaOrgTag": null,
                         "total": 327.3197638151002,
                         "hasRDI": true,
                         "daily": 77.93327709883339,
                         "unit": "mg"
                     },
                     {
                         "label": "Potassium",
                         "tag": "K",
                         "schemaOrgTag": null,
                         "total": 3514.0227212689297,
                         "hasRDI": true,
                         "daily": 74.76644087806234,
                         "unit": "mg"
                     },
                     {
                         "label": "Iron",
                         "tag": "FE",
                         "schemaOrgTag": null,
                         "total": 9.663309130090823,
                         "hasRDI": true,
                         "daily": 53.6850507227268,
                         "unit": "mg"
                     },
                     {
                         "label": "Zinc",
                         "tag": "ZN",
                         "schemaOrgTag": null,
                         "total": 9.605656727065305,
                         "hasRDI": true,
                         "daily": 87.32415206423005,
                         "unit": "mg"
                     },
                     {
                         "label": "Phosphorus",
                         "tag": "P",
                         "schemaOrgTag": null,
                         "total": 1930.5331885139935,
                         "hasRDI": true,
                         "daily": 275.7904555019991,
                         "unit": "mg"
                     },
                     {
                         "label": "Vitamin A",
                         "tag": "VITA_RAE",
                         "schemaOrgTag": null,
                         "total": 705.7931003565843,
                         "hasRDI": true,
                         "daily": 78.42145559517604,
                         "unit": "µg"
                     },
                     {
                         "label": "Vitamin C",
                         "tag": "VITC",
                         "schemaOrgTag": null,
                         "total": 32.5703708125,
                         "hasRDI": true,
                         "daily": 36.18930090277778,
                         "unit": "mg"
                     },
                     {
                         "label": "Thiamin (B1)",
                         "tag": "THIA",
                         "schemaOrgTag": null,
                         "total": 1.1485355444888374,
                         "hasRDI": true,
                         "daily": 95.71129537406979,
                         "unit": "mg"
                     },
                     {
                         "label": "Riboflavin (B2)",
                         "tag": "RIBF",
                         "schemaOrgTag": null,
                         "total": 1.6118175872605625,
                         "hasRDI": true,
                         "daily": 123.98596825081249,
                         "unit": "mg"
                     },
                     {
                         "label": "Niacin (B3)",
                         "tag": "NIA",
                         "schemaOrgTag": null,
                         "total": 73.41448668401206,
                         "hasRDI": true,
                         "daily": 458.8405417750754,
                         "unit": "mg"
                     },
                     {
                         "label": "Vitamin B6",
                         "tag": "VITB6A",
                         "schemaOrgTag": null,
                         "total": 5.228606950268535,
                         "hasRDI": true,
                         "daily": 402.20053463604114,
                         "unit": "mg"
                     },
                     {
                         "label": "Folate equivalent (total)",
                         "tag": "FOLDFE",
                         "schemaOrgTag": null,
                         "total": 178.36112661467814,
                         "hasRDI": true,
                         "daily": 44.590281653669535,
                         "unit": "µg"
                     },
                     {
                         "label": "Folate (food)",
                         "tag": "FOLFD",
                         "schemaOrgTag": null,
                         "total": 178.36112661467814,
                         "hasRDI": false,
                         "daily": 0.0,
                         "unit": "µg"
                     },
                     {
                         "label": "Folic acid",
                         "tag": "FOLAC",
                         "schemaOrgTag": null,
                         "total": 0.0,
                         "hasRDI": false,
                         "daily": 0.0,
                         "unit": "µg"
                     },
                     {
                         "label": "Vitamin B12",
                         "tag": "VITB12",
                         "schemaOrgTag": null,
                         "total": 2.1024000000000003,
                         "hasRDI": true,
                         "daily": 87.60000000000002,
                         "unit": "µg"
                     },
                     {
                         "label": "Vitamin D",
                         "tag": "VITD",
                         "schemaOrgTag": null,
                         "total": 0.0,
                         "hasRDI": true,
                         "daily": 0.0,
                         "unit": "µg"
                     },
                     {
                         "label": "Vitamin E",
                         "tag": "TOCPHA",
                         "schemaOrgTag": null,
                         "total": 3.651653912508251,
                         "hasRDI": true,
                         "daily": 24.344359416721673,
                         "unit": "mg"
                     },
                     {
                         "label": "Vitamin K",
                         "tag": "VITK1",
                         "schemaOrgTag": null,
                         "total": 70.51738143441156,
                         "hasRDI": true,
                         "daily": 58.764484528676306,
                         "unit": "µg"
                     },
                     {
                         "label": "Sugar alcohols",
                         "tag": "Sugar.alcohol",
                         "schemaOrgTag": null,
                         "total": 0.0,
                         "hasRDI": false,
                         "daily": 0.0,
                         "unit": "g"
                     },
                     {
                         "label": "Water",
                         "tag": "WATER",
                         "schemaOrgTag": null,
                         "total": 1570.4489147798283,
                         "hasRDI": false,
                         "daily": 0.0,
                         "unit": "g"
                     }
                 ]
             },
             "bookmarked": false,
             "bought": false
         },
 */
