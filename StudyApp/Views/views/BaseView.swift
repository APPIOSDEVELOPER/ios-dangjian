//
//  BaseView.swift
//  PhoneApp
//
//  Created by yaojinhai on 2017/8/15.
//  Copyright © 2017年 yaojinhai. All rights reserved.
//

import UIKit


class BaseView: UIView {
    
    
    
    var titleLabel: UILabel!
    var contentLabel: UILabel!
    
    var baseImageView: UIImageView!
    var subImageView: UIImageView!

    var titleButton: UIButton!
    
    var lineView: UIView!
    
    var contentInsert = UIEdgeInsets.zero;
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        initView();
    }
    
//    @available(iOS 11.0, *)
    func addDrag() -> Void {
//        let dragItem = UIDragInteraction(delegate: self);
//        addInteraction(dragItem);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() -> Void {
        
    }

    func createLabel(rect: CGRect,text: String = "") -> UILabel {
        let label = UILabel(frame: rect);
        label.text = text;
        addSubview(label);
        label.textColor = UIColor.gray;
        label.backgroundColor = UIColor.clear;
        label.font = fontSize(size: 12);
        label.numberOfLines = 0;
        return label;
    }
    
    func createView(rect: CGRect = CGRect.zero) -> UIView {
        let view = UIView(frame: rect);
        addSubview(view);
        return view;
    }
    
    func createImageView(rect: CGRect) -> UIImageView {
        let iView = UIImageView(frame: rect);
        addSubview(iView);
        iView.backgroundColor = UIColor.clear;
        iView.contentMode = .scaleAspectFit;
        iView.clipsToBounds = true;
        return iView;
    }
    
    func createButton(rect: CGRect,title: String = "") -> UIButton {
        let btn = UIButton(frame: rect);
        btn.setTitle(title, for: .normal);
        addSubview(btn);
        btn.titleLabel?.font = fontSize(size: 14);
        btn.backgroundColor = UIColor.clear;
        btn.setTitleColor(UIColor.white, for: .normal);
        return btn;
    }
    
    func addTapGeture(target: Any,seletor: Selector,view: UIView?) -> Void {
        let tempView = view ?? self;
        let tap = UITapGestureRecognizer(target: target, action: seletor);
        tempView.addGestureRecognizer(tap);
    }
}
