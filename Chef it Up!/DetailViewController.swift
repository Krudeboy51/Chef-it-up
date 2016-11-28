//
//  DetailViewController.swift
//  Chef it Up!
//
//  Created by Kory E King on 11/28/16.
//  Copyright © 2016 Kory E King. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var detailDescriptionLabel: UILabel!

    @IBOutlet weak var warning: UILabel!
    @IBOutlet weak var rImage: UIImageView!
    @IBOutlet weak var rTitle: UILabel!
    @IBOutlet weak var rPrepTime: UILabel!
    @IBOutlet weak var rCookTime: UILabel!
    @IBOutlet weak var rIngredientsTBV: UITableView!
    @IBOutlet weak var rInstructions: UITextView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    var recipe : RecipeModel!
    var image : UIImage!
    
    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail.description
            }
        }
        if recipe != nil{
            hideAll(false)
            rIngredientsTBV.hidden = false
            rInstructions.hidden = true
            segment.selectedSegmentIndex = 0
            
            if image != nil{
                rImage.image = image
            }
            
            rTitle.text = recipe.title
            rCookTime.text = "Cook time: \(recipe.cookmin) mins"
            rPrepTime.text = "Prep time: \(recipe.prepMin) mins"
            rInstructions.text = recipe.instructions
        }else{
            hideAll(true)
        }
    }
    
    func hideAll(isHidden: Bool){
        rIngredientsTBV.hidden = isHidden
        rInstructions.hidden = isHidden
        rImage.hidden = isHidden
        rTitle.hidden = isHidden
        rPrepTime.hidden = isHidden
        rCookTime.hidden = isHidden
        segment.hidden = isHidden
        warning.hidden = !isHidden
    }

    @IBAction func switchViews(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            rIngredientsTBV.hidden = false
            rInstructions.hidden = true
        case 1:
            rIngredientsTBV.hidden = true
            rInstructions.hidden = false
        default:
            rIngredientsTBV.hidden = false
            rInstructions.hidden = true
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipe.ingredients.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ingcell", forIndexPath: indexPath)
        
        cell.textLabel?.text = recipe.ingredients[indexPath.row].info
        
        return cell
    }
    

}

