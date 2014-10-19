//
//  KBTableViewCell.swift
//  KooB
//
//  Created by Andrea Borghi on 9/25/14.
//  Copyright (c) 2014 Developers Guild. All rights reserved.
//

import Foundation

class KBTableViewCell: PFTableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var cover: PFImageView!
    @IBOutlet weak var price: UILabel!
}