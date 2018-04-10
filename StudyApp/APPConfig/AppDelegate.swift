//
//  AppDelegate.swift
//  StudyApp
//
//  Created by yaojinhai on 2017/4/11.
//  Copyright © 2017年 yaojinhai. All rights reserved.
//

import UIKit
import CoreData


import UserNotifications



//var tabbarCtrl: YyTabBarViewController!
var navigateCtrl: UINavigationController!
var tabbarCtrl: YyTabBarViewController!

let mainColor = rgbColor(r: 54, g: 68, b: 91);

let appMainDelegate = UIApplication.shared.delegate as? AppDelegate;

@UIApplicationMain
//// 放开 JPUSHRegisterDelegate 加上 jpush 代理
class AppDelegate: UIResponder, UIApplicationDelegate ,UITabBarControllerDelegate,UNUserNotificationCenterDelegate{

    var window: UIWindow?
    
//    var welCtrl: WelcomViewController!
    
    // 更新提示
    
    var searchItem: UIBarButtonItem!
//    var addItem: UIBarButtonItem!
//    var messgeItem: UIBarButtonItem!
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       
        initXGPush(launchOptions: launchOptions);
        ShareSDKManager.InstallShareSDK();
        installNotification();
//        initKedaYuYin();
        

        installUmen();
//        UserModel.saveToken(token: nil);
        
        addJPush(lauchOption: launchOptions);
        
        UIApplication.shared.applicationIconBadgeNumber = 0;

//        UIApplication.shared.setStatusBarOrientation(.landscapeLeft, animated: false);
        
//        UIApplication.shared.statusBarStyle = .lightContent;
        
        
        let nabar = UINavigationBar.appearance();
        nabar.barTintColor = rgbColor(r: 204, g: 16, b: 24);
        nabar.tintColor = UIColor.white;
        nabar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white,NSAttributedStringKey.font:fontBlod(size: 20)];
        nabar.setBackgroundImage(UIImage(), for: .any, barMetrics: .compactPrompt);
//        nabar.clipsToBounds = true;
        nabar.shadowImage = UIImage();
    
        nabar.contentScaleFactor = iOSIPhoneInfoData.scale;
        
        
        window = UIWindow(frame: sBound);
        window?.backgroundColor = UIColor.white;
        
        tabbarCtrl = YyTabBarViewController();
        tabbarCtrl.delegate = self;
        tabbarCtrl.tabBar.addObserver(self, forKeyPath: "selectedIndex", options: .new, context: nil);
