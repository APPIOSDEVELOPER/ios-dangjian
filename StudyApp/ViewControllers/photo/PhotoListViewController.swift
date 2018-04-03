//
//  PhotoListViewController.swift
//  StudyApp
//
//  Created by yaojinhai on 2018/2/22.
//  Copyright © 2018年 yaojinhai. All rights reserved.
//

import UIKit

class PhotoListViewController: SuperBaseViewController,UICollectionViewDelegate,UICollectionViewDataSource{

    var currentIndex = 0;
    var dataSource: [PhotoModel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = UICollectionViewFlowLayout();
        let wd = (width() - 41) / 3;
        layout.itemSize = .init(width: wd, height: wd);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        layout.sectionInset = UIEdge(size: 10);
        layout.headerReferenceSize = .init(width: width(), height: 25);
        createCollection(frame: navigateRect, layout: layout, delegate: self);
        baseCollectionView.register(BaseCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "imageCell");
        baseCollectionView.register(PhotoLabelHeaderView.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header");
        
        baseCollectionView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            self.currentIndex += 1;
            self.loadDataFromNet(net: true);
        });
        baseCollectionView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.currentIndex = 1;
            self.loadDataFromNet(net: true);
        });
        
    }
    
    override func loadDataFromNet(net: Bool) {
        
        let request = UserRequest(branchPhotoWall: currentIndex);
        request.loadJsonStringFinished { (result, success) in
            
            self.baseCollectionView.mj_header?.endRefreshing();
            self.baseCollectionView.mj_footer?.endRefreshing();
            
            guard let dict = result as? NSDictionary,
            let list = dict["result"] as? NSArray else{
                return;
            }
            self.dataSource = [PhotoModel]();
            for item in list {
                let model = PhotoModel(anyData: item);
                self.dataSource.append(model);
            }
            self.baseCollectionView.reloadData();
        };
    }
    
    @objc override func buttonAction(btn: UIButton) {
        if let header = btn.superview as? PhotoLabelHeaderView {
            header.tag = 0;
            enterDetial();
        }
    }
    
    // MARK:- collection view delegate
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return self.dataSource?.count ?? 0;
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header", for: indexPath) as! PhotoLabelHeaderView;
        header.initView();
        header.textLabel.text = "2月11\t两学一做专题活动";
        header.textLabel.textColor = UIColor.darkGray;
        header.moreButton.addTarget(self, action: #selector(buttonAction(btn:)), for: .touchUpInside);
        return header;
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! BaseCollectionViewCell;
        cell.contentType = .onlyImage;
        let model = dataSource[indexPath.row];
        cell.imageView.sd_setImage(withURLString: model.url);
        
        return cell;
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        enterDetial();
        
    }
    
    func enterDetial() -> Void {
        let ctrl = PicViewController();
        ctrl.title = "两学一做专题活动"
        navigateCtrl.pushViewController(ctrl, animated: true);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    
    
    
}

class PhotoLabelHeaderView: UICollectionReusableView {
    
    var textLabel: UILabel!
    var moreButton: UIButton!
    
    func initView() -> Void {
        if textLabel != nil {
            return;
        }
        backgroundColor = rgbColor(rgb: 244);
        textLabel = UILabel();
        addSubview(textLabel);
        textLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(10);
            maker.height.equalTo(self.snp.height);
            maker.top.equalTo(0);
        }
        
        moreButton = UIButton();
        moreButton.titleLabel?.font = fontSize(size: 14);
        moreButton.setTitle("更多>>", for: .normal);
        moreButton.setTitleColor(UIColor.darkGray, for: .normal);
        addSubview(moreButton);
        moreButton.snp.makeConstraints { (maker) in
            maker.right.equalTo(self.snp.right).offset(-10);
            maker.height.equalTo(self.snp.height);
            maker.width.equalTo(80);
        }
    }
    
}

class PhotoModel: BaseModel {
    @objc var title = "";
    @objc var url = "";
}
