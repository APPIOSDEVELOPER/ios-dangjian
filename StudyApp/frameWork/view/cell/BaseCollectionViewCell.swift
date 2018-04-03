//
//  BaseCollectionViewCell.swift
//  KuaiJi
//
//  Created by yaojinhai on 2017/6/16.
//  Copyright © 2017年 yaojinhai. All rights reserved.
//

import UIKit
enum CollectionCellType {
    case noCell
    case onlyTitle
    case onlyImage
    case imageAndTitle
}


class BaseCollectionViewCell: UICollectionViewCell {
    var titleLabel: UILabel!
    var imageView: UIImageView!
    var titleButton: UIButton!
    
    var indexPath: IndexPath!
    
    private func setCurrentCellState() -> Void {
        
        if (indexPath.section == 0 && indexPath.row == 0) || indexPath.section == 1{
            titleButton.isHidden = true;
        }else{
            titleButton.isHidden = !isEdit;
        }
    }
    
    var isLongTop = false {
        didSet{
            titleLabel.isHighlighted = isLongTop;
        }
    }
    
    var isEdit = false{
        didSet{
            setCurrentCellState();
        }
    }
    
    
    var contentType = CollectionCellType.noCell {
        didSet{
            configView();
        }
    }
    
    private func configView(){
        switch contentType {
        case .imageAndTitle:
            
            
            
            if titleLabel != nil {
                return;
            }
            
//            backgroundColor = randomColor();
            
            
            titleLabel = createLabel();
            titleLabel.textAlignment = .center;
            imageView = createImageView();
            imageView.contentMode = .scaleAspectFit;
            imageView.snp.makeConstraints({ (maker) in
                maker.width.height.equalTo(self.snp.width).offset(-20);
                maker.top.equalTo(0);
                maker.left.equalTo(10);
            })
            
            titleLabel.snp.makeConstraints({ (maker) in
                maker.left.right.equalTo(0);
                maker.top.equalTo(self.imageView.snp.bottom).offset(6);
            })
            
            
        case .onlyTitle:
            
            if titleLabel == nil {
                titleLabel = createLabel(frame: bounds);
                titleLabel.textAlignment = .center;
                titleLabel.font = fontSize(size: 12);
                titleLabel.textColor = UIColor.gray;
                titleLabel.highlightedTextColor = UIColor.red;
                
                titleButton = createButton(rect: .init(x: width - 20, y: 0, width: 20, height: 20));
                titleButton.setTitle("×", for: .normal);
                titleButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 10, 0);
                titleButton.setTitleColor(UIColor.black, for: .normal);
            }
        case .onlyImage:
            if imageView == nil {
                imageView = createImageView(frame: bounds);
                imageView.contentMode = .scaleAspectFill;
                imageView.clipsToBounds = true;
                imageView.autoresizingMask = [.flexibleWidth,.flexibleHeight];

            }
            
            
        default:
            break;
            
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        backgroundColor = UIColor.clear;
        initView();
    }
    
    func initView(){
    
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    func createButton(rect: CGRect = CGRect.zero) -> UIButton {
        let btn = UIButton(frame: rect);
        btn.backgroundColor = UIColor.clear;
        btn.titleLabel?.font = fontSize(size: 14);
        btn.setTitleColor(UIColor.white, for: .normal);
        addSubview(btn);
        return btn;
    }
    
    
    
    
    func createLabel(frame: CGRect = CGRect.zero) -> UILabel {
        let titleLabel = UILabel(frame: frame);
        addSubview(titleLabel);
        titleLabel.backgroundColor = UIColor.clear;
        titleLabel.font = fontSize(size: 12);
        titleLabel.frame = frame;
        return titleLabel;
        
    }
    
    func createImageView(frame: CGRect = CGRect.zero) -> UIImageView {
        let imageView = UIImageView(frame: frame);
        addSubview(imageView);
        imageView.backgroundColor = UIColor.clear;
        imageView.contentMode = .scaleAspectFill;
        imageView.clipsToBounds = true;
        return imageView;
    }
    
}
