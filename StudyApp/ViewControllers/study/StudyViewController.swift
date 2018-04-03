//
//  StudyViewController.swift
//  StudyApp
//


import UIKit

class StudyViewController: WMPageController {
    

    var titleCategoryList: [CatogeryModel]!;
    
    var isFirstAppear = true;
    
    var exeSupdidView = false;
    
    override func viewDidLoad() {
        self.automaticallyAdjustsScrollViewInsets = false;
        
        self.viewFrame = CGRect(x: 0, y: 0, width: width(), height: sHeight-0-40);
        
        self.pageAnimatable = true;
        self.menuItemWidth = 75;
        self.menuHeight = 40;
        self._viewY = 64;
        self.titleSizeSelected = 18;
        self.titleSizeNormal = 18;
        
        self.bounces = true;
        
        setNeedsStatusBarAppearanceUpdate();
        
        super.viewDidLoad();
        
        loadCategory();
        
//        reloadDataByModel();
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        if isFirstAppear {
            isFirstAppear = false;
        }else{
            loadCategory();

        }
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
    
    
    func reloadDataByModel() -> Void {
        
        
        var ts = [String]();
        var ks = [[String]]();
        var vs = [[Any]]();
        var cls = [AnyClass]();
        var widths = [CGFloat]();
        
        for item in self.titleCategoryList {
            ts.append(item.name);
            ks.append(["id","subTitle"]);
            vs.append([item.id,item.name]);
            cls.append(StudyListViewController.classForCoder());
            widths.append(item.width);
        }
        self.titles = ts;
        self.viewControllerClasses = cls;
        self.keys = ks;
        self.values = vs;
        self.selectIndex = 0;
        self.itemsWidths = widths;
        self.exeSupdidView = true;
        self.reloadData();
        
        
    }
    
    func loadCategory() -> Void {
        
        if titleCategoryList != nil && titleCategoryList.count > 0 {
            return;
        }
        
        let request = UserRequest(pathType: .vedioCatogery);
        request.cls = CatogeryModel.classForCoder();
        request.loadJsonStringFinished { (result, success) in
            guard let model = result as? BaseModel else{
                return;
            }
            self.titleCategoryList = model.baseDataList as? [CatogeryModel];
            self.reloadDataByModel();
        };
        
    }
    
    
    
}

