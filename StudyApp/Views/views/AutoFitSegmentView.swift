//
//  AutoFitSegmentView.swift
//  StudyApp
//
//  Created by yaojinhai on 2017/8/27.
//  Copyright © 2017年 yaojinhai. All rights reserved.
//

import UIKit

protocol AutoFitSegmentViewDelegate : NSObjectProtocol {
    func autoView(view: AutoFitSegmentView,index: Int);
}

enum AutoFitSegmentType {
    case defult
    case popView
    
}

class AutoFitSegmentView: BaseView {
    
    private var perWidth: CGFloat = 1;
    private var preIndex = -1;
    var currentIndex = 0 {
        didSet{
            updateSelectedIndex(index: currentIndex);
        }
    }
    
    var lineColor = rgbColor(r: 212, g: 227, b: 239);
    
    var selectedColor = rgbColor(rgb: 240);
    var normalColor = UIColor.white;
    
    var isAbleSelectedColor = true;
    
    
    
    var type = AutoFitSegmentType.defult {
        didSet{
            updateAttubte();
        }
    }
    
    
    var textColors: [UIColor]!

    var dataSource: [String]!{
        didSet{
            updateView();
        }
    }
    var dataSourceAttribute: [NSAttributedString]! {
        didSet {
            updateView();
        }
    }
    
    func addLineDoubleLine() -> Void {
        
        let count = counts();
        
        lineView = createView(rect: CGRect.init(x: 0, y: height - 2, width: width / CGFloat(count), height: 2));
        lineView.backgroundColor = rgbColor(r: 0, g: 213, b: 252);
    }
    
    func counts() -> Int {
        return (dataSource?.count ?? dataSourceAttribute?.count) ?? 1;
    }
    
    func createSetSegemnt(items: [String]) -> Void {
        isAbleSelectedColor = true;
        backgroundColor = rgbColor(r: 248, g: 251, b: 254);//248 251 254
        selectedColor = rgbColor(r: 27, g: 131, b: 241);//27 131 241 129 168 199
        normalColor = rgbColor(r: 129, g: 168, b: 199);
        lineColor = rgbColor(r: 0, g: 213, b: 252);

        dataSource = items;
        
        currentIndex = 0;
        addSegemntLine();
        addLineDoubleLine();
    }
    
    func updateAttubte() -> Void {
        if type == .popView {
            isAbleSelectedColor = false;
            contentInsert = UIEdgeInsetsMake(0, 0, 10, 0);
            textColors = [rgbColor(r: 255, g: 87, b: 144),rgbColor(r: 27, g: 131, b: 241),rgbColor(r: 27, g: 131, b: 241)];
            selectedColor =  rgbColor(r: 228, g: 77, b: 241);//228 77 128
            dataSource = ["删除","修改","添加"];
           addSegemntLine();
        }
    }
    
    
    weak var delegate: AutoFitSegmentViewDelegate?

    
    func updateView() -> Void {
        self.subviews.forEach { (tempView) in
            if tempView is UILabel {
                tempView.removeFromSuperview();
            }
        }
        let count = counts();
        perWidth = width / CGFloat(count);
        
        
        
        for item in 0..<count{
            
            let label = createButton(rect: CGRect.init(x: perWidth * CGFloat(item), y: contentInsert.top, width: perWidth, height: height - contentInsert.bottom));
            
            insertSubview(label, at: 0);
            label.titleLabel?.font = fontSize(size: 13);

            label.backgroundColor = UIColor.clear;
            label.setTitleColor(normalColor, for: .normal);
            label.tag = item + 10;
            if let text = dataSource?[item] {
                label.setTitle(text, for: .normal);
            }
            if let textColor = textColors?[item] {
                label.setTitleColor(textColor, for: .normal);
            }
            
            if type == .popView {
                if item == 0 {
                    label.setTitleColor(selectedColor, for: .highlighted);
                }else {
//                    23 115 212
                    label.setTitleColor(rgbColor(r: 23, g: 115, b: 212), for: .highlighted);
                }
                
                
//                241 247 252
                label.setBackgroundImage(UIImage.createImage(color: rgbColor(r: 241, g: 247, b: 252)), for: .highlighted);
                
            }
            
            label.addTarget(self, action: #selector(selected(_:)), for: .touchUpInside);
            
            
        }
        
        updateSelectedIndex(index: 0);
    }
    
    
    
    func addSegemntLine() -> Void {
        let perWidth = width / CGFloat(dataSource.count);
        for idx in 1..<dataSource.count {
            let rect = CGRect.init(x: perWidth * CGFloat(idx), y: (height - 14)/2, width: 1, height: 14);
            let line = createView(rect: rect);
            line.backgroundColor = lineColor;
        }
    }
    
    override func initView() {
        addTapGeture(target: self, seletor: #selector(selected(_:)), view: self);
    }
    
    @objc func selected(_ sender: AnyObject) -> Void {
        
        var index = 0;

        if let tap = sender as? UITapGestureRecognizer {
            let point = tap.location(in: self);
            
            let pw = self.width / CGFloat(self.dataSource.count);
            index = Int(point.x / pw);
        }else if let btn = sender as? UIButton {
            index = btn.tag - 10;
        }
        
        

        updateSelectedIndex(index: index);

        delegate?.autoView(view: self, index: index);
        
        
    }
    
    func updateSelectedIndex(index: Int) -> Void {

//        if preIndex == index {
//            return;
//        }
        if isAbleSelectedColor == false{
            return;
        }
        
        let preLabel = self.viewWithTag(preIndex + 10) as? UIButton;
        preLabel?.setTitleColor(normalColor, for: .normal);
        
        let selLabel = self.viewWithTag(index + 10) as? UIButton;
        selLabel?.setTitleColor(selectedColor, for: .normal);
        
        
        if lineView != nil {
            
            var rect = self.lineView.frame;
            rect.origin.x = rect.width * CGFloat(index);
            self.lineView.frame = rect;
            
//            UIView.animate(withDuration: 0.3, animations: { 
//                var rect = self.lineView.frame;
//                rect.origin.x = rect.width * CGFloat(index);
//                self.lineView.frame = rect;
//            })
            
        }
        
        preIndex = index;
    }
    

}
