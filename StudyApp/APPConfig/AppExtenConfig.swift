//
//  AppExtenConfig.swift
//  StudyApp
//
//  Created by yaojinhai on 2017/9/1.
//  Copyright © 2017年 yaojinhai. All rights reserved.
//

import Foundation


extension UIColor {
    @nonobjc class var untYellow: UIColor {
        return UIColor(red: 254.0 / 255.0, green: 207.0 / 255.0, blue: 51.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var untLightOrange: UIColor {
        return UIColor(red: 253.0 / 255.0, green: 189.0 / 255.0, blue: 57.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var untPeach: UIColor {
        return UIColor(red: 238.0 / 255.0, green: 103.0 / 255.0, blue: 35.0 / 255.0, alpha: 1.0)
    }
}


extension CGSize {
    static func convertIphone5Size(cSize: CGSize,scale: CGFloat = 0.84) -> CGSize{
        let newScale: CGFloat = iOSIPhoneInfoData.isIphone1_5 ? scale : 1;
        return CGSize.init(width: cSize.width * newScale, height: cSize.height * newScale);
    }
}

extension String {
    func isPhoneNumber() -> Bool {
        
        let phoneRegex = "^((13[0-9])|(15[^4,\\D])|(18[0-9])|(14[57])|(17[013678]))\\d{8}$";
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex);//[NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
//        return [phoneTest evaluateWithObject:mobile];
        return phoneTest.evaluate(with: self, substitutionVariables: nil);
        
    }
}

extension UIImage {
   class func createImage(color: UIColor) -> UIImage {
        let rect = CGRect.init(x: 0, y: 0, width: 1, height: 1);
        UIGraphicsBeginImageContext(rect.size);
        let context = UIGraphicsGetCurrentContext();
        context?.setFillColor(color.cgColor);
        context?.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!;
    }
    
   class func getGIFDataName(name: String) -> [UIImage]? {
        
        guard let gifPath = Bundle.main.url(forResource: name, withExtension: "gif"),let sourceImages = CGImageSourceCreateWithURL(gifPath as CFURL, nil) else {
            return nil;
        }
        
        let count = CGImageSourceGetCount(sourceImages);
        var images = [UIImage]();
        for idx in 0..<count {
            let cgImage = CGImageSourceCreateImageAtIndex(sourceImages, idx, nil);
            let image = UIImage(cgImage: cgImage!);
            images.append(image);
        }
        return images;
    }
}

// Text styles


struct iOSIPhoneInfoData {
    static let iphone5: CGFloat = 568;
    static let iphone6: CGFloat = 750;
    static let isIphone1_5 = sHeight <= iOSIPhoneInfoData.iphone5;
    static let isStatanderModel = UIScreen.main.nativeScale == UIScreen.main.scale;
    static let scale = UIScreen.main.scale;
}

enum UserOperationType {
    case login
    case alterPass
    case register
    case forgetPass
    case alterUser
}

enum ViewTagSense: Int {
    case searchTag = 1
    case addTag
    case refreshTag
    case backTag
    case messageTag
    case fullScreenVedioTag
    case playOrStopTag
    case sendVertifyTag
    case forgetPassTag
    case loginAppTag
    case sendMsgTag
    case sendMsgFlagTag
    case supTag // 点赞
    case shareTag
    case qqTag
    case wxTag
    
    case timeDD // 时间点
    case timeMin // 分钟
    case timeSecond // 秒
}


