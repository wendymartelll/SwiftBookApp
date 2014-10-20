//
//  KBTopBooksCollectionViewController.swift
//  KooB
//
//  Created by Andrea Borghi on 9/25/14.
//  Copyright (c) 2014 Developers Guild. All rights reserved.
//

import Foundation
import UIKit

class KBTopBooksCollectionViewController: UICollectionViewController {
    @IBOutlet var collView: UICollectionView!
    var originatingPoint: CGPoint?
    var topBooks = [KoobBook]?()
    var computer = KBTopBooksComputer?()
    let reuseIdentifier = "Cell"
    //let categories = ["Accounting","Administration of Justice","Anthropology","Arts","Astronomy","Automotive Technology","Biology","Business","Cantonese","Career Life Planning","Chemistry","Child Development","Computer Aided Design","Computer Information System","Counseling","Dance","Economics","Education","Engeineering","ESL","English","Enviromental Science","Film and Television","French","Geography","Geology","German","Guidance","Health Technology","Health","Hindi","History","Human Development","Humanities","Intercultural Studies","International Studies","Italian","Japanese","Journalism","Korean","Language Arts","Learning Assistance","Librarty","Linguistics","Mandarin","Manufacturing","Mathematics","Meterology","Music","Nursing","Nutrition","Paralegal","Persian","Philosophy","Photography","Physical Education","Physics","Political Science","Pyschology","Reading","Real Estate","Russian","Sign Language","Skills","Social Science","Sociology","Spanish","Speech","Theater Arts","Vietnamese","Women Studies","Misc"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collView.delegate = self
        collView.backgroundColor = nil
        collView.showsHorizontalScrollIndicator = false
        collView.showsVerticalScrollIndicator = false
        collView.registerClass(KBTopBookCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        animateTopBooksEntrance()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if PFUser.currentUser() != nil {
            if computer == nil {
                computer = KBTopBooksComputer(categories: KBBooksListViewController.allCategories())
            }
            computer!.getTopBooksAsync({ (topBooks) -> () in
                self.topBooks = topBooks
            })
        } else {
            println("No user")
        }
    }
    
    func animateTopBooksEntrance() {
        collectionView.reloadData()
        UIView.animateWithDuration(1.5, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: nil, animations: { () -> Void in
            self.collView.contentOffset = CGPointMake(self.collView!.frame.size.width, 0)
            }, completion: nil)
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // To be changed
        return 15
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("ShowDetail", sender: indexPath)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail" {
            let destinationViewController = segue.destinationViewController as KBBooksDetailsViewController
            let indexPath = sender as NSIndexPath
            let object = topBooks![indexPath.row]
        }
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as KBTopBookCollectionViewCell
        
        if topBooks?.count != 0 && indexPath.row < topBooks?.count {
            cell.setCover(topBooks![indexPath.row] as KoobBook)
        } else {
            cell.setCover(nil)
        }
        
        return cell
    }
}
