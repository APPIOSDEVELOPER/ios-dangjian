//
//  ChartWebView.swift
//  StudyApp
//
//  Created by yaojinhai on 2018/1/12.
//  Copyright © 2018年 yaojinhai. All rights reserved.
//

import UIKit
import WebKit
import JavaScriptCore
class ChartWebView: BaseView,WKNavigationDelegate {

    var contentView: WKWebView!
    
    let paratemter = NSMutableDictionary();
    
    
    override func initView() {
        
        configDict();
        
        let config = WKWebViewConfiguration();
        let jsCode = WKUserContentController();
        
        let javaScriptPath = Bundle.main.path(forResource: "javaScript", ofType: "")!;
        let jsStrl = try! String.init(contentsOfFile: javaScriptPath);
        
        let scipt = WKUserScript(source: jsStrl, injectionTime: .atDocumentStart, forMainFrameOnly: true);
        
        jsCode.addUserScript(scipt);
        config.userContentController = jsCode;
        contentView = WKWebView.init(frame: bounds, configuration: config);
        addSubview(contentView);
        contentView.navigationDelegate = self;
        
        contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight];
        
        let path = Bundle.main.url(forResource: "ChartsLine", withExtension: "html");
        contentView.load(URLRequest(url: path!));
    }
    
    func configDict() -> Void {
        paratemter["color"] = [0x3398DB];
        paratemter["tooltip"] = ["trigger":"axis","axisPointer":["type":"shadow"]];
        paratemter["grid"] = ["left":"3%","right":"4%","bottom":"3%","containLabel":true];
        paratemter["xAxis"] = [["type":"category","data":["新奇","日本","韩国","美国","大众化","何浪","添加"],"axisTick":["alignWithLabel":true]]];
        paratemter["yAxis"] = [["type":"value"]];
        paratemter["series"] = [["name":"直接访问","type":"bar","barWidth":"60%","data":[89,76,133,200,300,400,500]]];
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {



        webView.evaluateJavaScript("exeResult()") { (obj, error) in
            
            print("objc \(String(describing: obj)),,,error = \(error.debugDescription)");
            
        }

        
    }

}
