//
//  DefineManager.swift
//  StudyApp
//


import Foundation
import UIKit

// MARK: - 屏幕
let sBound = UIScreen.main.bounds;
let sHeight = sBound.height;
let sWidth = sBound.width;

func UIEdge(size: CGFloat) -> UIEdgeInsets {
    return UIEdgeInsetsMake(size, size, size, size);
}
// MARK: debug print

//MARK: - debug log

func printObject(_ content: String, file: String = #file,funName: String = #function, line: Int = #line) {
    #if DEBUG
        print("\n<begin>\n文件路径:" + file + "\n函数名字:" + funName + "\n第\(line)行" + "\n\n" + content + "\n<end>\n");
    #endif
    
}

// MARK: - is pad

let IS_PAD: Bool = {
    return $0;
}(UIDevice.current.userInterfaceIdiom == .pad)

// MARK: - 数学函数配置

func add(i: inout Int) -> Int {
    i += 1;
    return i;
}

//MARK: - 颜色配置

func rgbColor(rgb: Int) -> UIColor {
    return rgbColor(r: rgb, g: rgb, b: rgb);
}

func rgbColor(r: Int,g: Int,b: Int) -> UIColor {
    
    if #available(iOS 10.0, *) {
       return UIColor(displayP3Red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1)
    }
    
    return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1)
}

func randomColor() -> UIColor {
 
    let color = rgbColor(r: Int(arc4random_uniform(255)), g: Int(arc4random_uniform(255)), b: Int(arc4random_uniform(255)));

    return color;
}

func randomColorExpWhite() -> UIColor {
    let color = rgbColor(r: Int(arc4random_uniform(254)), g: Int(arc4random_uniform(220)), b: Int(arc4random_uniform(240)));
    return color;
}


func colorFromHex(_ hexString:String)-> UIColor{
    
    var cString = hexString.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased() as NSString
    if cString.length < 6{
        return UIColor.clear
    }
    
    if cString.hasPrefix("0X") {
        
        cString = cString.substring(with: NSMakeRange(2, cString.length - 2)) as NSString
    }
    if cString.hasPrefix("#") {
        cString = cString.substring(with: NSMakeRange(1, cString.length - 1)) as NSString
    }
    if cString.length != 6 {
        return UIColor.clear
    }
    var range = NSMakeRange(0, 2)
    let rString = cString.substring(with: range)

    range.location = 2;
    let gString = cString.substring(with: range)

    range.location = 4;
    
    let bString = cString.substring(with: range)

    var r:UInt64 = 0, g:UInt64 = 0, b:UInt64 = 0
    Scanner(string: rString).scanHexInt64(&r)
    Scanner(string: gString).scanHexInt64(&g)
    Scanner(string: bString).scanHexInt64(&b)
    return UIColor.init(red: CGFloat(r) / CGFloat(255), green: CGFloat(g) / CGFloat(255), blue: CGFloat(b) / CGFloat(255), alpha: 1)
}
// 导航栏的颜色 54 68 91
let navigateColor = rgbColor(r: 54, g: 68, b: 91);

// MARK: - 字体配置
func fontSize(size: CGFloat) -> UIFont {
//
    return UIFont(name: "PingFangSC-Light", size: size)!;
//    return UIFont.systemFont(ofSize: size);
}

func fontBlod(size: CGFloat) -> UIFont {
    return UIFont.boldSystemFont(ofSize: size);
}

extension String {
    func pinYin() -> String {
        let pinYin = NSMutableString(string: self);
        
        CFStringTransform(pinYin as CFMutableString, nil, kCFStringTransformMandarinLatin, false);
        
        CFStringTransform(pinYin as CFMutableString, nil, kCFStringTransformStripCombiningMarks, false);
        return pinYin as String;
    }
    func capterPinYin() -> String {
        let pinY = pinYin();
        if !pinY.isEmpty {
            let firstName = pinY.substring(to:pinY.index(after: pinY.startIndex)) as String
            return firstName.uppercased();
        }
        return "";
        
    }
    
