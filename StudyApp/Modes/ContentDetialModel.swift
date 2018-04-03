//
//  ContentDetialModel.swift
//  StudyApp
//
//  Created by yaojinhai on 2018/2/7.
//  Copyright © 2018年 yaojinhai. All rights reserved.
//

import UIKit

class ContentDetialModel: BaseModel {

    @objc var author = "";
    @objc var post_author = 0;
    @objc var id = 0;
    @objc var photo = "";
    @objc var post_column = 0;
    @objc var post_content = "";
    @objc var surname = 0;
    @objc var post_excerpt = "";
    @objc var post_title = "";
    @objc var cover_url = "";
    @objc var comment_status = 0;
    @objc var post_source = "";
    @objc var post_type = 0;
    
    // 大事件 属性:
//    post_title
//    cover_url
//    post_source
//    id
//    post_column
//    post_excerpt
    @objc var comment_count = 0;
    @objc var post_name = "";
    @objc var post_date = "";

    override func setValue(_ value: Any?, forKey key: String) {
   
        switch key {
        case "post_date":
            guard let date = value else{
                return;
            }
            post_date = "\(date)";
        default:
            super.setValue(value, forKey: key);
        }
    }
    
    
    
    override func setData() {
        cover_url = cover_url.replacingOccurrences(of: "\\", with: "/");
    }
    
    var vedioURL: URL? {
        if post_content.hasPrefix("http") {
            return URL(string: post_content);
        }
        return URL.init(string: baseURLAPI + "/" + post_content);
    }
    
    
//    id: 97,
//    post_author: 1,
//    post_date: 1517846400000,
//    post_excerpt: "",
//    post_content: "upload/video/20180206/1517884008670095253.mp4",
//    post_title: "中国共产党党员领导干部廉洁从政若干准则",
//    cover_url: "upload/fengmian/201802/06102307wp58.jpg",
//    comment_status: 1,
//    post_status: 1,
//    post_source: "人民网",
//    post_column: 10,
//    post_type: 9,
//    comment_count: 0,
//    surname_count: 0,
//    author: "管理员",
//    photo: "",
//    surname: false

}
