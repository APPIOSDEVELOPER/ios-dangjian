//
//  ExtensionView.swift
//  StudyApp
//
//  Created by yaojinhai on 2017/4/11.
//  Copyright © 2017年 yaojinhai. All rights reserved.
//

import UIKit
extension UIView {

    var minX: CGFloat{
        return frame.minX;
    }
    var maxY: CGFloat{
        return frame.maxY;
    }
    var minY: CGFloat {
        return frame.minY;
    }
    var midX: CGFloat {
        return frame.midX;
    }
    var midY: CGFloat {
        return frame.midY;
    }
    var maxX: CGFloat{
        return frame.maxX;
    }
    
    var height: CGFloat {
        return self.frame.height;
    }
    var width: CGFloat {
        return self.frame.width;
    }

    
    var intWidth: Int{
        return Int(width);
    }
}
