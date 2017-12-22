//
//  HorizontalMenu.swift
//  crfintech-test
//
//  Created by MacBookPro on 12/21/17.
//  Copyright © 2017 basicdas. All rights reserved.
//

import Foundation
import UIKit


protocol HorizontalMenuDelegate: class {
    
    /// Media Launched successfully on the cast device
    func menuSelected(bgColor: UIColor)
    
}

class HorizontalMenu: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var menuItems: [String] = []
    var menuCollectionView: UICollectionView!
    let menuCellIdentifier: String = "MenuCollectionViewCell"
    var currentMenu: Int = 0
    weak var delegate: HorizontalMenuDelegate?
    
    init(frame: CGRect, items: [String]) {
        self.menuItems = items
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        
        self.menuCollectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        self.menuCollectionView.delegate = self
        self.menuCollectionView.dataSource = self
        self.menuCollectionView.backgroundColor = UIColor.white
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 0
        self.menuCollectionView.showsHorizontalScrollIndicator = false
        self.menuCollectionView!.isPagingEnabled = false
        self.menuCollectionView!.isScrollEnabled = true
        self.menuCollectionView!.setContentOffset(CGPoint(x: 0,y: 0), animated: true)
        self.addSubview(self.menuCollectionView)
        
        
        
        
        
        let nib = UINib(nibName: menuCellIdentifier, bundle: nil)
        self.menuCollectionView.register(nib, forCellWithReuseIdentifier: menuCellIdentifier)
        
        delegate?.menuSelected(bgColor: UIColor.white)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.menuItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: menuCellIdentifier, for: indexPath) as! MenuCollectionViewCell
        
        cell.menuLabel.text =  String(describing: self.menuItems[indexPath.row])
        
        if indexPath.row == currentMenu {
            cell.setHighlighted(highlighted: true)
        } else {
            cell.setHighlighted(highlighted: false)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let menuString: String = String(describing: self.menuItems[indexPath.row])
        
        let width = menuString.widthForLabel(withConstrainedHeight: 50.0, font: UIFont(name: "Futura", size: 30.0)!)
        
        return CGSize(width: width + 20, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentMenu = indexPath.row
        collectionView.reloadData()
        collectionView.scrollToItem(at: indexPath, at: [.centeredHorizontally, .centeredVertically], animated: true)
        
        var bgColor:UIColor = UIColor.white
        
        switch String(describing: self.menuItems[indexPath.row]) {
        case "White":
            bgColor = UIColor.white
        case "Purple":
            bgColor = UIColor.purple
        case "Red":
            bgColor = UIColor.red
        case "Orange":
            bgColor = UIColor.orange
        case "Magenta":
            bgColor = UIColor.magenta
        case "Cyan":
            bgColor = UIColor.cyan
        case "Brown":
            bgColor = UIColor.brown
        case "Blue":
            bgColor = UIColor.blue
        default:
            bgColor = UIColor.white
        }
        
        delegate?.menuSelected(bgColor: bgColor)
    }
    
}



extension String
{
    func widthForLabel(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat
    {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height);
        
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return boundingBox.width;
    }
}
