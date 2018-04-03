//
//  PicViewController.swift
//  StudyApp
//
//  Created by yaojinhai on 2018/2/22.
//  Copyright © 2018年 yaojinhai. All rights reserved.
//

import UIKit

class PicViewController:  SuperBaseViewController,UICollectionViewDataSource,PhotoLayoutDelegate,UICollectionViewDelegateFlowLayout{
    
    
    var dataSourceItems = [String]();
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for idx in 0..<20 {
            dataSourceItems.append("\(idx)");
        }
        
        let layout = PhotoLayout();
        layout.sectionInset = UIEdge(size: 10);
//        layout.minLineGap = 4;
        layout.delegate = self;
        createCollection(frame: navigateRect, layout: layout, delegate: self);
        
        baseCollectionView.register(BaseCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "imageCell");
        baseCollectionView.register(PhotoLabelHeaderView.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header");
        
    }
    
    func column(index: Int, height row: Int) -> CGFloat {
        var ht: CGFloat = 160;
        
        if index == 0 && row == 0 {
            ht = 80;
        }else if index == 1 && row == 0 {
            ht = 140;
        }else if index == 2 && row == 0 {
            ht = 200;
        }
        return ht;
    }

    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
//        counts = 10;
//        var indexPaths = [IndexPath]();
//
//        for idx in 0..<counts {
//            indexPaths.append(.init(item: idx, section: 0));
//        }
//
//        baseCollectionView.performBatchUpdates({
//            baseCollectionView.insertItems(at: indexPaths);
//        }) { (finihsed) in
//
//        }
        
    }

    
    @objc override func buttonAction(btn: UIButton) {
        
    }
    
    
    
    
    // MARK:- collection view delegate
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return dataSourceItems.count;
    }
    

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! BaseCollectionViewCell;
        cell.contentType = .onlyImage;
        cell.clipsToBounds = true;
        let idx = indexPath.row % 9 + 1;
        
        cell.imageView.image = UIImage(named:"\(idx)");
        return cell;
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        var ds = [String]();
        for idx in 1...dataSourceItems.count {
            ds.append("\(idx)")
        }
        
        
        let ctrl = ScalePicViewController();
        ctrl.dataSource = ds;
        ctrl.currentIndex = indexPath.row;
        navigateCtrl.pushViewController(ctrl, animated: true);
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
