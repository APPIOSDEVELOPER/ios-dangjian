//
//  BaseJsonModel.swift
//  StudyApp
//
//  Created by yaojinhai on 2018/1/23.
//  Copyright © 2018年 yaojinhai. All rights reserved.
//

import UIKit

struct  NewsCatogeryCodable:Codable {
    var id = 0;
    var name = "";
    
    enum BaseCodingKeys: String,CodingKey {
        case name = "picName"
        case id
    }
    
    static func encode(list: NSArray) -> [NewsCatogeryCodable]{
        var newsList = [NewsCatogeryCodable]()
        let decoder = JSONDecoder();
        for item in list {
            let data = try! JSONSerialization.data(withJSONObject: item, options: .prettyPrinted);
            let model = try! decoder.decode(NewsCatogeryCodable.self, from: data);
            newsList.append(model);
            
            
            
            let encoder = JSONEncoder();
            let jsonData = try? encoder.encode(model);
            let jsonStrl = String(data: jsonData!, encoding: String.Encoding.utf8);
            print("json strl = \(jsonStrl)");
            
        }
        
        
        return newsList;
    }
}
