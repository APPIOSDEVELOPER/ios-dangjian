//
//  MyClsViewController.swift
//  StudyApp
//
//  Created by yaojinhai on 2018/3/27.
//  Copyright © 2018年 yaojinhai. All rights reserved.
//

import UIKit

class MyClsViewController: SuperBaseViewController {

    var fonts = [UIFont]();
    
    var isShowFont = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let names = UIFont.familyNames;
        for name in names {
            let f = UIFont(name: name, size: 17)!;
            fonts.append(f);
        }
        
        
        
        createTable(delegate: self);
        baseTable.rowHeight = UITableViewAutomaticDimension;
        baseTable.estimatedRowHeight = 100;
        baseTable.separatorStyle = .singleLine;
        baseTable.register(MyCLsTableViewCell.classForCoder(), forCellReuseIdentifier: "MyCLsTableViewCell");
        baseTable.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "UITableViewCell");
        
        title = "学习课程";
        
        

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fonts.count;
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isShowFont {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath);
            cell.textLabel?.text = """
            中国共产党章党学习讲解中国共产党章党学习讲解
            abcdefghigklmnopqrstuvwxyz
            ABCDEFGHIGKLMNOPQRSTUVWXYZ
            0123456789
            """;
            cell.textLabel?.font = fonts[indexPath.row];
            cell.textLabel?.numberOfLines = 0;
//            fontSize(size: 12);
            return cell;
        }
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCLsTableViewCell", for: indexPath) as! MyCLsTableViewCell;
        cell.leftImage.image = #imageLiteral(resourceName: "my_cls_1.png");
        cell.titleLabel.text = "中国共产党章党学习讲解中国共产党章党学习讲解";
        cell.subTitleLabel.text = "2018-03-26";
//
        return cell;
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isShowFont {
            let name = fonts[indexPath.row].fontName;
            print("name = \(name),family name = \(fonts[indexPath.row].familyName)");
        }
        
        
    }


}
class MyCLsTableViewCell: BaseTableViewCell {
    
    override func initView() {
        leftImage = createImageView();
        leftImage.snp.makeConstraints { (maker) in
            maker.left.top.equalTo(10);
            maker.size.equalTo(CGSize.init(width: 100, height: 74));
            maker.bottom.equalTo(-10);
        };
        
        let flagImage = createImageView();
        flagImage.image = #imageLiteral(resourceName: "play.png");
        flagImage.contentMode = .scaleAspectFit;
        flagImage.snp.makeConstraints { (maker) in
            maker.center.equalTo(CGPoint.init(x: 55, y: 42));
            maker.size.equalTo(CGSize.init(width: 30, height: 30));
        }
        
        
        titleLabel = createLabel();
        titleLabel.numberOfLines = 2;
        titleLabel.font = fontSize(size: 20);
        titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.leftImage.snp.right).offset(10);
            maker.right.equalTo(self.snp.right).offset(-10);
            maker.top.equalTo(self.leftImage.snp.top);
        }
        
        subTitleLabel = createLabel();
        subTitleLabel.font = fontSize(size: 16);
        subTitleLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(self.snp.right).offset(-10);
            maker.bottom.equalTo(self.leftImage.snp.bottom);
        }
    }
}