//        let homeCtrl = HomeViewController();
        
        navigateCtrl = UINavigationController(rootViewController: tabbarCtrl);
        
        UserDefaults.standard.set(false, forKey: "login_app");

        
        setAccountType();
        window?.makeKeyAndVisible();

        
        if let options = launchOptions {
            resverUserInfo(userInfo: options);

        }
        
        NotificationCenter.add(observer: self, selector: #selector(notificationAction(_:)), name: BANotificationName.tabbarIndexChange);
        
//        if #available(iOS 10.0, *) {
////            notificationLoaction()
//            configSpeech();
//        } else {
//            // Fallback on earlier versions
//        };
        
        
//        let request = UserRequest(listening: 15, answers: "hello", part: 3);
//        request.loadJsonStringFinished({ (result, code, success) in
//            
//            printObject("result = \(result)");
//        });
////
        return true;
        
    }
    
    @objc func notificationAction(_ notification: NSNotification) -> Void {
        
        
        navigateCtrl.navigationBar.topItem?.title = "用户设置";
        

    }

    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let path = keyPath , let valueDict = change else {
            return;
        }
        switch path {
        case "selectedIndex":
            let index = valueDict[NSKeyValueChangeKey.newKey] as! Int ;

            
            break;
        default:
            break;
        }
    }
    
    
    func autoUpdateIcon() -> Void {
        if #available(iOS 10.3, *) {
            let suport = UIApplication.shared.supportsAlternateIcons
        } else {
            // Fallback on earlier versions
        };
    }
    

   
    
    
    func initXGPush(launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Void {
        
        XGPush.startApp(2200267604, appKey: "I424S9MM6MZF");
        XGPush.isPush { (isPushOn) in
            printObject("is push on = \(isPushOn)");
        }
        let log = XGSetting.getInstance() as? XGSetting;
        log?.enableDebug(true);
        if launchOptions == nil {
            return;
        }
        XGPush.handleLaunching(launchOptions!, successCallback: { 
            
        }) { 
            
        };
    }
    
    func setAccountType() -> Void {

        
        
        
        navigateCtrl.navigationBar.topItem?.title = "党建";
        
        
        let itemSelector = #selector(enterMineCtrl(_:));
//
//        searchItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: itemSelector);
        searchItem = UIBarButtonItem(image: #imageLiteral(resourceName: "search_icon.png"), style: .plain, target: self, action: itemSelector);
        searchItem.tag = ViewTagSense.searchTag.rawValue;
        navigateCtrl.navigationBar.topItem?.leftBarButtonItem = searchItem;
        
//        addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: itemSelector);
//        addItem.tag = ViewTagSense.addTag.rawValue;
        navigateCtrl.navigationBar.topItem?.rightBarButtonItem = nil;

        let isFirstExe = UserDefaults.standard.bool(forKey: "is_first_exe");
        if !isFirstExe {
            UserDefaults.standard.set(true, forKey: "is_first_exe");
            
            let welCtrl = WelcomViewController();
            welCtrl.didExeFinished = {
                
                self.window?.rootViewController = navigateCtrl;
            }
            self.window?.rootViewController = welCtrl;

        }else{
            self.window?.rootViewController = navigateCtrl;
        }
        
        


        
//        let first = UserDefaults.standard.bool(forKey: "first_exe_app_location__ok");
//        if first == false {
//            UserDefaults.standard.set(true, forKey: "first_exe_app_location__ok");
//            welCtrl = WelcomViewController();
//            self.window?.rootViewController = welCtrl;
//            welCtrl.didExeFinished = {
//                self.window?.rootViewController = navigateCtrl;
//            }
//            navigateCtrl.present(welCtrl, animated: false, completion: {
//
//            });
//        }else {
//        }
        
        
        
    }
    
    @objc func enterMineCtrl(_ item: UIBarButtonItem)  {
        
        if item.tag == ViewTagSense.searchTag.rawValue {
            
            let ctrl = SearchViewController();
            navigateCtrl.pushViewController(ctrl, animated: true);
            
        }else if item.tag == ViewTagSense.addTag.rawValue {
            
            let navCtrl = tabbarCtrl.viewControllers?[0] as? UINavigationController;
            
            let homeCtrl = navCtrl!.topViewController as! HomeViewController;
            let ctrl = AddItemViewController();
            ctrl.finished = {
                (items) -> Void in
            }
            if let titles = homeCtrl.titles as? [String] {
                ctrl.dataSource.insert(titles, at: 0);
            }
            navigateCtrl.pushViewController(ctrl, animated: true);
            
        }else if item.tag == ViewTagSense.messageTag.rawValue {
            
            
            
            let ctrl = MsgListViewController();
            navigateCtrl.pushViewController(ctrl, animated: true);
        }
        
                
    }
    
    
    let segmentTitles = ["党建","互动广场","学习视频","大事记","用户设置"];
    
//    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//        let index = tabBarController.selectedIndex;
//        if index == 4 && !UserInfoModel.isLogin() {
//            return false;
//        }
//        return true;
//    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        
        navigateCtrl.navigationBar.topItem?.title = segmentTitles[tabBarController.selectedIndex];

        
        if tabBarController.selectedIndex == 4 {
            if !UserInfoModel.isLogin() {
                let ctrl = SettingViewController();
//                tabBarController.setViewControllers(<#T##viewControllers: [UIViewController]?##[UIViewController]?#>, animated: <#T##Bool#>)
                navigateCtrl.pushViewController(ctrl, animated: true);
                tabBarController.selectedIndex = 0;
                navigateCtrl.navigationBar.topItem?.title = "党建";

                return;
                
            }
        }
        
        
        switch tabBarController.selectedIndex {
        case 0:
            navigateCtrl.navigationBar.topItem?.leftBarButtonItem = searchItem;
            navigateCtrl.navigationBar.topItem?.rightBarButtonItem = nil;//addItem;
            
        case 4:
//            if messgeItem == nil {
//                messgeItem = UIBarButtonItem(image: #imageLiteral(resourceName: "message.png"), style: .plain, target: self, action: #selector(enterMineCtrl(_:)));
//                messgeItem.tag = ViewTagSense.messageTag.rawValue;
//            }
            navigateCtrl.navigationBar.topItem?.leftBarButtonItem = nil;
            navigateCtrl.navigationBar.topItem?.rightBarButtonItem = nil;
        default:
            navigateCtrl.navigationBar.topItem?.leftBarButtonItem = nil;
            navigateCtrl.navigationBar.topItem?.rightBarButtonItem = nil;
        }
        
        if tabBarController.selectedIndex == 0 {
            
        }else if tabBarController.selectedIndex == 4{
            
        }
        
//        UIView.animate(withDuration: 0.2) {
//            
//            var rect = tabbarCtrl.lineView.frame;
//            rect.origin.x = CGFloat(tabBarController.selectedIndex) * perWidth + (perWidth - 24) / 2;
//            tabbarCtrl.lineView.frame = rect;
//        }
        
//        var rect = tabbarCtrl.lineView.frame;
//        rect.origin.x = CGFloat(tabBarController.selectedIndex) * perWidth + (perWidth - 24) / 2;
//        tabbarCtrl.lineView.frame = rect;
        
        
        
    }
    
    
    // MARK: - 初始化 友盟
    
    func installUmen()  {
        
        UMConfigure.initWithAppkey(umengKey, channel: "App Store");
        UMConfigure.setLogEnabled(true);
        MobClick.setScenarioType(.E_UM_NORMAL);
        
        
        
//        UMSocialManager.default().openLog(true);
//        UMSocialManager.default().umSocialAppkey = umengKey;
//
//        UMSocialManager.default().setPlaform(.wechatSession, appKey: wxKey, appSecret: wxAppSecret, redirectURL: wxURL);
//
//        UMAnalyticsConfig.sharedInstance().appKey = umengKey;
//        UMAnalyticsConfig.sharedInstance().secret = "";
//        UMAnalyticsConfig.sharedInstance().channelId = "App Store";
//        MobClick.start(withConfigure: UMAnalyticsConfig.sharedInstance());
//
//        UMSocialManager.default().setPlaform(.QQ, appKey: qqKey, appSecret: qqAppSecret, redirectURL: qqURL);
//
//        UMSocialManager.default().setPlaform(.tencentWb, appKey: qqKey, appSecret: qqAppSecret, redirectURL: qqURL);
//
//        UMSocialManager.default().setPlaform(.qzone, appKey: wxKey, appSecret: wxAppSecret, redirectURL: wxURL);
        
        
//        UMSocialManager.default().setPlaform(.sina, appKey: sinaKey, appSecret: sinAppSecret, redirectURL: sinaURL);
        
    }
    // MARK: - 科大语音 初始化
    func initKedaYuYin() -> Void {
        
        IFlySetting.setLogFile(.LVL_ALL);
        IFlySetting.showLogcat(true);
        let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first;
        IFlySetting.setLogFilePath(path!);
        
        IFlySpeechUtility.createUtility("appid=" + kdxfAppid);
    }
    
    
    
    // MARK: - register user notification
    
    func installNotification()  {
        
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate = self;
            center.requestAuthorization(options: [.badge,.alert,.sound], completionHandler: { (success, error) in
//                center.getNotificationSettings(completionHandler: { (settings) in
//                    
//                })
            });
        } else {
            // Fallback on earlier versions
//            let type = UIUserNotificationType.badge.union(.sound).union(.alert);
//            let setting = UIUserNotificationSettings(types: type, categories: nil);
//            UIApplication.shared.registerUserNotificationSettings(setting);
        };
        
        
        let type = UIUserNotificationType.badge.union(.sound).union(.alert);
        let setting = UIUserNotificationSettings(types: type, categories: nil);
        UIApplication.shared.registerUserNotificationSettings(setting);
        UIApplication.shared.registerForRemoteNotifications();
        
    }
    
    // MARK: - 初始化 分享
    
    func InstallShareSDK() {
        
        
//        ShareSDK.registerApp(shareKey,
//
//                             activePlatforms: [SSDKPlatformType.typeSinaWeibo.rawValue,
//                                               SSDKPlatformType.typeQQ.rawValue,
//                                               SSDKPlatformType.subTypeQZone.rawValue,
//                                               SSDKPlatformType.typeWechat.rawValue,],
//                             onImport: {(platform : SSDKPlatformType) -> Void in
//
//                                switch platform{
//
//                                case SSDKPlatformType.typeWechat:
//                                    ShareSDKConnector.connectWeChat(WXApi.classForCoder())
//
//                                case SSDKPlatformType.typeQQ:
//                                    ShareSDKConnector.connectQQ(QQApiInterface.classForCoder(), tencentOAuthClass: TencentOAuth.classForCoder())
//                                default:
//                                    break
//                                }
//        },
//                             onConfiguration: {(platform : SSDKPlatformType,appInfo : Any!) -> Void in
//                                switch platform {
//
//                                case SSDKPlatformType.typeSinaWeibo:
//                                    //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
//                                    (appInfo as AnyObject).ssdkSetupSinaWeibo(byAppKey: sinaKey,
//                                                                              appSecret : sinAppSecret,
//                                                                              redirectUri : sinaURL,
//                                                                              authType : SSDKAuthTypeBoth)
//                                    break
//
//                                case SSDKPlatformType.typeWechat:
//                                    //设置微信应用信息
//                                    (appInfo as AnyObject).ssdkSetupWeChat(byAppId: wxKey, appSecret: wxAppSecret)
//                                    break
//
//                                case SSDKPlatformType.typeQQ:
//                                    //                                    //设置腾讯微博应用信息，其中authType设置为只用Web形式授权
//                                    (appInfo as AnyObject).ssdkSetupQQ(byAppId: qqKey, appKey: qqAppSecret, authType: qqURL);
//                                    //                                    appInfo.SSDKSetupTencentWeiboByAppKey("801307650",
//                                    //                                        appSecret : "ae36f4ee3946e1cbb98d6965b0b2ff5c",
//                                    //                                        redirectUri : "http://www.sharesdk.cn")
//                                    break
//                                case SSDKPlatformType.subTypeQZone:
//
//                                    (appInfo as AnyObject).ssdkSetupQQ(byAppId: qqKey, appKey: qqAppSecret, authType: qqURL);
//
//                                    //设置Facebook应用信息，其中authType设置为只用SSO形式授权
//                                    //                                    appInfo.SSDKSetupFacebookByAppKey("107704292745179",
//                                    //                                        appSecret : "38053202e1a5fe26c80c753071f0b573",
//                                    //                                        authType : SSDKAuthTypeBoth)
//                                    break
//                                default:
//                                    break
//
//                                }
//        })
        
        
        
    }
    
    // MARK: - 语音
    
    @available(iOS 10.0, *)
    func configSpeech() -> Void {
//        let manger = SpeechManger();
//        manger.requestTask();
        
    }
    
    //MARK: - add jPush
    
    func addJPush(lauchOption: [AnyHashable:Any]?) -> Void {
        
        // JPUSHService 放开
        
//        JPUSHService.setup(withOption: lauchOption, appKey: jgKey, channel: "App Store", apsForProduction: jgProduct, advertisingIdentifier: nil);
    }
    
    //MARK: - jPush delegate
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        
        
        guard let trigger = response?.notification.request.trigger else {
            return;
        }
