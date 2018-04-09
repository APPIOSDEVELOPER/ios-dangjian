//
//  YTSharePathView.swift
//  StudyApp
//
//  Created by yaojinhai on 2017/5/26.
//  Copyright © 2017年 yaojinhai. All rights reserved.
//

import UIKit

enum YTShapeViewType {
    case pureView
    case typeCicel
    case roundRect
    case arcStroke
    case hollowStroke
    case gradientRect
    case mutableArc
    case testResultFlagBar
    case thermometertLeftFlag //温度计
    case thermometertRightFlag //温度计
    case lineBarHistory
    case clickTapDraw

}

class YTShapePathView: UIView {

    var textLabel : UILabel!
    var shapeType: YTShapeViewType = .typeCicel;
    
    var fillColor = UIColor.white {
        didSet{
            setNeedsDisplay();
        }
    }
    
    var changeColor = UIColor.red;
    
    
    private var contentImage: UIImage!
 
    var progress : CGFloat = 0 {
        didSet{
            updateProgress();
        }
    }
    
    var shapeLayer: CAShapeLayer! // mask layer
    var gradientLayer: CAGradientLayer!
    var backShapeLayer: CAShapeLayer!
    var maskLayer: CALayer!
    
    var lineWidth: CGFloat = 10;
    
    
    convenience init(frame: CGRect,type: YTShapeViewType) {
        self.init(frame: frame);
        shapeType = type;
        backgroundColor = UIColor.white;
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tap(_:)));
        addGestureRecognizer(tap);
        
        
        
    }
    @objc func tap(_ tap:UITapGestureRecognizer) -> Void {
//        let point = tap.location(in: self);
        let rect = bounds;//CGRect.init(x: point.x, y: point.y, width: 10, height: 10);
        changeColor = randomColor();
        setNeedsDisplay(rect);
        
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        configLabel();
    }
    
    override func awakeFromNib() {
        configLabel();
    }
    
    func configLabel() -> Void {
        if textLabel == nil {
            textLabel = UILabel(frame: bounds);
            textLabel.textAlignment = .center;
            textLabel.backgroundColor = UIColor.clear;
            addSubview(textLabel);
            textLabel.textColor = UIColor.white;
            backgroundColor = UIColor.clear;
            textLabel.adjustsFontSizeToFitWidth = true;
        }
        
    }
    
    
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect);
        
        if shapeType == .typeCicel {
            
            let context = UIGraphicsGetCurrentContext();
            fillColor.set();
            context?.addEllipse(in: rect);
            context?.fillPath();
            
        }else if shapeType == .roundRect {
            
            let context = UIGraphicsGetCurrentContext();
            fillColor.set();
            let path = CGMutablePath();
            path.addRoundedRect(in: rect, cornerWidth: 8, cornerHeight: 8, transform: CGAffineTransform.identity);
            context?.addPath(path);
            context?.fillPath();

        }else if shapeType == .gradientRect {
            textLabel.textAlignment = .right;
            textLabel.font = fontSize(size: 13);
            textLabel.textColor = UIColor.white;
            
            gradientLayer = CAGradientLayer();
            gradientLayer.backgroundColor = UIColor.clear.cgColor;
            gradientLayer.frame = bounds;
            gradientLayer.colors = [rgbColor(r: 133, g: 136, b: 238).cgColor,rgbColor(r: 63, g: 214, b: 220).cgColor];
            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5);
            gradientLayer.endPoint = CGPoint(x: 1, y: 0.5);
            layer.addSublayer(gradientLayer);
            
        }else if shapeType == .mutableArc {
            
            var path = CGMutablePath();
            path.addArc(center: .init(x: width/2, y: height/2), radius: width/2 - 20, startAngle: -.pi/2, endAngle: 0, clockwise: true);
            var context = UIGraphicsGetCurrentContext();
            context?.addPath(path);
            context?.setFillColor(randomColor().cgColor);
            context?.fillPath();
            
            
            
            path = CGMutablePath();
            path.addEllipse(in: bounds.insetBy(dx: 40, dy: 40));
            context = UIGraphicsGetCurrentContext();
            context?.setFillColor(UIColor.white.cgColor);
            context?.fillPath();
            
        }else if shapeType == .thermometertLeftFlag {
            
            
            
            let context = UIGraphicsGetCurrentContext();
            context?.setFillColor(fillColor.cgColor);
            let path = CGMutablePath();
            path.addRoundedRect(in: .init(x: 0, y: (height - 12)/2, width: 12, height: 12), cornerWidth: 6, cornerHeight: 6);
            
            path.addRect(.init(x: 6, y: (height - 2)/2, width: width - 6, height: 2));
            context?.addPath(path);
            context?.fillPath();
            
        }else if shapeType == .thermometertRightFlag {
            
            let context = UIGraphicsGetCurrentContext();
            context?.setFillColor(fillColor.cgColor);
            let path = CGMutablePath();
            path.addRoundedRect(in: .init(x: width - 12, y: (height - 12)/2, width: 12, height: 12), cornerWidth: 6, cornerHeight: 6);
            
            path.addRect(.init(x: 0, y: (height - 2)/2, width: width - 6, height: 2));
            context?.addPath(path);
            context?.fillPath();
            
        }else if shapeType == .lineBarHistory{
            
            let context = UIGraphicsGetCurrentContext();
            context?.setFillColor(fillColor.cgColor);
            let path = CGMutablePath();
            path.addRoundedRect(in: .init(x: 0, y: 0, width: width, height: width), cornerWidth: width/2, cornerHeight: width/2);
            
            path.addRect(.init(x: 2, y: width/2, width: width - 4, height: height - width/2));
            context?.addPath(path);
            context?.fillPath();
        }else if shapeType == .clickTapDraw {
            
            let context = UIGraphicsGetCurrentContext();
            context?.setFillColor(changeColor.cgColor);
            context?.addRect(rect);
            context?.fillPath();
            context?.closePath();
            
        }else {

   
            
            let colorComponents: [CGFloat] = [0.1,0.9,0.8,1,
                                              0.4,0,1,1,
                                              0.8,0,0,1];
            
            let locations: [CGFloat] = [0,0.3,0.5,0.7,0.9];
            if #available(iOS 10.0, *) {
                let gradient = CGGradient(colorSpace: CGColorSpace.init(name: CGColorSpace.extendedLinearSRGB)!, colorComponents: colorComponents, locations: locations, count: 3)
                let context = UIGraphicsGetCurrentContext();
                
                context?.drawLinearGradient(gradient!, start: .init(x: 0, y: 0), end: .init(x: rect.width, y: rect.height), options: CGGradientDrawingOptions.drawsBeforeStartLocation);
                
//                let funcs = CGFunction(info: nil, domainDimension: 9, domain: nil, rangeDimension: 9, range: nil, callbacks: );
//
//                let shading = CGShading.init(axialSpace: CGColorSpace.init(name: CGColorSpace.displayP3)!, start: CGPoint.init(x: 0, y: 0), end: CGPoint.init(x: 100, y: 100), function: funcs, extendStart: true, extendEnd: true);
                
//                context?.drawShading(<#T##shading: CGShading##CGShading#>)
            } else {
                // Fallback on earlier versions
            }
            
            
            

            
        }
        
        
        
    }
    
    
    
    private func updateProgress() -> Void {
        
        createGradientLayer();
        
        let api = progress * 2 * CGFloat.pi;
        
        let arcPath = CGMutablePath();
        
        if progress >= 1 {
            arcPath.addEllipse(in: bounds.insetBy(dx: lineWidth, dy: lineWidth));

        }else{
            arcPath.addArc(center: CGPoint.init(x: self.width / 2, y: self.height / 2), radius: self.width / 2 - lineWidth, startAngle: -.pi/2, endAngle: .pi - (api - .pi/2), clockwise: true, transform: CGAffineTransform.identity);
        }
        
        
        self.shapeLayer.path = arcPath;
        
        
    }
    
    private func createGradientLayer() -> Void {
        
        if gradientLayer != nil {
            return;
        }
        
        let path = CGMutablePath();
        path.addEllipse(in: bounds.insetBy(dx: lineWidth, dy: lineWidth));
        backShapeLayer = createLayer(path: path);
        layer.addSublayer(backShapeLayer);
        
        
        let arcPath = CGMutablePath();
        arcPath.addArc(center: CGPoint.init(x: width / 2, y: height / 2), radius: width / 2 - lineWidth, startAngle: -.pi/2, endAngle: 0, clockwise: true, transform: CGAffineTransform.identity);
        shapeLayer = createLayer(path: arcPath);
        
        
        
        gradientLayer = CAGradientLayer();
        gradientLayer.backgroundColor = UIColor.clear.cgColor;
        gradientLayer.frame = bounds;
        gradientLayer.colors = [rgbColor(r: 62, g: 215, b: 221).cgColor,rgbColor(r: 134, g: 136, b: 238).cgColor];
        gradientLayer.startPoint = CGPoint.zero;
        gradientLayer.endPoint = CGPoint(x: 1, y: 1);
        layer.addSublayer(gradientLayer);
        
        gradientLayer.mask = shapeLayer;
    }
    
    
    
    private func createLayer(path: CGPath) -> CAShapeLayer {
        let shape = CAShapeLayer();
        shape.fillColor = UIColor.clear.cgColor;
        shape.frame = bounds;
        shape.backgroundColor = UIColor.clear.cgColor;
        shape.strokeColor = rgbColor(rgb: 245).cgColor;
        shape.lineCap = kCALineCapRound;
        shape.lineWidth = lineWidth;
        shape.path = path;
        return shape;
        
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews();
        if textLabel != nil {
            textLabel.sizeToFit();
            textLabel.center = CGPoint(x: width / 2, y: height / 2);
        }
        if shapeType == .arcStroke {
            createGradientLayer();
        }else if shapeType == .hollowStroke {
            if shapeLayer == nil {
                shapeLayer = CAShapeLayer();
                shapeLayer.backgroundColor = UIColor.clear.cgColor;
                shapeLayer.frame = UIEdgeInsetsInsetRect(bounds, UIEdge(size: 1));
                layer.addSublayer(shapeLayer);
                shapeLayer.borderColor = UIColor.white.cgColor;
                shapeLayer.borderWidth = 1;
            }
            
        }else if shapeType == .testResultFlagBar {
            
            if gradientLayer == nil {
                contentImage = UIImage(named: "default_greate_flag_line");
                createBackGrayLayer();
            }
            
            
            
        }
    }
    
    
    func createBackGrayLayer() -> Void {
        
        let backGrayBar = createBarLayer();
        layer.addSublayer(backGrayBar);
        
        gradientLayer = CAGradientLayer();
        gradientLayer.frame = backGrayBar.frame;
        layer.addSublayer(gradientLayer);
//        62 215 220
//         134 136 238
        gradientLayer.colors = [rgbColor(r: 62, g: 215, b: 220).cgColor,rgbColor(r: 134, g: 136, b: 238).cgColor];
        maskLayer = createBarLayer();
        gradientLayer.contents = nil;
        gradientLayer.mask = maskLayer;
        
        var rect = maskLayer.frame;
        rect.size.width = self.width/2;
        maskLayer.frame = rect;
    }
    
    func createBarLayer() -> CALayer {
        let backGrayBar = CALayer();
        backGrayBar.frame = .init(x: 0, y: height - contentImage.size.height, width: contentImage.size.width, height: contentImage.size.height);
        
        backGrayBar.contents = contentImage?.cgImage;
        backGrayBar.contentsGravity = kCAGravityResizeAspectFill;
        return backGrayBar;
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
//        fatalError("init(coder:) has not been implemented")
    }
    
   

}
