//
//  KBMainViewController.swift
//  KooB
//
//  Created by Andrea Borghi on 9/25/14.
//  Copyright (c) 2014 Developers Guild. All rights reserved.
//

import Foundation
import UIKit

class KBMainViewController: UIViewController, UISearchBarDelegate {
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet var Blur:UIButton!
    @IBOutlet var SearchBar:UISearchBar!
    @IBOutlet weak var allBooksLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    
    var path: NSIndexPath?
    var categories = [String]?()
    
    override func viewDidLoad() {
        
        SearchBar.delegate = self;
        super.viewDidLoad()
        ScrollView.scrollEnabled = false
        
        //categories = bookListViewController.categories
        let koobLogo = UIImage(named: "Clean Logo Small")
        navigationItem.titleView = UIImageView(image: koobLogo)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if PFUser.currentUser() != nil {
           
        }else{
             performSegueWithIdentifier("LoginScreen", sender: self)
        }
    }
    
    func searchBarTextDidBeginEditing(SearchBar: UISearchBar!){
        SearchBar.placeholder = "Search BookName or @AuthorName"
        Blur.hidden = false
    }
    
    @IBAction func clickedBackground() {
        SearchBar.endEditing(true)
        Blur.hidden = true
        SearchBar.text = ""
        SearchBar.placeholder = "Search for books"
    }
    
    @IBAction func allBooksButtonTapped(sender: AnyObject) {
        self.path = nil
        self.performSegueWithIdentifier("showTappedCategory", sender: self)
    }
    /*
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
                if segue.identifier == "Search" {
                    let vc = segue.destinationViewController as KBSearchResult
                    vc.Search = SearchBar.text
               }
        
    }
*/
    
    override func canPerformUnwindSegueAction(action: Selector, fromViewController: UIViewController, withSender sender: AnyObject) -> Bool {
        return true
    }
    
    func searchBarSearchButtonClicked(SearchBar: UISearchBar) {
        self.performSegueWithIdentifier("Search", sender: self)
        clickedBackground();
    }
}