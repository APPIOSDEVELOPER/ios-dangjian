//
//  CustomWebView.swift
//  CathAssist
//
//  Created by yaojinhai on 2017/12/26.
//  Copyright © 2017年 CathAssist. All rights reserved.
//

import UIKit
import WebKit
import JavaScriptCore
class CustomWebView: WKWebView,WKNavigationDelegate {
    
    var contentBody = "";
    

    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration);
        scrollView.keyboardDismissMode = .onDrag;
        self.navigationDelegate = self;
        autoresizingMask = [.flexibleWidth,.flexibleHeight];
        if #available(iOS 9.0, *) {
            allowsLinkPreview = true
        } else {
            // Fallback on earlier versions
        };
//        allowsBackForwardNavigationGestures = true;
        
//        addObserver(self, forKeyPath: "title", options: .new, context: nil);
        
        
//        addObserver(self, forKeyPath: "estimatedProgress", options: [.new], context: nil);
//        let types = WKWebsiteDataStore.allWebsiteDataTypes();
//        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: types) { (recorder) in
//            for item in recorder{
//                print("item count = \(item.displayName),set = \(item.dataTypes)")
//            }
//        };
        
    }
    
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard let newKeyPath = keyPath else {
            return;
        }
        
        switch newKeyPath {
        case "estimatedProgress":
            guard  let progress = change![.newKey] as? Double else{
                return;
            }
            
            SVProgressHUD.sharedView().hudStatusShadowColor = UIColor.black.withAlphaComponent(0.8);
            SVProgressHUD.sharedView().hudBackgroundColor = UIColor.lightGray;
            SVProgressHUD.showProgress(Float(progress));
            if progress >= 1{
                SVProgressHUD.dismiss();
            }
            
//        case "isLoading":
//            guard  let loading = change![.newKey] as? Bool else{
//                return;
//            }
//            let loading = change![.newKey] as? Bool
//            print("is loading \(loading)");
            
            
        default:
            break;
        }
    }

    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func createWebView(frame: CGRect) -> CustomWebView {
        
        let config = WKWebViewConfiguration();
        
        if #available(iOS 10.0, *) {
            config.dataDetectorTypes = .all
            config.allowsAirPlayForMediaPlayback = true;
            config.allowsPictureInPictureMediaPlayback = true;
            config.userContentController = WKUserContentController();
            config.preferences = WKPreferences();
            config.preferences.javaScriptEnabled = true;
        
        }

        let baseWebView = CustomWebView(frame: frame, configuration: config);
        
        return baseWebView;
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        SVProgressHUD.show(withStatus: "正在加载");
    }
    
    
    func regexResult(strl: String) -> Void {
        
        let regex = try? NSRegularExpression(pattern: "(>[^<>/]*)", options: .useUnicodeWordBoundaries);
        
        guard let resuls = regex?.matches(in: strl, options: .withoutAnchoringBounds, range: NSRange.init(location: 0, length: strl.count)) else{
            return;
        }
        
        for item in resuls {
            let range = item.range;
            let subRange = strl.index(strl.startIndex, offsetBy: range.lowerBound)..<strl.index(strl.startIndex, offsetBy: range.upperBound);
            
            let rangeStrl = strl[subRange];
            contentBody += String(rangeStrl);
            if contentBody.count > 60 {
                break;
            }
        }
        contentBody = contentBody.replacingOccurrences(of: ">|\\s", with: "", options: String.CompareOptions.regularExpression, range: contentBody.startIndex..<contentBody.endIndex);
        

        print("contentaed = \(contentBody)")
    }
    
    // MARK: navigation delegate implement
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        SVProgressHUD.dismiss();

        
        let jsText = "document.body.innerHTML"//"document.documentElement.innerHTML";
        webView.evaluateJavaScript(jsText) { (result, error) in
            guard let strl = result as? String else{
                return;
            }
            self.regexResult(strl: strl);
        }
        
        
//        print("did finished obj =");
        
//        let jsContext = webView.value(forKey: "documentView.webView.mainFrame.javaScriptContext") as? JSContext;
//        print("js contesxt = \(jsContext)")
        
        
//        guard let context = webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext else {
//            return;
//        }
        

//       let funcStrl =  """
//        function changeText(size){try{var document.body.style.fontSize=size+"px";}catch(e){}}
//        """;
//        print("func strl = \(funcStrl)");
        
//        context.evaluateScript(funcStrl);
//        let jsValueFunc = context.evaluateScript("changeText");
//        jsValueFunc?.call(withArguments: [100]);
        
//        return;
       
        
//        let fontSize = customFontSize(false).pointSize;
//        let font = "document.body.style.fontSize=\(fontSize);"
//        webView.evaluateJavaScript(font) { (obj, error) in
//
//        }
//        
//        let injectionJSString = "var script = document.createElement('meta');script.name = 'viewport';script.content=\"width=device-width, initial-scale=1.0,maximum-scale=5.0, minimum-scale=1.0, user-scalable=yes\";document.getElementsByTagName('head')[0].appendChild(script);";
//        webView.evaluateJavaScript(injectionJSString) { (obj, error) in
//
//        }
        
    }
    
    deinit {
        print("self deinit = \(self)");
//        removeObserver(self, forKeyPath: "isLoading")
//        removeObserver(self, forKeyPath: "estimatedProgress");
    }
    
}
