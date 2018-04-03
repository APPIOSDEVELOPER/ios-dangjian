//
//  GraphicView.swift
//  PhoneApp
//
//  Created by yaojinhai on 2017/8/18.
//  Copyright © 2017年 yaojinhai. All rights reserved.
//

import UIKit

class GraphicView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        backgroundColor = UIColor.clear;
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func arcByAngle(angle: CGFloat) -> CGFloat {
        let arc = angle * 2 * .pi / 360;
        return arc;
    }
    
    override func draw(_ rect: CGRect, for formatter: UIViewPrintFormatter) {
        formatter.view.draw(rect);
        
        printObject("rect = \(rect)")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect);
        
        
        
        let sCenter = CGPoint.init(x: width/2, y: height/2);
        
        
        let arcs = [95,80,90,95];
        
        
        var arcCount: CGFloat = 0;
        
        var lastPoint = CGPoint(x: width, y: height/2);
        
        for angle in arcs {
            
            let arc = arcByAngle(angle: CGFloat(angle));
            
            
            let context = UIGraphicsGetCurrentContext();
            context?.setFillColor(randomColor().cgColor);
            
            let path = CGMutablePath();
            path.move(to: sCenter);
            
            path.addLine(to: lastPoint);
            
            path.addArc(center: sCenter, radius: width/2, startAngle: arcCount, endAngle: arc + arcCount, clockwise: false);
            
            lastPoint = path.currentPoint;
            path.closeSubpath();
            context?.addPath(path);
            context?.fillPath();
            
            let persent = String(describing: Int(arc / 2 / .pi));
            NSString(string: persent).draw(at: CGPoint.init(x: lastPoint.x - 25, y: lastPoint.y + 5), withAttributes: [NSAttributedStringKey.font:fontSize(size: 12),NSAttributedStringKey.foregroundColor:UIColor.white]);
            
            arcCount += arc;
        }
        
        
    
        let context = UIGraphicsGetCurrentContext();
        context?.setFillColor(UIColor.red.cgColor);
        let pw: CGFloat = 40;
        context?.addEllipse(in: bounds.insetBy(dx: pw, dy: pw));
        context?.fillPath();
        
        
        
        
    }

}
