//
//  FunViewController.swift
//  StudyApp
//


import UIKit

class FunViewController: WMPageController {

    var listModel: [CatogeryModel]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        
        loadDataFromNet(net:false);
    }
    
    
    func loadDataFromNet(net: Bool) {
        let request = UserRequest(pathType: .allApp);
        request.cls = CatogeryModel.classForCoder();
        request.loadJsonStringFinished { (result, success) in
            guard let model = result as? BaseModel else{
                return;
            }
            self.listModel = model.baseDataList as? [CatogeryModel];
            self.reloadDataByModel()
        }
    }
    
    
    func reloadDataByModel() -> Void {
        
        var ts = [String]();
        var ks = [String]();
        var vs = [Int]();
        var cls = [AnyClass]();
        var widths = [CGFloat]();

        for item in listModel {
            ts.append(item.name);
            ks.append("id");
            widths.append(item.width);
            vs.append(item.id);
            cls.append(ForFuncViewController.classForCoder());
        }
        self.keys = ks;
        self.values = vs;
        self.titles = ts;
        self.viewControllerClasses = cls;
        self.selectIndex = 0;
        self.itemsWidths = widths;
        self.reloadData();
    }

    

}
