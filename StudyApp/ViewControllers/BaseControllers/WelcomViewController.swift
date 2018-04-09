//
//  WelcomViewController.swift
//  StudyApp
//
//  Created by yaojinhai on 2017/10/19.
//  Copyright © 2017年 yaojinhai. All rights reserved.
//

import UIKit

class WelcomViewController: YyBaseViewController ,UICollectionViewDelegate,UICollectionViewDataSource{
    
    var pageCtrl: UIPageControl!
    
    var didExeFinished: (() -> Void)!
    
    var preIndex = -1;

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize.init(width: width(), height: height());
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = .horizontal;
        createCollection(frame: bounds(), layout: layout, delegate: self);
        view.backgroundColor = UIColor.black;
        baseCollectionView.register(BaseCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "cell");
        baseCollectionView.isPagingEnabled = true;
        
        pageCtrl = UIPageControl(frame: .init(x: 0, y: height() - 80, width: width(), height: 20));
        pageCtrl.currentPage = 0;
        pageCtrl.numberOfPages = 4;
        pageCtrl.currentPageIndicatorTintColor = rgbColor(r: 27, g: 131, b: 241);
        pageCtrl.pageIndicatorTintColor =  rgbColor(rgb: 229);//27 131 241
        addView(tempView: pageCtrl);
        pageCtrl.addTarget(self, action: #selector(pageAction(_:)), for: .valueChanged);

    
        
    
    }
    
    @objc func pageAction(_ page: UIPageControl) -> Void {
        if preIndex != page.currentPage {
            baseCollectionView.scrollToItem(at: .init(row: page.currentPage, section: 0), at: .centeredHorizontally, animated: true);
        }
    }
    @objc func buttonAction(_ btn: UIButton) -> Void {
        self.dismiss(animated: true) {
            
        }
        didExeFinished?();
        
    }
    
    // MARK:- collection view delegate
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 4;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
//        currentStateIndex = .black;
//        setHiddenNavigateBarAndState(hidden: true);
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! BaseCollectionViewCell;
        let image = UIImage(named: "guaid_\(indexPath.row + 1)")!;
//        let size = CGSize.convertIphone5Size(cSize: image.size, scale: 0.8);
        cell.contentType = .onlyImage;
        cell.imageView.contentMode = .scaleAspectFill;
//        cell.imageView.frame = CGRect.init(x: (sWidth - size.width) / 2, y: 95, width: size.width, height: size.height);
        cell.imageView.image = image;
        
        return cell;
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let px = scrollView.contentOffset.x + scrollView.width / 2;
        guard let indexPath = baseCollectionView.indexPathForItem(at: .init(x: px, y: height()/2)) else {
            return;
        }
        if preIndex != indexPath.row {
            preIndex = indexPath.row;
            pageCtrl.currentPage = indexPath.row;
        }
        pageCtrl.isHidden = indexPath.row == 3;
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        if indexPath.row == 3 {
            didExeFinished();
        }
        
    }

    

}