//        guard let userInfo = response?.notification.request.content.userInfo else {
//            return;
//        }
        if trigger.isKind(of: UNPushNotificationTrigger.classForCoder()){
            // 放开
//            JPUSHService.handleRemoteNotification(userInfo);
        }
        
        completionHandler();
        
    }
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        
//        guard let userInfo = notification?.request.content.userInfo else {
//            return;
//        }
        guard let trigger = notification.request.trigger else {
            return;
        }
        if trigger.isKind(of: UNPushNotificationTrigger.classForCoder()) {
            // 放开
//            JPUSHService.handleRemoteNotification(userInfo);
        }
        completionHandler(Int(UNNotificationPresentationOptions.alert.rawValue));
    }
    
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        defer{
            completionHandler();
        }
        
        XGPush.handleReceiveNotification(response.notification.request.content.userInfo, successCallback: {
            
        }) { 
            
        };
        
        let userInfo = response.notification.request.content.userInfo;
        
        resverUserInfo(userInfo: userInfo);
        
        
        guard let trigger = response.notification.request.trigger else{
            return;
        }
        if trigger.isKind(of: UNPushNotificationTrigger.classForCoder()){
            // 放开
//            JPUSHService.handleRemoteNotification(userInfo);
        }
        
        
    }
    
    
    // MARK: - 禁止 使用 第三方键盘
