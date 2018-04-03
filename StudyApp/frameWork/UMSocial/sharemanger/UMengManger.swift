//
//  UMengManger.swift
//  StudyApp
//
//  Created by yaojinhai on 2017/4/26.
//  Copyright © 2017年 yaojinhai. All rights reserved.
//

import UIKit

class UMengManger: NSObject {
    
//    private var platType = UMSocialPlatformType.wechatSession;
//    private var controller: UIViewController!
//    var loginFinished: ((NSDictionary,Bool) -> ())!
//    
//    override init() {
//        super.init();
//    }
//    
//    init(type: UMSocialPlatformType,viewController: UIViewController) {
//        super.init();
//        self.platType = type;
//        self.controller = viewController;
//        
//    }
//    
//    func loginAppByPlatType(finished: @escaping (NSDictionary,Bool) -> ()) -> Void {
//        self.loginFinished = finished;
//        UMSocialManager.default().getUserInfo(with: platType, currentViewController: controller) { (result, error) in
//            if let resp = result as? UMSocialUserInfoResponse {
//                
//                self.loginAppToNet(response: resp);
//                
//            }else{
//                
//                if self.loginFinished != nil {
//                    let dict = NSDictionary(dictionary: ["error":error ?? NSError.init(domain: "未知错误", code: -100, userInfo: ["":""])])
//                    self.loginFinished(dict,false);
//
//                }
//            }
//        }
//    }
//    
//    func shareToUmenNet(type: UMSocialPlatformType,ctrl: UIViewController) -> Void {
//        let msge = UMSocialMessageObject();
//        let shareObject = UMShareWebpageObject.shareObject(withTitle: "我刚做了个英语测试，你也来？看看比我差在哪~", descr: "JIONGBOOK打造测试工具「JIONGBOOK」，随时随地检测英语水平。", thumImage: UIImage(named: "1680490759.jpg"));
//        shareObject?.webpageUrl = shareJiongCeURL;
//        msge.shareObject = shareObject;
//        
//        UMSocialManager.default().share(to:type, messageObject: msge, currentViewController: ctrl) { (result, erro) in
//            printObject("share = \(result),error = \(erro)");
//        }
//    }
//    
//   private func loginAppToNet(response: UMSocialUserInfoResponse) -> Void {
//        
//
//        
//    }
//
//   class func getUserInfo(ctrl: UIViewController) {
//    
//    
//    }
}


