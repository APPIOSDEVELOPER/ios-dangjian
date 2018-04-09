//
//  PicViewController.swift
//  StudyApp
//
//  Created by yaojinhai on 2018/2/22.
//  Copyright © 2018年 yaojinhai. All rights reserved.
//

import UIKit

class PicViewController:  SuperBaseViewController,UICollectionViewDataSource,PhotoLayoutDelegate,UICollectionViewDelegateFlowLayout{
    
    
    var model: ActivityModel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
  
        let layout = PhotoLayout();
        layout.sectionInset = UIEdge(size: 10);
//        layout.minLineGap = 4;
        layout.delegate = self;
        createCollection(frame: navigateRect, layout: layout, delegate: self);
        
        baseCollectionView.register(BaseCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "imageCell");
        baseCollectionView.register(PhotoLabelHeaderView.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header");
        
        title = model.activityName;
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
        return model?.imgAarray?.count ?? 0;
    }
    

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! BaseCollectionViewCell;
        cell.contentType = .onlyImage;
        cell.clipsToBounds = true;
        let photo = model.imgAarray[indexPath.row];
        cell.imageView.sd_setImage(withURLString: photo.url);
        return cell;
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        
        let ctrl = ScalePicViewController();
        ctrl.dataSource = model.imgAarray;
        ctrl.currentIndex = indexPath.row;
        navigateCtrl.pushViewController(ctrl, animated: true);
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
