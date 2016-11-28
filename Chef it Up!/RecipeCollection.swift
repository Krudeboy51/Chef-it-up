//
//  RecipeCollection.swift
//  Whip It Up
//
//  Created by user119166 on 11/22/16.
//  Copyright © 2016 krudeboy51. All rights reserved.
//

import Foundation
import UIKit

class RecipeCollection{
    
    var numOfItems = 50
    var offsetValue = 20
    var mReicpeList = [Dictionary<String, String>()]
    var imgList =  Dictionary<String, UIImage>()
    
    
    private func createLink(action: mUrlAction)->NSURL?{
        let urlComp = NSURLComponents(string: Constants.serverLink)
        var linkparams = Dictionary<String, String>()
        switch action {
        case .Random:
            linkparams[Constants.linkKeys.query] = ""
            linkparams[Constants.linkKeys.num] = "\(numOfItems)"
            linkparams[Constants.linkKeys.offset] = "0"
        case .Search(let searchterm):
            linkparams[Constants.linkKeys.query] = searchterm
            linkparams[Constants.linkKeys.num] = "\(numOfItems)"
            linkparams[Constants.linkKeys.offset] = "0"
        case .loadMore(let searchterm):
            linkparams[Constants.linkKeys.query] = searchterm
            linkparams[Constants.linkKeys.num] = "\(numOfItems)"
            linkparams[Constants.linkKeys.offset] = "\(offsetValue)"
        }
        
        var query = Array<NSURLQueryItem>()
        
        for (key, value) in linkparams{
            query.append(NSURLQueryItem(name: key, value: value))
        }
        
        urlComp?.queryItems = query
        print(urlComp?.string)
        return urlComp?.URL
    }
    
    func getRecipesFromURL(url: NSURL, completionHandler: (([Dictionary<String, String>]) -> Void)? = nil){
        print("INSIDE RECIPE")
        var currentItem = Dictionary<String, String>()
        let request = NSMutableURLRequest(URL: url)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let task = session.dataTaskWithRequest(request, completionHandler:
            {
                (data, response, error) in
                if let mError = error {
                    print("Mayday we have a problem: \(mError)")
                }else if let _ =  response, let mData = data{
                    var jError: NSError?
                    let parseData = JSON.init(data: mData, options: NSJSONReadingOptions.AllowFragments, error: &jError)
                    let baseURI = parseData[Constants.resultsKey.baseURI].stringValue
                    var counter = 1
                    for item in parseData[Constants.resultsKey.results].arrayValue{
                        if self.mReicpeList.count > counter{
                            counter += 1
                            continue
                        }
                        counter += 1
                        currentItem[Constants.resultsKey.id] = item[Constants.resultsKey.id].stringValue
                        currentItem[Constants.resultsKey.title] = item[Constants.resultsKey.title].stringValue
                        currentItem[Constants.resultsKey.readyMin] = item[Constants.resultsKey.readyMin].stringValue
                        currentItem[Constants.resultsKey.image] = "\(baseURI)\(item[Constants.resultsKey.image].stringValue)"
                        if let url = NSURL(string: currentItem[Constants.resultsKey.image]!){
                            if let data = NSData(contentsOfURL: url){
                                self.imgList[currentItem[Constants.resultsKey.id]!] = UIImage(data: data)
                            }
                        }
                        self.mReicpeList.append(currentItem)
                    }
                    if let handler = completionHandler{
                        print("RUNNING HANDLER")
                        dispatch_async(dispatch_get_main_queue(), {
                            handler(self.mReicpeList)
                        })
                    }
                }
            }
        )
        
        
        task.resume()
    }
    
    
    func search(item: String, completionHandler: (([Dictionary<String, String>]) -> Void)? = nil){
        mReicpeList.removeAll()
        print("SEARCH ITEM \(item)")
        let link = createLink(.Search(item))
        getRecipesFromURL(link!, completionHandler: completionHandler)
    }
    
    func getRandom(completionHandler: (([Dictionary<String, String>]) -> Void)? = nil){
        mReicpeList.removeAll()
        let link = createLink(.Random)
        getRecipesFromURL(link!, completionHandler: completionHandler)
    }
    
    private enum mUrlAction {
        case Random
        case Search(String)
        case loadMore(String)
    }
    
    //implemental
    func loadMoreRecipes(item: String = "",completionHandler: (([Dictionary<String, String>]) -> Void)? = nil){
        let link = createLink(.loadMore(item))
        getRecipesFromURL(link!, completionHandler: completionHandler)
    }
    
}