    func size(size: CGSize,font: CGFloat) -> CGSize {
        
        let str = NSString(string: self);
        let newSize = str.boundingRect(with: size, options: [.usesFontLeading,.usesLineFragmentOrigin], attributes: [NSAttributedStringKey.font:fontSize(size: font)], context: nil).size;
        
        return newSize;
    }
    
    var isPhone: Bool {
        let regex = "^1[3578][0-9]{9}$";
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex);
        return predicate.evaluate(with:self);
    }
    var isPassWord : Bool {
        let regex = "^[0-9a-zA-Z]{6,12}$";
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex);
        return predicate.evaluate(with:self);
    }
    func passWord() -> Void {
        
//        let regex = "";
//        let predicate = NSPredicate(format: "SELF MATCHES %@", regex);
//        return predicate.evaluate(with:self);

        var onlyAAA = "(\\w|\\W)(\\1)*";
        var onlyAAaa = "(\\w|\\W)(\\1)*(\\w|\\W)(\\3)*";

    }
}

extension NSString {
    
    func pinYin() -> String {
        let pinYin = NSMutableString(string: self);
        
        CFStringTransform(pinYin as CFMutableString, nil, kCFStringTransformMandarinLatin, false);
        
        CFStringTransform(pinYin as CFMutableString, nil, kCFStringTransformStripCombiningMarks, false);
        return pinYin as String;
    }
    func capterPinYin() -> String {
        let pinY = pinYin();
        
        guard pinY.count > 0 else {
            return "";
        }
        let firstName = pinY[pinY.startIndex..<pinY.index(after: pinY.startIndex)];
        return String(firstName);
        
    }
}

func drawImageColor(_ image: UIImage,color: UIColor) -> UIImage {
    
    UIGraphicsBeginImageContextWithOptions(image.size, false, UIScreen.main.scale);
    color.setFill();
    let bounds = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height);
    UIRectFill(bounds);
    //    image.drawInRect(bounds, blendMode: CGBlendMode.Overlay, alpha: 1);
    image.draw(in: bounds, blendMode: CGBlendMode.destinationIn, alpha: 1);
    
    let newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage!;
}

extension UIImage {
    func drawRectWithRroundedCorner(_ randius : CGFloat,sizeFit : CGSize) -> UIImage {
        let rect = CGRect(origin: CGPoint.zero, size: sizeFit);
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale);
        let context = UIGraphicsGetCurrentContext()
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: UIRectCorner.allCorners, cornerRadii: CGSize(width: randius, height: randius));
        context?.addPath(path.cgPath);
        context?.clip();
        self.draw(in: rect);
        context?.drawPath(using: CGPathDrawingMode.fillStroke);
        let outImg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return outImg!;
    }
    
    func clipSize(_ size : CGSize) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale);
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height));
        let outImg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return outImg!;
    }
}

/// Notification center defualt

protocol NotificationCenterDelegate {
    var customName: NSNotification.Name{get}
}

enum BANotificationName: String,NotificationCenterDelegate {
    case userLogin
    case register
    case tabbarIndexChange
  
    var customName: NSNotification.Name{
        return NSNotification.Name("bat_1_"+rawValue);
    }
}


extension NSNotification.Name: NotificationCenterDelegate {
    var customName: NSNotification.Name {
        return self;
    }
    
}


extension NotificationCenter{
    
    static func post(name:NotificationCenterDelegate,userInfo:[AnyHashable:Any]?,object:Any? = nil){
        NotificationCenter.default.post(name: name.customName, object: object, userInfo: userInfo);
    }
    
    static func post(name: NotificationCenterDelegate,object:Any?,queue:OperationQueue?,block: @escaping (Notification) -> Void) -> NSObjectProtocol{
        
        return NotificationCenter.default.addObserver(forName: name.customName, object: object, queue: queue) { (notication) in
            block(notication);
        };
    }
    
    static func add(observer: Any,selector:Selector,name:NotificationCenterDelegate){
        NotificationCenter.default.addObserver(observer, selector: selector, name: name.customName, object: nil);
    }
    
}



