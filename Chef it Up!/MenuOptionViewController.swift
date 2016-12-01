//
//  MenuOptionViewController.swift
//  Chef it Up!
//
//  Created by user119166 on 12/1/16.
//  Copyright © 2016 Kory E King. All rights reserved.
//

import UIKit

class MenuOptionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tbv: UITableView!
    var detailViewController: DetailViewController? = nil
    var objects = [AnyObject]()
    var recipeCollection = RecipeCollection()
    var recipeList = [Dictionary<String, String>]()
    let searchController = UISearchController(searchResultsController: nil)
    var searchitem = ""
    
    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        if searchitem != ""{
            recipeCollection.search(searchitem){
                (recipes) in
                self.recipeList = recipes
                self.tbv.reloadData()
            }
        }else{
            recipeCollection.getRandom(){
                (recipes) in
                self.recipeList = recipes
                self.tbv.reloadData()
            }
            self.tbv.tableHeaderView = searchController.searchBar
            searchController.searchBar.placeholder = "search e.g. eggs"
            searchController.searchBar.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("recipeLCell", forIndexPath: indexPath) as! CustomTBVCell
        
        let recipeItem = recipeList[indexPath.row]
        let id = recipeItem[Constants.resultsKey.id]
        var time_St = recipeItem[Constants.resultsKey.readyMin]! as String
        
        let time:Int = Int(time_St)! as Int
        
        if time > 60{
            print("Time: \(time)")
            let hrs = (time/60) as Int
            let mins = time % 60
            time_St = "\(hrs)hr(s) and \(mins)"
            print(time_St)
        }
        
        
        cell.rectitle.text = recipeItem[Constants.resultsKey.title]
        cell.recimage.image = recipeCollection.imgList[id!]
        cell.time.text = "Ready in: \(time_St) mins"
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    

    func titleGen(title: String) -> String{
        let titleArray = title.componentsSeparatedByString(" ")
        switch titleArray.count {
        case 1:
            return title
        case 2:
            return "\(titleArray[0]) \(titleArray[1])"
        default:
            if titleArray[2] == "and" {
                return "\(titleArray[0]) \(titleArray[1])"
            }else{
                return "\(titleArray[0]) \(titleArray[1]) \(titleArray[2])"
            }
        }
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showRecipeDetail" {
            if let indexPath = self.tbv.indexPathForSelectedRow {
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                let title = recipeList[indexPath.row][Constants.resultsKey.title]
                controller.title = titleGen(title!)
                
                let id = recipeList[indexPath.row][Constants.resultsKey.id]!
                let recipeParse = MashapeJsonParser()
                recipeParse.getData(id)
                
                controller.recipe = recipeParse.recipe
                controller.image = recipeCollection.imgList[id]
                
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    

}
