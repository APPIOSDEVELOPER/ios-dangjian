//
//  HistoryViewController.swift
//  StudyApp
//
//  Created by yaojinhai on 2018/2/23.
//  Copyright © 2018年 yaojinhai. All rights reserved.
//

import UIKit

class HistoryViewController: SuperBaseViewController {

    var lineBar: YTShapePathView!
    
    private var isFirstApprea = true;
    
    private var currentIndex = 1;
    
    private var listItem = [ContentDetialModel]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createTable(frame: tabbarRect, delegate: self);
        baseTable.register(HistoryTableViewCell.classForCoder(), forCellReuseIdentifier: "baseCell");
        baseTable.showsVerticalScrollIndicator = false;
        baseTable.showsHorizontalScrollIndicator = false;
        baseTable.separatorStyle = .none;
        baseTable.rowHeight = UITableViewAutomaticDimension;
        baseTable.estimatedRowHeight = 80;
        
        let hImageView = UIImageView(frame: .init(x: 0, y: 0, width: width(), height: 120));
        hImageView.image = #imageLiteral(resourceName: "title_importention.png");
        hImageView.contentMode = .scaleAspectFill;
        hImageView.clipsToBounds = true;
        
        let headerView = UIView(frame: .init(x: 0, y: 0, width: width(), height: hImageView.height));
        headerView.addSubview(hImageView);
        
        baseTable.tableHeaderView = headerView;
        
//        baseTable.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
//            self.currentIndex += 1;
//            self.loadDataFromNet(net: true);
//        });
        baseTable.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.currentIndex = 1;
            self.loadDataFromNet(net: true);
        });
        
        
        lineBar = YTShapePathView(frame: .init(x: (width() - 8)/2, y: 180, width: 8, height: height()), type: .lineBarHistory);
        addView(tempView: lineBar);
        lineBar.backgroundColor = UIColor.clear;
        lineBar.fillColor = rgbColor(r: 226, g: 113, b: 111);
        
        lineBar.autoresizesSubviews = true;
    }

    override func loadDataFromNet(net: Bool) {
        
        let request = UserRequest(bigevent: currentIndex);
        request.loadJsonStringFinished(forceRefresh: net) { (result, success) in
            
            self.baseTable.mj_header?.endRefreshing();
            
            guard let dict = result as? NSDictionary ,
            let pageInfoDict = dict["result"] as? NSDictionary,
            let listDict = pageInfoDict["pageInfo"] as? NSDictionary,
            let list = listDict["list"] as? NSArray else{
                return;
            }
            if self.currentIndex == 1 {
                self.listItem.removeAll();
            }
            for item in list {
                let model = ContentDetialModel(anyData: item);
                self.listItem.append(model);
            }
            self.baseTable.reloadData();
            
        };
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        if isFirstApprea {
            isFirstApprea = false;
        }else{
            
            loadDataFromNet(net: true);
        }
    }
    

    
    
    // MARK: - table view delegate and datasource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItem.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "baseCell", for: indexPath) as! HistoryTableViewCell;
        let model = listItem[indexPath.row];
        cell.configCell(idx: indexPath.row,model:model);
        return cell;
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = listItem[indexPath.row];
//        let html = HTMLContentViewController();
//
//        navigateCtrl.pushViewController(html, animated: true);
        
        let request = UserRequest(value: "\(model.id)", jointType: .newsDetial);
        request.loadJsonStringFinished { (result, success) in
            
        }
        
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let py = scrollView.contentOffset.y;
        if py < 120  {
            lineBar.frame.origin.y = 120 + 60 - py;
        }else {
            lineBar.frame.origin.y = 60;
        }
    }
}

class HistoryTableViewCell: BaseTableViewCell {
    
    var leftFlag: YTShapePathView!
    var rightFlag: YTShapePathView!
    
    var leftText: UILabel!
    var flagColor = [UIColor]();
    
    
    
    
    func configCell(idx: Int,model: ContentDetialModel) -> Void {
        let bs = idx % 2 == 0 ? true : false;
        leftFlag.isHidden = bs;
        rightFlag.isHidden = !bs;
      
        let colors = flagColor[idx % 4];
        
        let larFont = fontSize(size: 17);
        let smalFont = fontSize(size: 14);
        
        
        if bs {
            leftText.text = model.post_date;
            leftText.font = larFont;
            rightText.font = smalFont;
            
            rightText.text = model.post_excerpt;
            rightFlag.fillColor = colors;
        }else{
            leftText.text = model.post_excerpt;
            rightText.text = model.post_date;
            leftText.font = smalFont;
            rightText.font = larFont;
            leftFlag.fillColor = colors;
        }
        
        
        
    }
    
    override func initView() {
        
        flagColor.append(rgbColor(r: 226, g: 113, b: 111));
        flagColor.append(rgbColor(r: 0, g: 160, b: 231));
        flagColor.append(rgbColor(r: 244, g: 181, b: 101));
        flagColor.append(rgbColor(r: 107, g: 175, b: 127));

        let flagWidth: CGFloat = 100;
        
        leftFlag = YTShapePathView(frame: .init(x: 0, y: 0, width: flagWidth, height: 14), type: .thermometertLeftFlag);
        addSubview(leftFlag);
        leftFlag.snp.makeConstraints { (maker) in
            maker.top.equalTo(10);
            maker.centerX.equalTo(self.snp.centerX);
            maker.width.equalTo(flagWidth);
            maker.height.equalTo(14);
        }
        
        leftText = createLabel();
        leftText.numberOfLines = 0;
        leftText.snp.makeConstraints { (maker) in
            maker.left.greaterThanOrEqualTo(14);
            maker.right.equalTo(self.leftFlag.snp.left);
            maker.top.equalTo(self.leftFlag.snp.bottom);
            maker.bottom.lessThanOrEqualTo(self.snp.bottom).offset(-20);

        }
        
        
        rightText = createLabel();
        rightText.numberOfLines = 0;
        
        rightText.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.leftFlag.snp.right);
            maker.right.lessThanOrEqualTo(self.snp.right).offset(-14);
            maker.top.equalTo(self.leftText.snp.top);
            maker.bottom.lessThanOrEqualTo(self.snp.bottom).offset(-20);
        }
        
        
        rightFlag = YTShapePathView(frame: .init(x: 0, y: 0, width: leftFlag.width, height: leftFlag.height), type: .thermometertRightFlag);
        addSubview(rightFlag);
        rightFlag.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.leftFlag.snp.left);
            maker.top.equalTo(self.leftFlag.snp.top);
            maker.size.equalTo(self.leftFlag.snp.size);
        }
    }
}
