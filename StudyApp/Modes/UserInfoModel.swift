//
//  UserInfoModel.swift
//  StudyApp
//
//  Created by yaojinhai on 2018/1/29.
//  Copyright © 2018年 yaojinhai. All rights reserved.
//

import UIKit

class UserInfoModel: BaseModel {

    @objc var managerid = 0;
    @objc var account = "";
    @objc var name = "";
    @objc var lastlogintime:Double = 0;
    @objc var issuper = false;
    @objc var photo = "";
    
    func getPhotoURL() -> URL? {
        if !photo.hasPrefix("http") {
            return nil;
        }
        photo = photo.replacingOccurrences(of: "\\", with: "/");
        return URL(string: photo);
    }
    
    private static let userId = "com.user.info.id";
    private static let userName = "com.user.info.userName";
    
    override func setData() {
        saveUserInfo();
    }
    
    private func saveUserInfo() -> Void {
        UserDefaults.standard.set(managerid, forKey: UserInfoModel.userId);
        UserDefaults.standard.set(name, forKey: UserInfoModel.userName);
    }
    class func getUserName() -> String {

        guard let nickerName = UserDefaults.standard.string(forKey: UserInfoModel.userName) else {
            return "游客";
        }
        return nickerName;
    }
    class func getUserId() -> Int {
        return UserDefaults.standard.integer(forKey: UserInfoModel.userId);
    }
    class func logoutApp(){
        UserDefaults.standard.set(0, forKey: UserInfoModel.userId);
    }
    
    class func isLogin() -> Bool {
        let state = UserDefaults.standard.integer(forKey: UserInfoModel.userId);
        return state != 0;
        
    }
}

