//
//  QuestionListModel.swift
//  StudyApp
//
//  Created by yaojinhai on 2018/1/29.
//  Copyright © 2018年 yaojinhai. All rights reserved.
//

import UIKit

class QuestionListModel: BaseModel{

    @objc var square_time = 10;
    var subject: [SubjectModel]!;
    var countSecond: Int {
        return square_time * 60;
    }
    
    
    override func setValue(_ value: Any?, forKey key: String) {
        
        switch key {
        case "subject":
            guard let list = value as? NSArray else{
                return ;
            }
            subject = [SubjectModel]()
            for item in list {
                let model = SubjectModel(anyData: item);
                subject.append(model);
            }
        default:
            super.setValue(value, forKey: key);
        }
    }
}

class SubjectModel: BaseModel {
    @objc var addtime = "";
    @objc var count = 0;
    @objc var id = 0;
    @objc var subject_type = 0;
    var optionEntity:[OptionEntityModel]!
    @objc var subject_name = ""; //"第一题的题目信息",
    
    var isSingle: Bool {
        return subject_type == 1;
    }
    
    
    override func setValue(_ value: Any?, forKey key: String) {
        
        switch key {
        case "optionEntity":
            guard let list = value as? NSArray else{
                return;
            }
            optionEntity = [OptionEntityModel]();
            for item in list {
                let model = OptionEntityModel(anyData: item);
                optionEntity.append(model);
            }
            let model = OptionEntityModel();
            model.option_opt = "-1";
            optionEntity.append(model);
            
        default:
            super.setValue(value, forKey: key);
        }
    }

}

class OptionEntityModel: BaseModel {
    @objc var option_name = "";
    @objc var option_opt = "";
    
    var isOption: Bool {
        return option_opt != "-1";
    }
    
    
    func getQuestionLabel() -> String {
        return option_opt + "\t" + option_name;
    }
    
}
