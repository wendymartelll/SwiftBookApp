//
//  KBBooksListTableViewController.swift
//  KooB
//
//  Created by Andrea Borghi on 9/25/14.
//  Copyright (c) 2014 Developers Guild. All rights reserved.
//

import Foundation

class KBBooksListTableViewController: PFQueryTableViewController {
    var categoryName: String! = "All Books"
    var condition: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        queryForTable()
        title = categoryName
    }
    
    override func queryForTable() -> PFQuery {
        var query = PFQuery(className: "Books_DataBase")
        
        if (categoryName == "All Books") {
            query.whereKeyExists("Subject")
        } else {
            query.whereKey("Subject", equalTo: categoryName)
        }
        
        if (pullToRefreshEnabled) {
            query.cachePolicy = kPFCachePolicyNetworkOnly
        }
        
        if (objects.count == 0) {
            query.cachePolicy = kPFCachePolicyCacheThenNetwork
        }
        
        query.orderByAscending("sportType")
        
        return query
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if (scrollView.contentSize.height - scrollView.contentOffset.y < (view.bounds.size.height)) {
            if (!isLoading) {
                loadNextPage()
            }
        }
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!, object: PFObject!) -> PFTableViewCell! {
        let cellIdentifier: String = "MyCell"
        var cell: KBTableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? KBTableViewCell
        
        
        if (cell == nil) {
            tableView.registerNib(UINib(nibName: "KBTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
            cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as KBTableViewCell
        }
        
        if (tableView == tableView) {
            cell.cover.image = UIImage(named: "BookLoad")
            cell.cover.file = object["image"] as PFFile
            
            cell.cover.loadInBackground()
            
            cell.name.text = object.objectForKey("BookName") as? String
            cell.price.text = object.objectForKey("Price") as? String
        }
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("CatagDetail", sender: indexPath)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "CatagDetail") {
            let destViewController: KBBooksDetailsViewController = segue.destinationViewController as KBBooksDetailsViewController
            
            var object: PFObject
            
            let indexPath = tableView.indexPathForSelectedRow()
            
            object = objects[indexPath!.row] as PFObject
            destViewController.copyob = object
        }
    }
    
    func setCategory(selectedCategory: String) {
        if (categoryName == "") {
            categoryName = selectedCategory
        }
    }
}