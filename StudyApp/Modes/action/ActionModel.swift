//
//  ActionModel.swift
//  StudyApp
//
//  Created by yaojinhai on 2018/1/22.
//  Copyright © 2018年 yaojinhai. All rights reserved.
//

import UIKit

class ActionModel: BaseModel {
    
    var modelList: [ActionInfoModel]!;
    
    override func setValue(_ value: Any?, forKey key: String) {
        switch key {
        case "list":
            guard let list = value as? NSArray else{
                return;
            }
            modelList = [ActionInfoModel]();
            for item in list {
                let model = ActionInfoModel(anyData: item);
                modelList.append(model);
            }
            
        default:
            super.setValue(value, forKey: key);
        }
    }
    
    class ActionInfoModel: BaseModel {
        @objc var id = 0;
        @objc var square_region = "";
        @objc var square_author = "";
        @objc var square_photo = "";
        @objc var square_name = "";
        @objc var square_time = 0;
    }
    
    
    
    

}
