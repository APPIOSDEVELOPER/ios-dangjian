//
//  CiecleLayout.swift
//  StudyApp
//
//  Created by yaojinhai on 2018/1/31.
//  Copyright © 2018年 yaojinhai. All rights reserved.
//

import UIKit

class CiecleLayout: UICollectionViewLayout {
    
    var newRect = CGRect.zero;
    var allItemAttbiiute = [UICollectionViewLayoutAttributes]();
    var allCount = 0;
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        let itemLayout = UICollectionViewLayoutAttributes.init(forCellWith: indexPath);
        let angle = 2 * CGFloat.pi * CGFloat(indexPath.item) / CGFloat(allCount);
        
        let radius: CGFloat = 100;
        
        let orighX = (collectionView?.width)! / 2;
        let orighY = (collectionView?.height)! / 2;
        
        itemLayout.center = .init(x: orighX + radius * sin(angle), y: orighY + radius * cos(angle));
        itemLayout.alpha = 1;
        itemLayout.size = .init(width: 40, height: 40);
        
        
        return itemLayout;
        
    }
    override func prepare() {
        super.prepare();
        allItemAttbiiute.removeAll();
        
        guard let count = collectionView?.numberOfItems(inSection: 0) else{
            return;
        }
        allCount = count;
        for idx in 0..<count {
            let indexPath = IndexPath(item: idx, section: 0);
            let attrs = layoutAttributesForItem(at: indexPath);
            allItemAttbiiute.append(attrs!);
        }
        
        
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize.zero;
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        return allItemAttbiiute;
        
    }

//    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//
//
//    }
    

    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        let itemLayout = layoutAttributesForItem(at: itemIndexPath)!
        
        itemLayout.center = .init(x: collectionView!.width / 2, y: collectionView!.height / 2);
        itemLayout.size = .init(width: 20, height: 20);
        itemLayout.alpha = 0.1;
        return itemLayout;
        
    }
    
    
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        if newBounds.equalTo(newRect) {
            return false;
        }
        newRect = newBounds;
        return true;
    }
}
