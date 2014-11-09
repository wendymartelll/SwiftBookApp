//
//  KBTopBooksCollectionViewController.swift
//  KooB
//
//  Created by Andrea Borghi on 9/25/14.
//  Copyright (c) 2014 Developers Guild. All rights reserved.
//

import Foundation
import UIKit

extension Array {
    func contains<T where T : Equatable>(obj: T) -> Bool {
        return self.filter({$0 as? T == obj}).count > 0
    }
}

class KBTopBooksCollectionViewController: UICollectionViewController {
    @IBOutlet var collView: UICollectionView!
    var originatingPoint: CGPoint?
    var topBooks = [KoobBook]?()
    var computer = KBTopBooksComputer?()
    let reuseIdentifier = "CollectionCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collView.delegate = self
        collView.backgroundColor = nil
        collView.showsHorizontalScrollIndicator = false
        collView.showsVerticalScrollIndicator = false
        collView.registerClass(KBTopBookCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reload", name:BookCoverDownloaded, object: nil)
        
        if PFUser.currentUser() != nil {
            if computer == nil {
                computer = KBTopBooksComputer(categories: KBBooksListViewController.allCategories())
            }
            computer!.getTopBooksAsync({ (topBooks: [KoobBook]) -> Void in
                self.topBooks = topBooks
                println("The array contains \(self.topBooks?.count)")
            })
        } else {
            println("No user")
        }
        
        animateTopBooksEntrance()
    }
    
    func reload() {
        println("Reload called")
        var differenceArray = computer!.topBooks
        
        for book in differenceArray {
            if topBooks!.contains(book) == false {
                topBooks = differenceArray
                
                for cell in collectionView.visibleCells() {
                    let topCell = cell as KBTopBookCollectionViewCell
                    if topCell.loaded == false {
                        let indexPath = collectionView.indexPathForCell(topCell)
                        collectionView.reloadItemsAtIndexPaths(NSArray(object: indexPath!))
                    }
                }
            }
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
            let selectedBook = topBooks![indexPath.row]
            
            destinationViewController.book = selectedBook
            destinationViewController.title = selectedBook.bookTitle
            
            // Prepare for the custom segue
            self.collectionView.cellForItemAtIndexPath(indexPath)?.center
            let selectedCellCenter: CGPoint = self.collectionView.cellForItemAtIndexPath(indexPath)!.center
            let cellCenterInSuperview: CGPoint = self.parentViewController!.view.convertPoint(selectedCellCenter, fromView: self.collectionView)
            (segue as KBPresentDetailsViewSegue).originatingPoint = cellCenterInSuperview
            self.originatingPoint = cellCenterInSuperview;
            
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
    
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        if (indexPath.row < self.topBooks?.count) {
            return true
        } else {
            return false
        }
    }
}
