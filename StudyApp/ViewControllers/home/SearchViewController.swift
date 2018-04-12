//
//  SearchViewController.swift
//  StudyApp
//
//  Created by yaojinhai on 2018/1/18.
//  Copyright © 2018年 yaojinhai. All rights reserved.
//

import UIKit

class SearchViewController: SuperBaseViewController,UISearchBarDelegate {

    var searchView: UISearchBar!
    var searchBackView: UIView!
    
    private var currentIndex = 1;
    
    private var newModel: NewsModel!
    
    private var noDataLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noDataLabel = UILabel(frame: bounds());
        addView(tempView: noDataLabel);
        noDataLabel.text = "没有相关数据,请输入其他关键字";
        noDataLabel.isHidden = true;
        noDataLabel.textAlignment = .center;
        noDataLabel.textColor = UIColor.gray;

        
        createSearchView();

    }
    func createSearchView() -> Void {
        searchView = UISearchBar(frame: .init(x: 0, y: 8, width: width() - 100, height: 28));
        searchView.barTintColor = UIColor.white;
        searchView.barStyle = .default;
        searchView.tintColor = UIColor.blue;
        searchView.searchBarStyle = .prominent;
        searchView.setBackgroundImage(UIImage(), for: .any, barMetrics: .default);
        searchView.delegate = self;
        searchView.setImage(UIImage(), for: .search, state: .normal);
        searchView.layer.cornerRadius = 6;
        searchView.layer.masksToBounds = true;
        

        let rightImage = UIImageView(frame: .init(x: searchView.maxX - 50, y: 2, width: 40, height: searchView.height - 4));
        rightImage.contentMode = .scaleAspectFit;
        rightImage.image = #imageLiteral(resourceName: "search_text_field.png");
        searchView.addSubview(rightImage);

        
        
        
        searchBackView = UIView(frame: .init(x: 50, y: 0, width: width() - 100, height: 44));
        searchBackView.addSubview(searchView);
        
        
        createTable(frame: navigateRect, delegate: self);
        baseTable.rowHeight = UITableViewAutomaticDimension;
        baseTable.estimatedRowHeight = 100;
        baseTable.register(HomeTableCell.classForCoder(), forCellReuseIdentifier: "HomeTableCell");
        baseTable.separatorStyle = .singleLine;
//        baseTable.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
//            self.currentIndex += 1;
//            self.searchNewsByKey();
//        });
        
        
    }
    
    func getTextFielView(sView:UIView) -> UITextField? {
        var textField: UITextField! = nil;
        for item in sView.subviews {
            if let textV = item as? UITextField {
                textField = textV;
                break;
            }else{
                textField = getTextFielView(sView: item);
            }
        }
        return textField;
        
    }
    

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchNewsByKey();
    }

    
    // MARK: - table view delgate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let count = newModel?.pageInfo?.pageList?.count else {
            return 0;
        }
        return count;
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableCell", for: indexPath) as! HomeTableCell;
        let index = indexPath.row % 4;
        cell.leftImage.image = UIImage(named: "content_img0\(index + 1)");
        
        guard let modelList = newModel?.pageInfo?.pageList else {
            return cell;
        }
        if modelList.count > indexPath.row {
            let model = modelList[indexPath.row];
            cell.configCellByModel(md: model);
        }
        return cell;
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let modelList = newModel?.pageInfo?.pageList else {
            return;
        }
        if modelList.count > indexPath.row {
            let model = modelList[indexPath.row];
            let ctrl = HTMLContentViewController();
            ctrl.id = model.id;
            ctrl.linkURL = model.getLinkURL();
            navigateCtrl.pushViewController(ctrl, animated: true);
            
        }
        
    }
    
    
    func searchNewsByKey() -> Void {
        
        
        let request = UserRequest(colum: nil, name: self.searchView.text, pageNum: self.currentIndex);
        request.cls = NewsModel.classForCoder();
        request.loadJsonStringFinished { (result, success) in
            self.baseTable.mj_footer?.endRefreshing();
            guard let model = result as? BaseModel else{
                return;
            }
            if self.currentIndex == 1{
                self.newModel = model.baseDataModel as? NewsModel;
            }else {
                
            }
            self.baseTable.reloadData();
            
            if self.newModel?.pageInfo?.pageList?.count != nil{
                self.noDataLabel.isHidden = true;
            }else{
                self.noDataLabel.isHidden = false;
            }
        };
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.navigationBar.addSubview(searchBackView);

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        searchBackView.removeFromSuperview();
    }
    

}
