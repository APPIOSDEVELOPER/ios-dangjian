//
//  CatogeryModel.swift
//  StudyApp
//
//  Created by yaojinhai on 2018/1/22.
//  Copyright © 2018年 yaojinhai. All rights reserved.
//

import UIKit

class CatogeryModel: BaseModel {

    @objc var id = 0;
    @objc var name = "";
    private var nameWidth: CGFloat = 0;
    var width: CGFloat {
        if nameWidth != 0 {
            return nameWidth;
        }
        nameWidth = name.size(size: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), font: 18).width + 30;
        return nameWidth;
    }
}
