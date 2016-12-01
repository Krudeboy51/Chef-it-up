//
//  CategoriesViewController.swift
//  Chef it Up!
//
//  Created by user119166 on 12/1/16.
//  Copyright © 2016 Kory E King. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController, UITableViewDataSource{

    var categories : [String] = ["Breakfast", "Lunch", "Dinner"]
    
    @IBOutlet weak var tbv: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        return categories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("categoryCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row]
        
        return cell
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "categoryselected" {
            if let indexPath = self.tbv.indexPathForSelectedRow {
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! MenuOptionViewController
                controller.searchitem = categories[indexPath.row]
                
            }        }
    }
    

}
