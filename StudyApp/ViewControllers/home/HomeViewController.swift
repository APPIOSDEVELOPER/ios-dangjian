//
//  HomeViewController.swift
//  StudyApp
//

import UIKit
import SnapKit
import MediaPlayer

class HomeViewController: WMPageController {

    
    var titleModelList: [CatogeryModel]!;
    var catorgList: [NewsCatogeryCodable]!
    
    var isFirstAppear = true;
    
    var exeSupdidView = false;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false;
        
        self.viewFrame = CGRect(x: 0, y: 0, width: width(), height: sHeight-0-40);
        
        self.pageAnimatable = true;
        self.menuItemWidth = 75;
        self.menuHeight = 40;
        self._viewY = 64;
        self.titleSizeNormal = 18;
        self.titleSizeSelected = 18;
        
        
        self.bounces = true;
        
        setNeedsStatusBarAppearanceUpdate();
        
        
        netHttpRequest();

    }
    
    override func viewWillLayoutSubviews() {
        if exeSupdidView {
            super.viewWillLayoutSubviews();
        }
    }
    override func viewDidLayoutSubviews() {
        
        if exeSupdidView {
            exeSupdidView = false;
            super.viewDidLayoutSubviews();
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
        if isFirstAppear {
            isFirstAppear = false;
        }else{
            netHttpRequest();
        }
    }
    
    func netHttpRequest() -> Void {

        if self.titleModelList != nil && self.titleModelList.count > 0 {
            return;
        }
        
        let request = UserRequest(pathType: .homeData);
        request.cls = CatogeryModel.classForCoder();
        request.loadJsonStringFinished { (result, success) in

            guard let model = result as? BaseModel else{
                return;
            }
            self.exeSupdidView = true;
            self.titleModelList = model.baseDataList as! [CatogeryModel];
            self.reloadDataByModel();
        };
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        testCode();
        
    }
    
    func reloadDataByModel() -> Void {
        

        var ts = [String]();
        var ks = [[String]]();
        var vs = [Any]();
        var cls = [AnyClass]();
        var widths = [CGFloat]();
        for item in self.titleModelList {
            ts.append(item.name);
            widths.append(item.width);
//            ks.append("id");
//            vs.append(item.id);
//            ks.append("textTitle");
//            vs.append(item.name);
            ks.append(["id","textTitle"]);
            vs.append([item.id,item.name]);
            cls.append(HomeContentViewController.classForCoder());
        }
        self.titles = ts;
        self.viewControllerClasses = cls;
        self.keys = ks;
        self.values = vs;
        self.selectIndex = 0;
        self.itemsWidths = widths;

        self.reloadData();
        
        
    }
    
    func testCode() {
        
       
        
    }

   
}

