//
//  NewsModel.swift
//  StudyApp
//
//  Created by yaojinhai on 2018/1/22.
//  Copyright © 2018年 yaojinhai. All rights reserved.
//

import UIKit

class NewsModel: BaseModel {

    var linksList: [LinksEntityModel]!
    var pageInfo: PageInfoModel!
    
    override func setValue(_ value: Any?, forKey key: String) {
        switch key {
        case "pageInfo":
            guard let dict = value as? NSDictionary else{
                return;
            }
            pageInfo = PageInfoModel(dictM: dict);
        case "linksEntity":
            guard let list = value as? NSArray else{
                return;
            }
            linksList = [LinksEntityModel]();
            for item in list {
                let model = LinksEntityModel(anyData: item);
                linksList.append(model);
            }
        default:
            super.setValue(value, forKey: key);
        }
    }

}

class LinksEntityModel: BaseModel {
    @objc var link_description = "";
    @objc var link_image = "";
    @objc var link_name = "";
    @objc var link_target = 1;
    @objc var link_url = "";
    
    override func setData() {
        link_url = link_url.replacingOccurrences(of: "\\", with: "/")
    }
    
    func getLinkURL() -> String {
        return baseURLAPI + "note/" + "\(0)"
    }
}
class PageInfoModel: BaseModel {
    @objc var endRow = 2;
    @objc var firstPage = 1;
    @objc var hasNextPage = 0;
    @objc var hasPreviousPage = 0;
    @objc var isFirstPage = 1;
    @objc var isLastPage = 1;
    @objc var lastPage = 1;
    @objc var nextPage = 0;
    @objc var navigatePages = 8;

//    @objc var orderBy = "";
    @objc var pageNum = 1;
    @objc var pageSize = 10;
    @objc var pages = 1;
    @objc var prePage = 0;
    @objc var size = 2;
    @objc var startRow = 1;
    @objc var total = 2;
    
    var pageList: [PageInfoListModel]!
    
    
    override func setValue(_ value: Any?, forKey key: String) {
        switch key {
        case "list":
            guard let list = value as? NSArray else{
                return;
            }
            pageList = [PageInfoListModel]();
            for item in list {
                let model = PageInfoListModel(anyData: item);
                pageList.append(model);
            }
        default:
            super.setValue(value, forKey: key);
        }
    }
    
}

class PageInfoListModel: BaseModel {
    @objc var comment_count = 0;
    @objc var id = 1;
    @objc var post_date = "";
    @objc var post_name = "";
    @objc var post_title = "";
    @objc var cover_url = ""; // 图片地址
    @objc var post_source = "";
    @objc var post_column = 0;
    @objc var post_excerpt = "";
    
    override func setData() {
        cover_url = cover_url.replacingOccurrences(of: "\\", with: "/");
    }
    
    func getLinkURL() -> String {
//        http://112.126.73.158:8087/langur/api/note/1?managerid=9
        return baseURLAPI + "/note/\(id)/?" + "managerid=" + "\(UserInfoModel.getUserId())";
    }
    
    
    
    func getTitle() -> String {
        if post_name.count > 0 {
            return post_name;
        }
        return post_title;
    }
}
