//
//  CommentBarView.swift
//  StudyApp
//
//  Created by yaojinhai on 2018/4/9.
//  Copyright © 2018年 yaojinhai. All rights reserved.
//

import UIKit

enum MessageModelType {
    case name
    case otherName
    case context
}

protocol CommentBarViewdelegate {
    func selectedItem(subView: CommentBarView,model: MessageItemModel,type: MessageModelType) -> Void
}

class CommentBarView: BaseView {
    
    
    var listMessage = [MessageItemModel]();
    var delegate: CommentBarViewdelegate!
    

    override func initView() {
        
        let mItem = MessageItemModel();
        mItem.width = width;
        mItem.name = "第一个人";
        listMessage.append(mItem);
        
        print("1 offset = \(mItem.offsize),rect = \(mItem.contextRect)");
        
        
        let fItem = MessageItemModel();
        fItem.width = width;
        fItem.isReflex = true;
        fItem.comment = "2018年是中国改革开放40周年，也是贯彻落实党的十九大精神的开局之年。在这一重要历史时刻，展示改革开放新前景、解读中国发展新时代、提出共创未来新主张是此次论坛年会的主旋律。习主席将就如何推动对外开放再扩大、深化改革再出发作出最权威阐释，并宣布一系列改革开放重大新举措。习主席还将就进一步推动构建亚洲和人类命运共同体，开创亚洲和世界美好未来鲜明地发出中国声音、阐明中国立场。习主席的博鳌之行，必将为今年四大主场外交打造一个亮丽的开局，为深入推进新时代中国特色大国外交书写新的乐章。（作者系中国现代国际关系研究院世界经济研究所张茂荣 漫画作者廖婷婷）";
        fItem.name = "第二个人";
        fItem.offsize = CGPoint(x: mItem.offsize.x, y: mItem.contextRect.maxY + 8);
        
        print("2 offset = \(fItem.offsize),rect = \(fItem.reflexContentRect)");


        listMessage.append(fItem);
        
        let dItem = MessageItemModel();
        dItem.width = width;
        dItem.name = "第三个人";
        dItem.offsize = CGPoint(x: fItem.offsize.x, y: fItem.reflexContentRect.maxY + 8);

        listMessage.append(dItem);
        
        setNeedsDisplay();
        let tap = UITapGestureRecognizer(target: self, action: #selector(tap(_:)));
        addGestureRecognizer(tap);
        
    }
    @objc func tap(_ tap:UITapGestureRecognizer) -> Void {
        let point = tap.location(in: self);
        

        var model: MessageItemModel!
        var type = MessageModelType.context;
        
        for item in listMessage {
            item.isSelected = false;
            if item.nameRect.contains(point) {
                model = item;
                type = .name;
            }else if item.isReflex {
                if item.otherNameRect.contains(point) {
                    model = item;
                    type = .otherName;
                }
            }
            
            item.isSelected = item.contentFrame.contains(point);
            if item.isSelected && model == nil{
                model = item;
            }
        }
        if model != nil {
            delegate?.selectedItem(subView: self, model: model, type: type);
        }
        setNeedsDisplay();
    }
    
    
    override func draw(_ rect: CGRect) {
     
        if listMessage.count == 0 {
            return;
        }
        
        for item in listMessage {
            
            let context = UIGraphicsGetCurrentContext();
            context?.setFillColor(item.backColor.cgColor);
            context?.addRect(item.contentFrame.insetBy(dx: -4, dy: -4));
            context?.fillPath();
            item.textAttribute.draw(with: item.contentFrame, options: [.usesFontLeading,.usesLineFragmentOrigin], context: nil);
            
        }
        
 
        
        
    }

}
