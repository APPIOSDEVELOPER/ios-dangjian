//
//  ShareViewController.swift
//  StudyApp
//
//  Created by yaojinhai on 2018/1/25.
//  Copyright © 2018年 yaojinhai. All rights reserved.
//

import UIKit

class ShareViewController: PopBaseViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    var cancelbutn: UIButton!
    
    var titles = ["微信","朋友圈","QQ","QQ空间"];
    
    var shareMsg: ShareMessage!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = UICollectionViewFlowLayout();
        layout.itemSize = CGSize.init(width: 60, height: 90);
        layout.minimumLineSpacing = 0;
        let spacing = (width() - 241)/5;
        
        layout.minimumInteritemSpacing = spacing;
        layout.sectionInset = UIEdgeInsetsMake(54, spacing, 40, spacing);
        
        createCollection(frame: .init(x: 0, y: height() - 200, width: width(), height: 200), layout: layout, delegate: self);
        baseCollectionView.register(BaseCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "baseCell");
        baseCollectionView.isScrollEnabled = false;
        baseCollectionView.backgroundColor = UIColor.white;
        
        view.backgroundColor = rgbColor(rgb: 0).withAlphaComponent(0.5);
        
        cancelbutn = UIButton(frame: .init(x: 0, y: 200 - 40, width: sWidth, height: 40));
        baseCollectionView.addSubview(cancelbutn);
        cancelbutn.backgroundColor = rgbColor(rgb: 246);
        cancelbutn.setTitleColor(UIColor.lightGray, for: .normal);
        cancelbutn.titleLabel?.font = fontSize(size: 14);
        cancelbutn.addTarget(self, action: #selector(buttonAction(btn:)), for: .touchUpInside);
        cancelbutn.setTitle("取消", for: .normal);
      
    }
    @objc override func buttonAction(btn: UIButton) {
        self.dismiss(animated: true) {
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true) {
            
        }
    }
    
    // MARK:- collection view delegate
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return titles.count;
    }
    

    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "baseCell", for: indexPath) as! BaseCollectionViewCell;
        cell.contentType = .imageAndTitle;
        cell.imageView.image = UIImage(named:"share_icon_\(indexPath.row)");
        cell.titleLabel.text = titles[indexPath.row];
        return cell;
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
//        let type = indexPath.row;
        
        var type = SSDKPlatformType.subTypeWechatSession;
        
        switch indexPath.row {
        case 0:
            type = .typeWechat;
        case 2:
            type = .subTypeQQFriend;
        case 1:
            type = .subTypeWechatTimeline;
        case 3:
            type = .subTypeQZone;
        default:
            break;
            
        }
        if shareMsg != nil {
            shareMsg.shareType = type;
            ShareSDKManager.shareToMeida(shareMsg, finished: { (finished, error) in
                
            });
            
        }else{
            
            let message = ShareMessage.createMessage("主题", content: "内容");
            message.shareType = type;
            ShareSDKManager.shareToMeida(message) { (success, error) in
                
            };
        }
        
        
        
        
    }

}







