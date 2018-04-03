//
//  BaseModel.swift
//  CathAssist
//
//  Created by yaojinhai on 2017/7/22.
//  Copyright © 2017年 CathAssist. All rights reserved.
//

import UIKit

enum ResultCodeType: Int {
    case success = 200
}

class BaseModel: NSObject {
    
    @objc var result_msg = "";
    @objc var result_code = 0;
    var isSuccess: Bool {
        return result_code == ResultCodeType.success.rawValue;
    }
    
    private var anyCls: AnyClass!
    
    var baseDataModel: BaseModel!
    var baseDataList: [BaseModel]!

    override init() {
        super.init();

    }
    convenience init(dict: [String:Any]){
        self.init();
        configModel(dict: dict);
        setData();
    }
    
    class func createModel(dict: NSDictionary) -> BaseModel {
        let model = BaseModel();
        model.result_msg = dict["result_msg"] as! String;
        if let code = dict["result_code"] as? Int{
            model.result_code = code;
        }else if let code = dict["result_code"] as? String{
            model.result_code = Int(code)!;
        }
        
        return model;
    }
    
    convenience init(anyCls: AnyClass,dict: NSDictionary){
        self.init();
        self.anyCls = anyCls;
        configModel(dict: dict as! [String : Any]);
        setData();
    }
    required convenience init(dictM: NSDictionary){
        self.init(dict: dictM as! [String : Any]);
        
    }
    
    required convenience init(anyData: Any) {
        self.init(dict: anyData as! [String:Any]);
    }
    
    func setData() -> Void {
        
    }

    
    
    
    func configModel(dict: [String:Any]) -> Void {
        self.setValuesForKeys(dict);
        
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        switch key {
        case "result":
            guard let dataItem = anyCls as? BaseModel.Type else {
                return;
            }
            
            if let list = value as? NSArray {
                baseDataList = [BaseModel]();
                for item in list {
                    let model = dataItem.init(anyData: item);
                    baseDataList.append(model);
                }
            }else if let dict = value as? NSDictionary {
                baseDataModel = dataItem.init(dictM: dict);
            }
            
            
        default:
            if value != nil {
                super.setValue(value, forKey: key);
            }
        }
    }
    

    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
//        printObject("class = \(self.classForCoder): \n key = \(key) ,value = \(String(describing: value))");
    }
}
