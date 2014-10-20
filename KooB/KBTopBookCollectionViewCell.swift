//
//  KBTopBookCollectionViewCell.swift
//  KooB
//
//  Created by Andrea Borghi on 9/25/14.
//  Copyright (c) 2014 Developers Guild. All rights reserved.
//

import Foundation
import UIKit

class KBTopBookCollectionViewCell: UICollectionViewCell {
    var imageView: UIImageView
    var image: UIImage?
    var loading: Bool = false
    
    override init(frame: CGRect) {
        imageView = UIImageView()
        imageView.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        super.init(frame: frame)
        contentView.addSubview(imageView)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCover(forBook: KoobBook?) {
        if let book = forBook {
            loading = true
            KBTopBookCellViewController.imageForBook(book: book, completionBlock: { (image) -> () in
                self.imageView.image = image
                self.setNeedsLayout()
                self.loading = false
            })
        } else {
            imageView.image = UIImage(named: "BookLoad")
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
    }
    
    func coverIsLoaded() -> Bool {
        if loading {
            return true
        } else {
            return false
        }
    }
}