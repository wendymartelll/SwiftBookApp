//
//  KBBookCollectionViewController.swift
//  KooB
//
//  Created by Andrea Borghi on 9/25/14.
//  Copyright (c) 2014 Developers Guild. All rights reserved.
//

import Foundation

class KBBookCollectionViewController: UICollectionViewController {
    let allCategories = KBBooksListViewController.allCategories()
    var originalFrame: CGRect?
    var originalContentOffset: CGPoint?
    let iPhoneStatusBarSize = 20
    let reuseIdentifier = "CollectionCell"
    
    override func viewDidLoad() {
        NSLog("%d", allCategories.count)
        collectionView?.backgroundColor = nil
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
        originalFrame = collectionView?.frame
        originalContentOffset = CGPointMake(collectionView!.contentOffset.x, collectionView!.contentOffset.y)
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        NSLog("%d", allCategories.count)
        //return 20
        return allCategories.count
        
    }
    /*
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> KBCollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as KBCollectionViewCell
        cell.contentView.backgroundColor = UIColor.grayColor()
        cell.CollectionSubjectLabel.text = allCategories[indexPath.item]
        return cell
    }
    */
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> KBCollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionCell", forIndexPath: indexPath) as KBCollectionViewCell
        
        // Configure the cell
        
        cell.CollectionSubjectLabel?.text = allCategories[indexPath.item]
        //cell.CollectionSubjectLabel?.textColor = UIColor.blackColor()
        //NSLog("%@",Subjects[indexPath.row])
        //cell.backgroundColor = UIColor.blueColor()
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
       
        let parent = parentViewController as KBMainViewController
        parent.path = indexPath
        parent.performSegueWithIdentifier("showTappedCategory", sender: self)
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        collectionView?.bounces = true
        var scrollPoint = CGPointMake(0, collectionView!.contentOffset.y)
        let parent = parentViewController as KBMainViewController
        
        if (collectionView!.contentOffset.y > 0 && collectionView!.contentOffset.y < originalFrame!.size.height / 3){
            collectionView?.bounces = false
            var tableFrame = collectionView!.frame
            tableFrame.size.height = originalFrame!.size.height / 3 + scrollPoint.y
            collectionView!.frame = tableFrame
            parent.ScrollView.setContentOffset(scrollPoint, animated: false)
        } else if (collectionView!.contentOffset.y == 0){
            parent.ScrollView.setContentOffset(CGPointMake(0, CGFloat(-iPhoneStatusBarSize) - navigationController!.navigationBar.frame.size.height), animated: true)
        } else if (collectionView!.contentOffset.y >= originalFrame!.size.height / 3) {
            collectionView?.bounces = false;
            var tableFrame = collectionView!.frame
            tableFrame.size.height = parent.view.frame.size.height
            collectionView?.frame = tableFrame
            parent.ScrollView.setContentOffset(CGPointMake(0, parent.allBooksLabel.center.y - (parent.categoriesLabel.frame.size.height * 3)), animated: true)
        }
    }
    
}