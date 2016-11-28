//
//  MasterViewController.swift
//  Chef it Up!
//
//  Created by Kory E King on 11/28/16.
//  Copyright © 2016 Kory E King. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [AnyObject]()
    var recipeCollection = RecipeCollection()
    var recipeList = [Dictionary<String, String>]()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        /*
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(insertNewObject(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        */
        
        recipeCollection.getRandom(){
            (recipes) in
            self.recipeList = recipes
            self.tableView.reloadData()
        }
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    func insertNewObject(sender: AnyObject) {
        objects.insert(NSDate(), atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
 */
    
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

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
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

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeList.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
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
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }



}

