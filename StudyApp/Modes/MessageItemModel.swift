//
//  MessageItemModel.swift
//  StudyApp
//
//  Created by yaojinhai on 2018/4/9.
//  Copyright © 2018年 yaojinhai. All rights reserved.
//

import UIKit

class MessageModel: NSObject {
    var width: CGFloat = 0;
    // 最后配置 这个参数
    var offsize = CGPoint.init(x: 8, y: 8);
    var isSelected = false;
    var name = "张三";
    var comment = "习近平强调，支持联合国发挥作用，维护联合国权威和地位，是中国外交一项基本政策。我们主张大小国家一律平等，同时也认为大国要承担起应有的责任。多边主义的要义是谋求各国协商和合作，首先是大国合作。";

    let deFont = [NSAttributedStringKey.font: fontSize(size: 12)];

}

extension MessageItemModel {
    var contentFrame: CGRect {
        if isReflex {
            return reflexContentRect;
        }
        return contextRect;
    }
    var backColor: UIColor {
        if isSelected {
            return UIColor.red.withAlphaComponent(0.6);
        }
        return UIColor.clear;
    }
    var textAttribute: NSAttributedString {
        if isReflex {
            return reflexContent;
        }
        return contentAttribute;
    }
}

class MessageItemModel: MessageModel {
    
    var otherName = "李红";
    var isReflex = false;
    
    
    // 回复 专用
    private var _otherNameRect = CGRect.zero;
    var otherNameRect: CGRect {
        if !_otherNameRect.equalTo(CGRect.zero) {
            return _otherNameRect;
        }
        
        let aswer = " 回复 ";
        let nameStrl = name + aswer + otherName + ": ";
        let size = nameStrl.size(size: .init(width: width, height: CGFloat.greatestFiniteMagnitude), font: 12);
        
        let aswerRect = aswer.size(size: .init(width: width, height: CGFloat.greatestFiniteMagnitude), font: 12);
        
        _otherNameRect = CGRect.init(x: nameRect.maxX + aswerRect.width, y: nameRect.minY, width: size.width, height: size.height);
        return _otherNameRect;
    }
    
    
    private var _reflexContent: NSAttributedString!
    var reflexContent: NSAttributedString {
        if _reflexContent != nil {
            return _reflexContent;
        }
        let aswer = " 回复 ";
        let nameStrl = name + aswer + otherName + ": ";
        
        let at = NSMutableAttributedString(string: nameStrl  + comment);
        at.addAttributes(deFont, range: .init(location: 0, length: at.length));
        at.addAttributes([NSAttributedStringKey.foregroundColor:UIColor.blue], range: .init(location: 0, length: name.count));
        at.addAttributes([NSAttributedStringKey.foregroundColor:UIColor.blue], range: .init(location: name.count + aswer.count, length: otherName.count + 2));
        _reflexContent = at;
        return at;
    }
    
    
    private var reflexRect = CGRect.zero;
    var reflexContentRect: CGRect {
        if !reflexRect.isEmpty {
            return CGRect.init(x: offsize.x, y: offsize.y, width: reflexRect.width, height: reflexRect.height);
        }
        let size = reflexContent.boundingRect(with: .init(width: width - offsize.x * 2, height: CGFloat.greatestFiniteMagnitude), options: [.usesFontLeading,.usesLineFragmentOrigin], context: nil);
        reflexRect = CGRect.init(x: offsize.x, y: offsize.y, width: size.width, height: size.height);
        return reflexRect;
    }
    
    // 普通的评论
    
    private var nRect = CGRect.zero;
    var nameRect: CGRect {
        if !nRect.equalTo(CGRect.zero) {
            return CGRect.init(x: offsize.x, y: offsize.y, width: nRect.width, height: nRect.height);
        }
        let size = name.size(size: .init(width: width - offsize.x * 2, height: CGFloat.greatestFiniteMagnitude), font: 12);
        nRect = CGRect.init(x: offsize.x, y: offsize.y, width: size.width, height: size.height);
        return nRect;
    }
    
    private var _contentAttribute: NSAttributedString!
    var contentAttribute: NSAttributedString {
        if _contentAttribute != nil {
            return _contentAttribute;
        }
        
        let at = NSMutableAttributedString(string: name + ": " + comment);
        at.addAttributes(deFont, range: .init(location: 0, length: at.length));
        at.addAttributes([NSAttributedStringKey.foregroundColor:UIColor.blue], range: .init(location: 0, length: name.count + 2))
        _contentAttribute = at;
        return at;
        
    }
    
    
    
    private var _contextRect = CGRect.zero;
    var contextRect: CGRect {
        if !CGRect.zero.equalTo(_contextRect) {
            return CGRect.init(x: offsize.x, y: offsize.y, width: _contextRect.width, height: _contextRect.height);
        }
        let allItem = name + ": " + comment;
        let size = allItem.size(size: .init(width: width - offsize.x * 2, height: CGFloat.greatestFiniteMagnitude), font: 12);
        _contextRect = CGRect.init(x: offsize.x, y: offsize.y, width: size.width, height: size.height);
        return _contextRect;
    }
}


