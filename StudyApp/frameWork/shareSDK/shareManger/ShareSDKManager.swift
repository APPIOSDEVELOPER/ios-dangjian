//
//  ShareSDKManager.swift
//  StudyApp
//
//  Created by yaojinhai on 2017/4/26.
//  Copyright © 2017年 yaojinhai. All rights reserved.
//

import UIKit

class ShareSDKManager: NSObject {

    class func getUserInfo(type: SSDKPlatformType,finished:@escaping (_ success: Bool,_ error: NSError?,_ userInfo:SSDKUser?) -> Void)  {
        
        ShareSDK.cancelAuthorize(type);
        ShareSDK.getUserInfo(type) { (state, user, error) in
            
            if state == SSDKResponseState.success {
                finished(true,error as NSError?,user);
            }
            print("info = \(String(describing: user?.nickname)) id \(String(describing: user?.icon)) rawdata\(String(describing: user?.rawData)),state = \(state)");
        };
    
    }
    
   class func shareToMeida(_ messaga: ShareMessage,finished:@escaping (_ success: Bool,_ error: NSError?) -> Void)  {
        
        //1、创建分享参数（必要）
        
        
        //       
        
        
        let shareParams = NSMutableDictionary();
        
        
        let imgData = messaga.getImageData();
        
        
        shareParams.ssdkSetupShareParams(byText: messaga.getContext(), images: imgData, url: messaga.getShareURL(), title: messaga.title, type: messaga.type);
        
        
        shareParams.ssdkSetupQQParams(byText: messaga.getContext(), title: messaga.title, url: messaga.getShareURL(), audioFlash: messaga.getAudioURL(), videoFlash: messaga.getAudioURL(), thumbImage: imgData, images: imgData, type: messaga.type, forPlatformSubType: .subTypeQZone);
        
        shareParams.ssdkSetupQQParams(byText: messaga.getContext(), title: messaga.title, url: messaga.getShareURL(), audioFlash: messaga.getAudioURL(), videoFlash: messaga.getAudioURL(), thumbImage: imgData, images: imgData, type: messaga.type, forPlatformSubType: .subTypeQQFriend)
        
        
        
        //        shareParams.ssdkSetupQQParams(byText: <#T##String!#>, title: <#T##String!#>, url: <#T##URL!#>, audioFlash: <#T##URL!#>, videoFlash: <#T##URL!#>, thumbImage: <#T##Any!#>, images: <#T##Any!#>, type: <#T##SSDKContentType#>, forPlatformSubType: <#T##SSDKPlatformType#>)
        
        shareParams.ssdkSetupWeChatParams(byText: messaga.getContext(), title: messaga.title, url: messaga.getShareURL(), thumbImage: imgData, image: imgData, musicFileURL: messaga.getAudioURL(), extInfo: nil, fileData: nil, emoticonData: nil, type: messaga.type, forPlatformSubType: SSDKPlatformType.subTypeWechatSession);
        
        
        shareParams.ssdkSetupWeChatParams(byText: messaga.getContext(), title: messaga.title, url: messaga.getShareURL(), thumbImage: imgData, image: imgData, musicFileURL: messaga.getAudioURL(), extInfo: nil, fileData: nil, emoticonData: nil, type: messaga.type, forPlatformSubType: SSDKPlatformType.subTypeWechatTimeline);
        
        print("message = \(messaga.description)");
        
        ShareSDK.share(messaga.shareType, parameters: shareParams) { (responseState, params, contenEntity, error) in

            if responseState.rawValue != 0 {
                finished(responseState == SSDKResponseState.success, error as NSError?);
            }
        }
        
    }
    
}


class ShareMessage: NSObject {
    
    fileprivate var title = "";
    private var context = "";
    fileprivate var imageUrl = "http://www.yaoyu-soft.com";
    var shareURL = "http://www.yaoyu-soft.com";
    fileprivate var audioURL: String?;
    var shareImage: UIImage!
    
    var type: SSDKContentType = .auto;
    
    var shareType = SSDKPlatformType.typeSinaWeibo;
    
    
    override var description: String {
        return "\n title = \(title) \n context = \(context) \n imageURL = \(imageUrl) \n shareURL = \(shareURL) \n audioURL = \(audioURL) \n type = \(type.rawValue) \n shareType = \(shareType.rawValue)";
    }
    
    

    
    
    func getContext() -> String {
        if context.characters.count > 100 {
            let nsStrl = NSString(string: context);
            return nsStrl.substring(to: 99);
        }
        
        return context;
    }
    
    
    fileprivate override init() {
        super.init();
    }
    