//    func application(_ application: UIApplication, shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplicationExtensionPointIdentifier) -> Bool {
//        return false;
//    }
    
    func resverUserInfo(userInfo: [AnyHashable : Any]) -> Void {
        guard let keyURl = userInfo["url"] as? String else {
            return;
        }

        
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo;
        
        guard let trigger = notification.request.trigger else {
            return;
        }
        if trigger.isKind(of: UNPushNotificationTrigger.classForCoder()) {
//            // 放开
//            JPUSHService.handleRemoteNotification(userInfo);
        }
        completionHandler(UNNotificationPresentationOptions.alert);
    }
    
    // MARK: - 本地通知
    @available(iOS 10.0, *)
    func notificationLoaction() -> Void {
        
        UIApplication.shared.applicationIconBadgeNumber = 0;
        
        let conter = UNUserNotificationCenter.current();
        conter.requestAuthorization(options: [.alert,.badge,.sound]) { (success, error) in
            
            print(success);
        };
        
        
        
        let triger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: false);
        
//        var componse = DateComponents();
//        componse.weekday = 1;
//        componse.hour = 8;
//        let trigger2 = UNCalendarNotificationTrigger(dateMatching: componse, repeats: false);
        
        let content = UNMutableNotificationContent();
        content.body = "body";
        content.title = "title";
        content.subtitle = "subtitle";
        content.badge = 1;
        content.sound = UNNotificationSound.default();
        
        let actin = UNNotificationAction(identifier: "2", title: "title", options: .destructive);
        
        let input = UNTextInputNotificationAction(identifier: "e", title: "pass word", options: [.foreground], textInputButtonTitle: "确定", textInputPlaceholder: "请回复");
        
        let cator = UNNotificationCategory(identifier: "3", actions: [actin,input], intentIdentifiers: ["7"], options: .customDismissAction);
        
        content.categoryIdentifier = "3";
        
        let request = UNNotificationRequest(identifier: "FiveSecond", content: content, trigger: triger);
        
        var set = Set<UNNotificationCategory>();
        set.insert(cator);
        
        
        UNUserNotificationCenter.current().setNotificationCategories(set);
        
        UNUserNotificationCenter.current().add(request) { (error) in
            
            print("\(String(describing: error))");
        };
        
        
        
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
        XGPush.handleReceiveNotification(userInfo, successCallback: {
            
        }) {
            
        };
        // 放开
        
//        JPUSHService.handleRemoteNotification(userInfo);
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        XGPush.handleReceiveNotification(userInfo, successCallback: { 
            
        }) { 
            
        };
        // 放开
        
//        JPUSHService.handleRemoteNotification(userInfo);
        completionHandler(.newData);
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {

        var result = false;
        if !result {
            // 其他如支付等SDK的回调
           result = IFlySpeechUtility.getUtility().handleOpen(url);
        }
        return result;
        
    }
    
    // MARK: - token update
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let strl = deviceToken.description;
        
        let deviceStrl = NSData(data: deviceToken).description;
        
        
        
        
        
        XGPush.registerDevice(deviceToken, successCallback: { 
            
        }) { 
            
        };
        // 放开
//        JPUSHService.registerDeviceToken(deviceToken);
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
    }
    
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        return true;
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let result = false
        if !result {
            print("其他的应用回调");
        }
        return result;
        

    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }


}



