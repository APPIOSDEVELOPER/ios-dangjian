//
//  ScalePicViewController.swift
//  StudyApp
//
//  Created by yaojinhai on 2018/2/23.
//  Copyright © 2018年 yaojinhai. All rights reserved.
//

import UIKit

class ScalePicViewController: SuperBaseViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    var dataSource: [PhotoModel]!
    var currentIndex = 0;
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = UICollectionViewFlowLayout();
        layout.itemSize = .init(width: width(), height: height());
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = .horizontal;
        createCollection(frame: bounds(), layout: layout, delegate: self);
        baseCollectionView.isPagingEnabled = true;
        baseCollectionView.register(ScalePicCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "baseCell")

        
        addTarget(target: self, selector: #selector(gestureTap), subView: baseCollectionView, delegate: nil);
        
        
        
    }
    
    
    @objc func gestureTap() -> Void {
        let show = navigateCtrl.navigationBar.frame.origin.y == 20;
        showNavigateBar(show: !show);
    }
    
    @objc func showNavigateBar(show: Bool) -> Void {
        
        UIView.animate(withDuration: 0.5) {
            if show {
                navigateCtrl.navigationBar.frame.origin.y = 20;
            }else{
                navigateCtrl.navigationBar.frame.origin.y = -navigateCtrl.navigationBar.height - 20;
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        baseCollectionView.scrollToItem(at: IndexPath.init(row: currentIndex, section: 0), at: .centeredHorizontally, animated: false);

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        perform(#selector(showNavigateBar(show:)), with: false, afterDelay: 2)
        
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        NSObject.cancelPreviousPerformRequests(withTarget: self);
        self.showNavigateBar(show: true);

    }

    // MARK:- collection view delegate
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return dataSource?.count ?? 0;
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "baseCell", for: indexPath) as! ScalePicCollectionViewCell;
        cell.resetScale();
        let model = dataSource[indexPath.row];
        cell.imageView.sd_setImage(withURLString: model.url);
        return cell;
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
    }
}

class ScalePicCollectionViewCell: BaseCollectionViewCell ,UIScrollViewDelegate{
    private var phoneScroll: UIScrollView!
    
    override func initView() {
        
        backgroundColor = UIColor.black;
        
        imageView = UIImageView(frame: bounds);
        imageView.contentMode = .scaleAspectFit;
        imageView.backgroundColor = UIColor.clear;
        imageView.autoresizingMask = [.flexibleWidth,.flexibleHeight];
        
        phoneScroll = UIScrollView(frame: bounds);
        addSubview(phoneScroll);
        phoneScroll.backgroundColor = UIColor.clear;
        phoneScroll.autoresizingMask = [.flexibleWidth,.flexibleHeight];
        phoneScroll.delegate = self;
        phoneScroll.showsVerticalScrollIndicator = false;
        phoneScroll.showsHorizontalScrollIndicator = false;
        phoneScroll.maximumZoomScale = 5;
        phoneScroll.minimumZoomScale = 1;
        
        phoneScroll.addSubview(imageView);
    }
    
    func resetScale() -> Void {
        phoneScroll.zoomScale = 1;
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView;
    }
    
}
