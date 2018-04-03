//
//  CommentDeitalModel.swift
//  StudyApp
//
//  Created by yaojinhai on 2018/3/30.
//  Copyright © 2018年 yaojinhai. All rights reserved.
//

import UIKit

class CommentDeitalModel: BaseModel {

    @objc var id = 76;
    @objc var comment_postid = "";
    @objc var comment_author = "";
    @objc var comment_author_email = "";
    @objc var comment_author_url = "";
    @objc var comment_author_ip = "";
    @objc var comment_date = "";
    @objc var comment_content = "";
    @objc var comment_approved = "";
    @objc var comment_agent = "";
    @objc var comment_type = "";
    @objc var comment_parent = "";
//    @objc var manager_id = 0;
    
    override func setValue(_ value: Any?, forKey key: String) {
        switch key {
        case "comment_date":
            guard let date = value else{
                return;
            }
            comment_date = "\(date)"
        default:
            super.setValue(value, forKey: key);
        }
    }
    
    var photoURL: String? {
        if comment_author_url.contains("http") {
            return comment_author_url;
        }
        return nil;
    }
    
}
