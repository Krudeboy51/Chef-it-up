	///
//  MashapeJsonParser.swift
//  curl
//
//  Created by Kory E King on 11/11/16.
//  Copyright © 2016 Kory E King. All rights reserved.
//

import Foundation
import UIKit

/*curl --get --include 'https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/extract?forceExtraction=false&url=http%3A%2F%2Fallrecipes.com%2FRecipe%2FSlow-Cooker-Chicken-Tortilla-Soup%2FDetail.aspx' \
-H 'X-Mashape-Key: DCrlBqI7Xjmsh1CsLRHWWDX89z5rp1EvsE6jsnjkh5Nnc7Vow6'*/

class MashapeJsonParser: NSObject{
    
    var recipe : RecipeModel!
    
    private func createLink(id: String)->NSURL?{
        let urlComp = NSURLComponents(string: Constants.serverLink)
        var linkparams = Dictionary<String, String>()
        linkparams[Constants.resultsKey.id] = id
        
        var query = Array<NSURLQueryItem>()
        
        for (key, value) in linkparams{
            query.append(NSURLQueryItem(name: key, value: value))
        }
        
        urlComp?.queryItems = query
        print(urlComp?.string)
        return urlComp?.URL
    }
    
    private func getJsonFromLink(id: String){
        let request = NSMutableURLRequest(URL: createLink(id)!)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let semaphore = dispatch_semaphore_create(0)
        let task = session.dataTaskWithRequest(request, completionHandler:
            {
                (data, response, error) in
                
                if let mError = error {
                    print("Mayday we have a problem: \(mError)")
                }else if let _ =  response, let mData = data{
                    let rec = RecipeModel()
                    var jError: NSError?
                    let parseData = JSON.init(data: mData, options: NSJSONReadingOptions.AllowFragments, error: &jError)
                    rec.title = parseData["title"].stringValue
                    rec.vegan = parseData["vegan"].boolValue
                    rec.prepMin = parseData["preparationMinutes"].intValue
                    rec.cookmin = parseData["cookingMinutes"].intValue
                    rec.servings = parseData["servings"].int!
                    rec.instructions = parseData["instructions"].string
                    for item in parseData["extendedIngredients"].array!{
                        rec.addIngredient(item["aisle"].stringValue, image: item["image"].stringValue, name: item["name"].stringValue, info: item["originalString"].stringValue)
                    }
                    self.recipe = rec
                    dispatch_semaphore_signal(semaphore)
                }
            }
        )
        
        task.resume()
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
    }
    
    func getData(id: String){
        getJsonFromLink(id)
    }
}
