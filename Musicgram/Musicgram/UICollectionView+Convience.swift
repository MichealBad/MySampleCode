//
//  UICollectionView+Convience.swift
//  Musicgram
//
//  Created by Michealbad on 16/8/31.
//  Copyright © 2016年 Michealbad. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func indexPathsForElementsInRect(rect: CGRect) -> [NSIndexPath] {
        var indexPaths = [NSIndexPath]()
        
        let allAttributes = self.collectionViewLayout.layoutAttributesForElementsInRect(rect)
        for attribute in allAttributes! {
            let indexPath = attribute.indexPath
            indexPaths.append(indexPath)
        }
        
        return indexPaths
    }
    
    
}
