//
//  BaseTableViewCell.swift
//  StudyApp
//
//  Created by yaojinhai on 2017/11/28.
//  Copyright © 2017年 yaojinhai. All rights reserved.
//

import UIKit




class BaseTableViewCell: UITableViewCell {
    
    var rightText: UILabel!
    
    var leftImage: UIImageView!
    var rightImage: UIImageView!
    
    var titleLabel: UILabel!
    var subTitleLabel: UILabel!
    
    var baseView: UIView!
    
    

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        
        initView();
        selectionStyle = .none;
        backgroundColor = .clear;
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() -> Void {
        
    }
    
    func createButton(rect: CGRect = CGRect.zero) -> UIButton {
        let btn = UIButton(frame: rect);
        addSubview(btn);
        return btn;
        
    }
    

    func createImageView(rect: CGRect = CGRect.zero) -> UIImageView {
        let imageView = UIImageView(frame: rect);
        addSubview(imageView);
        imageView.backgroundColor = .clear;
        imageView.clipsToBounds = true;
        imageView.contentMode = .scaleAspectFill;
        return imageView;
    }
    
    func createView() -> UIView {
        let sView = UIView();
        addSubview(sView);
        return sView;
        
    }
    
    func createLabel(rect: CGRect = CGRect.zero,text: String = "") -> UILabel {
        let label = UILabel(frame: rect);
        label.backgroundColor = .clear;
        label.font = fontSize(size: 14);
        label.textColor = .darkGray;
        addSubview(label);
        label.numberOfLines = 0;
        label.text = text;
        return label;
    }
    
    func createTextField(rect: CGRect = CGRect.zero) -> UITextField {
        let textField = UITextField(frame: rect);
        addSubview(textField);
        textField.textColor = UIColor.darkText;
        textField.borderStyle = .none;
        return textField;
        
    }
    
    func createView(rect:CGRect) -> UIView {
        let view = UIView(frame: rect);
        addSubview(view);
        view.backgroundColor = rgbColor(rgb: 106);
        return view;
    }

}
