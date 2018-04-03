//
//  YyTabBarViewController.swift
//  StudyApp
//
//  Created by yaojinhai on 2017/4/13.
//  Copyright © 2017年 yaojinhai. All rights reserved.
//

import UIKit

class YyTabBarViewController: UITabBarController {

    
    var titleImage = [Int: [String:String]]();
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        

        for idx in 0...4 {
            titleImage[idx] = ["sl":"tabbar_\(idx)","de":"tabbar_seleted_\(idx)"];
        }
        
        setUp();
        
        let backItem = UIBarButtonItem();
        backItem.title = "";
        self.navigationItem.backBarButtonItem = backItem;
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setUp() {
        
        let normalFont = fontSize(size: 15);
        
        
        // 首页
        let homeCtrl = HomeViewController();
        
        let image = UIImage(named: titleImage[0]!["de"]!)?.withRenderingMode(.alwaysOriginal);
        let slImage = UIImage(named: titleImage[0]!["sl"]!)?.withRenderingMode(.alwaysOriginal);
        
        let shouyeItem = UITabBarItem(title: "首页", image:image , selectedImage: slImage);
        shouyeItem.setTitleTextAttributes([NSAttributedStringKey.font:normalFont], for: .normal);
        shouyeItem.setTitleTextAttributes([NSAttributedStringKey.font:normalFont], for: .selected);
        
        homeCtrl.tabBarItem = shouyeItem;
        
        
        
        // 第二
        let allCtrl = PartActionViewController();
        let appImage = UIImage(named: titleImage[1]!["de"]!)?.withRenderingMode(.alwaysOriginal);
        let slappImage = UIImage(named: titleImage[1]!["sl"]!)?.withRenderingMode(.alwaysOriginal);

        let hudongItem = UITabBarItem(title: "互动", image:appImage , selectedImage: slappImage);
        hudongItem.setTitleTextAttributes([NSAttributedStringKey.font:normalFont], for: .normal);
        hudongItem.setTitleTextAttributes([NSAttributedStringKey.font:normalFont], for: .selected);
        allCtrl.tabBarItem = hudongItem;
        
        // add view control
        let addCtrl = StudyViewController();
//        addCtrl.tabBarItem = UITabBarItem(title: "", image: nil, selectedImage: nil);
        let third = UIImage(named:titleImage[2]!["de"]!)?.withRenderingMode(.alwaysOriginal);
        let thirdsle = UIImage(named:titleImage[2]!["sl"]!)?.withRenderingMode(.alwaysOriginal);
        let studyBarItem = UITabBarItem(title: "学习", image: third, selectedImage: thirdsle);
        studyBarItem.setTitleTextAttributes([NSAttributedStringKey.font:normalFont], for: .normal);
        studyBarItem.setTitleTextAttributes([NSAttributedStringKey.font:normalFont], for: .selected);
        addCtrl.tabBarItem = studyBarItem;
        
        
        // SPEC
        let spec = HistoryViewController()//PartyManagerViewController();
        let specImage = UIImage(named:titleImage[3]!["de"]!)?.withRenderingMode(.alwaysOriginal);
        let selectSpecImage = UIImage(named:titleImage[3]!["sl"]!)?.withRenderingMode(.alwaysOriginal);
        
        let historyItem = UITabBarItem(title: "事记", image: specImage, selectedImage: selectSpecImage);
        historyItem.setTitleTextAttributes([NSAttributedStringKey.font:normalFont], for: .normal);
        historyItem.setTitleTextAttributes([NSAttributedStringKey.font:normalFont], for: .selected);
        spec.tabBarItem = historyItem;
        
        // 我的
        let myCtrl = MineViewController();
        let myImage = UIImage(named: titleImage[4]!["de"]!)?.withRenderingMode(.alwaysOriginal)
        let slmyImage = UIImage(named: titleImage[4]!["sl"]!)?.withRenderingMode(.alwaysOriginal);
        
        let mineTtem = UITabBarItem(title: "我的", image: myImage, selectedImage: slmyImage);
        mineTtem.setTitleTextAttributes([NSAttributedStringKey.font:normalFont], for: .normal);
        mineTtem.setTitleTextAttributes([NSAttributedStringKey.font:normalFont], for: .selected);

        myCtrl.tabBarItem = mineTtem;
        
        let homeNavi = UINavigationController(rootViewController: homeCtrl);
        let secondNavi = UINavigationController(rootViewController: addCtrl);
        
        
        self.viewControllers = [homeNavi,allCtrl,secondNavi,spec,myCtrl];

        tabBar.barTintColor = UIColor.white;
        tabBar.tintColor = rgbColor(r: 211, g: 69, b: 68);
        
        


        

    }
    
   
    
    

}
