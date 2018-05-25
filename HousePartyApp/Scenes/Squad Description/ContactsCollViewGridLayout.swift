//
//  ContactsCollViewGridLayout.swift
//  HousePartyApp
//
//  Created by Robert Rozenvasser on 5/25/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import UIKit

struct Device {
    static let height = UIScreen.main.bounds.height
    static let width = UIScreen.main.bounds.width
}

class ContactsCollViewGridLayout: UICollectionViewFlowLayout {
    
    let itemSpacing: CGFloat = 1.0
    let itemsPerRow: CGFloat = 4.6
    
    override init() {
        super.init()
        self.minimumLineSpacing = itemSpacing
        self.minimumInteritemSpacing = itemSpacing
        self.scrollDirection = .horizontal
        self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func itemWidth() -> CGFloat {
        return (Device.width/self.itemsPerRow) - self.itemSpacing
    }
    
    override var itemSize: CGSize {
        get {
            return CGSize(width: itemWidth(), height: itemWidth())
        }
        set {
            self.itemSize = CGSize(width: itemWidth(), height: itemWidth())
        }
    }
    
}
