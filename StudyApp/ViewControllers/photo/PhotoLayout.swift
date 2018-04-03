//
//  PhotoLayout.swift
//  StudyApp
//
//  Created by yaojinhai on 2018/2/22.
//  Copyright © 2018年 yaojinhai. All rights reserved.
//

import UIKit

protocol PhotoLayoutDelegate {
    func column(index: Int,height row:Int) -> CGFloat;
}

class PhotoLayout: UICollectionViewLayout {
    
    var newRect = CGRect.zero;
    var allItemAttbiiute = [UICollectionViewLayoutAttributes]();
    var maxHeight: CGFloat = 10;
    var width: CGFloat = 0;
    var maxHeightDict = [Int:CGFloat]();
    var sectionInset = UIEdgeInsets.zero;
    var minLineGap: CGFloat = 10;
    var column: CGFloat = 3;
    var delegate: PhotoLayoutDelegate!
    
    override init() {
        super.init();
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
//    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        
//        
//        let itemLayout = UICollectionViewLayoutAttributes(forCellWith: itemIndexPath);
//        
//        let clum = itemIndexPath.item % 3;
//        
//        var rect = CGRect.zero;
//        
//        
//        let ht = delegate.column(index: clum, height: itemIndexPath.item / 3)
//        
//        rect.size = .init(width: width, height: ht);
//        
//        let px = CGFloat(clum) * (width + minLineGap) + sectionInset.left;
//        rect.origin.x = px;
//        let pyy = maxHeightDict[clum] ?? 0;
//        
//        rect.origin.y =  pyy;
//        
//        itemLayout.center = .init(x: rect.midX, y: rect.midY);
//        itemLayout.size = .init(width: rect.width * 0.1, height: rect.height * 0.1);
//
//        itemLayout.alpha = 0;
//        
//        return itemLayout;
//        
//        
//    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        let itemLayout = UICollectionViewLayoutAttributes.init(forCellWith: indexPath);
        
        let clum = indexPath.item % 3;
        
        var rect = CGRect.zero;
        
        
        let ht = delegate.column(index: clum, height: indexPath.item / 3)
        
        rect.size = .init(width: width, height: ht);

        let px = CGFloat(clum) * (width + minLineGap) + sectionInset.left;
        rect.origin.x = px;
        let pyy = maxHeightDict[clum] ?? 0;
        
        rect.origin.y =  pyy;
        
        itemLayout.frame = rect;
        maxHeightDict[clum] = rect.maxY + minLineGap;

        maxHeight = max(rect.maxY + minLineGap, maxHeight);

        return itemLayout;
        
    }
    
    func initLayout() -> Void {
        allItemAttbiiute.removeAll();
        maxHeightDict.removeAll();
        maxHeight = 0;
        
        for idx in 0..<Int(column) {
            maxHeightDict[idx] = sectionInset.top;
        }
        guard let count = collectionView?.numberOfItems(inSection: 0) else{
            return;
        }
        width = (sWidth - sectionInset.left - sectionInset.right - (column - 1) * minLineGap) / column;
        
        
        for idx in 0..<count {
            let indexPath = IndexPath(item: idx, section: 0);
            let attrs = layoutAttributesForItem(at: indexPath);
            allItemAttbiiute.append(attrs!);
        }
    }
    
    override func prepare() {
        super.prepare();
        
        initLayout();
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize.init(width: 0, height: maxHeight);
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return allItemAttbiiute;
    }
    
    override func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
        
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        if newBounds.equalTo(newRect) {
            return false;
        }
        newRect = newBounds;
        return true;
    }
}