    class func createMessage(title: String,content: String,img: UIImage,url: String) -> ShareMessage{
        let mesage = ShareMessage();
        mesage.title = title;
        mesage.context = content;
        mesage.shareImage = img;
        mesage.type = .image;
        
        if url.hasPrefix("http://") == true {
            mesage.shareURL = url;
        }else if url.characters.count > 3 {
        }
        return mesage;
    }
    
    class func createMessage(_ title: String,content: String,imageURL: String = "",url: String = "") -> ShareMessage {
        let mesage = ShareMessage();
        mesage.title = title;
        mesage.context = content;
        if imageURL.hasPrefix("http://") == true {
            mesage.imageUrl = imageURL;
        }
        if url.hasPrefix("http://") == true {
            mesage.shareURL = url;
        }else if url.count > 3 {
        }
        return mesage;
    }
    
    

    
    
    
    func getImageData() -> AnyObject {
        
        
        if shareImage != nil {
            return shareImage!;
        }
        if self.shareType != .typeSinaWeibo {
            return self.imageUrl as AnyObject;
        }
        let imageData = SDImageCache.shared().imageFromDiskCache(forKey: imageUrl);
        if imageData != nil {
            return imageData!;
        }
        return UIImage()
    }
    
    
    
    
    
    func getAudioURL() -> URL? {
        if audioURL?.hasPrefix("http://") == true {
            return URL(string: audioURL!)!;
        }
        return nil;
    }
    
    func getImgURL() -> URL? {
        return URL(string: imageUrl);
    }
    
    func getShareURL() -> URL {
        if let urls = URL(string: shareURL) {
            return urls;
        }
        
        return URL(string: "http://www.yaoyu-soft.com")!;
    }
    
}


extension ShareSDKManager {
    
   class func InstallShareSDK() {
        
        
        ShareSDK.registerApp(shareKey,
                             
                             activePlatforms: [SSDKPlatformType.typeSinaWeibo.rawValue,
                                               SSDKPlatformType.typeQQ.rawValue,
                                               SSDKPlatformType.subTypeQZone.rawValue,
                                               SSDKPlatformType.typeWechat.rawValue,],
                             onImport: {(platform : SSDKPlatformType) -> Void in
                                
                                switch platform{
                                    
                                case SSDKPlatformType.typeWechat:
                                    ShareSDKConnector.connectWeChat(WXApi.classForCoder())
                                    
                                case SSDKPlatformType.typeQQ:
                                    ShareSDKConnector.connectQQ(QQApiInterface.classForCoder(), tencentOAuthClass: TencentOAuth.classForCoder())
                                default:
                                    break
                                }
        },
                             onConfiguration: {(platform : SSDKPlatformType,appInfo : Any!) -> Void in
                                switch platform {
                                    
                                case SSDKPlatformType.typeSinaWeibo:
                                    //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                                    (appInfo as AnyObject).ssdkSetupSinaWeibo(byAppKey: sinaKey,
                                                                              appSecret : sinAppSecret,
                                                                              redirectUri : sinaURL,
                                                                              authType : SSDKAuthTypeBoth)
                                    break
                                    
                                case SSDKPlatformType.typeWechat:
                                    //设置微信应用信息
                                    (appInfo as AnyObject).ssdkSetupWeChat(byAppId: wxKey, appSecret: wxAppSecret)
                                    break
                                    
                                case SSDKPlatformType.typeQQ:
                                    //                                    //设置腾讯微博应用信息，其中authType设置为只用Web形式授权
                                    (appInfo as AnyObject).ssdkSetupQQ(byAppId: qqKey, appKey: qqAppSecret, authType: qqURL);
                                    //                                    appInfo.SSDKSetupTencentWeiboByAppKey("801307650",
                                    //                                        appSecret : "ae36f4ee3946e1cbb98d6965b0b2ff5c",
                                    //                                        redirectUri : "http://www.sharesdk.cn")
                                    break
                                case SSDKPlatformType.subTypeQZone:
                                    
                                    (appInfo as AnyObject).ssdkSetupQQ(byAppId: qqKey, appKey: qqAppSecret, authType: qqURL);
                                    
                                    //设置Facebook应用信息，其中authType设置为只用SSO形式授权
                                    //                                    appInfo.SSDKSetupFacebookByAppKey("107704292745179",
                                    //                                        appSecret : "38053202e1a5fe26c80c753071f0b573",
                                    //                                        authType : SSDKAuthTypeBoth)
                                    break
                                default:
                                    break
                                    
                                }
        })
        
        
        
    }
    
}

