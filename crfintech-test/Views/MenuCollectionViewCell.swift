//
//  MenuCollectionViewCell.swift
//  crfintech-test
//
//  Created by MacBookPro on 12/21/17.
//  Copyright © 2017 basicdas. All rights reserved.
//

import UIKit

class MenuCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var menuLabel: UILabel!
    @IBOutlet weak var highlightView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func setHighlighted(highlighted: Bool) {
        if highlighted {
            self.highlightView.isHidden = false
        } else {
            self.highlightView.isHidden = true
        }
    }

}
