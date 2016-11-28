//
//  mConstants.swift
//  Whip It Up
//
//  Created by user119166 on 11/22/16.
//  Copyright © 2016 krudeboy51. All rights reserved.
//

import Foundation

struct Constants{
    static let serverLink = "http://mrkking.com/badman/php/Mashape.php"
    struct linkKeys{
        static let forceExtraction = "forceExtraction"
        static let url = "link"
        static let query = "q"
        static let id = "id"
        static let num = "n"
        static let offset = "offset"
    }
    
    struct resultsKey{
        static let results = "results"
        static let id = "id"
        static let readyMin = "readyInMinutes"
        static let vegan = "vegan"
        static let prepMin = "preparationMinutes"
        static let cookMin = "cookingMinutes"
        static let servings = "servings"
        static let title = "title"
        static let inglist = "extendedIngredients"
        static let image = "image"
        static let baseURI = "baseUri" //"https://spoonacular.com/recipeImages/"
        struct ingredients {
            static let amount = "amount"
            static let name = "originalString"
            static let image = "image"
            static let aisle = "aisle"
        }
    }
}
