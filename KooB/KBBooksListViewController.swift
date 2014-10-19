//
//  KBBooksListViewController.swift
//  KooB
//
//  Created by Andrea Borghi on 9/25/14.
//  Copyright (c) 2014 Developers Guild. All rights reserved.
//

import Foundation

class KBBooksListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let BooksListTableViewController = KBBooksListTableViewController()
    let categories = KBBooksListViewController.allCategories()
    
    class func allCategories() -> [String] {
        return ["Accounting","Administration of Justice","Anthropology","Arts","Astronomy","Automotive Technology","Biology","Business","Cantonese","Career Life Planning","Chemistry","Child Development","Computer Aided Design","Computer Information System","Counseling","Dance","Economics","Education","Engeineering","ESL","English","Enviromental Science","Film and Television","French","Geography","Geology","German","Guidance","Health Technology","Health","Hindi","History","Human Development","Humanities","Intercultural Studies","International Studies","Italian","Japanese","Journalism","Korean","Language Arts","Learning Assistance","Librarty","Linguistics","Mandarin","Manufacturing","Mathematics","Meterology","Music","Nursing","Nutrition","Paralegal","Persian","Philosophy","Photography","Physical Education","Physics","Political Science","Pyschology","Reading","Real Estate","Russian","Sign Language","Skills","Social Science","Sociology","Spanish","Speech","Theater Arts","Vietnamese","Women Studies","Misc"]
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if PFUser.currentUser() == nil {
            performSegueWithIdentifier("LoginScreen", sender: self)
        } else {
            let indexPath = tableView.indexPathForSelectedRow()
            if indexPath != nil {
                tableView.deselectRowAtIndexPath(indexPath!, animated: true)
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //self.navigationController!.navigationBarHidden = true
        
        if let indexPath = tableView.indexPathForSelectedRow() {
            tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: UITableViewScrollPosition.None)
            //self.tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .None)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: NSInteger) -> NSInteger {
        return self.categories.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let categoryCell: String = "categoryCell"
        
        var cell: UITableViewCell! = self.tableView.dequeueReusableCellWithIdentifier(categoryCell) as UITableViewCell
        
        if (cell != nil) {
            cell = UITableViewCell(style: .Default, reuseIdentifier: categoryCell)
        }
        
        cell.textLabel!.text = self.categories[indexPath.row]
        
        return cell!
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "Catag") {
            
            let indexPath: NSIndexPath = self.tableView.indexPathForSelectedRow()!
            
            println(indexPath)
            
            (segue.destinationViewController as KBBooksListTableViewController).setCategory(self.categories[indexPath.row])
            
        } else if (segue.identifier == "openMap") {
            (segue.destinationViewController as KBMapViewController).openWithNoAnnotation()
        }
    }
}