//
//  NewCommentViewController.swift
//  StudyApp
//
//  Created by yaojinhai on 2018/3/30.
//  Copyright © 2018年 yaojinhai. All rights reserved.
//

import UIKit

class NewCommentViewController: SuperBaseViewController,UITextFieldDelegate {
    
    
    var commentView: BaseCustomView!

    var baseWebView: CustomWebView!
    
    var id = 0;
    
    var linkURL = "";
    
    var isShowInpuView = true;
    
    var image = UIImage()
    
    private var subTitle: String?;
    
    var commentDetialList: [CommentDeitalModel]!


    private var tableContentSize = CGSize.zero;
    private var scrollContentSize = CGSize.zero;
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        let bd = UIView();
        addView(tempView: bd);
        
        
        setContentScrollView(rect: CGRect.init(x: 0, y: 0, width: width(), height: height() - 50));
//        contentScrollView.layer.borderWidth = 2;
//        contentScrollView.layer.borderColor = UIColor.blue.cgColor;

        
        
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        
        
        baseWebView = CustomWebView.createWebView(frame: navigateRect);
        contentScrollView.addSubview(baseWebView);
//        baseWebView.scrollView.isScrollEnabled = false;
//        baseWebView.layer.borderColor = UIColor.green.cgColor;
//        baseWebView.layer.borderWidth = 44;
        
        if #available(iOS 11.0, *) {
            baseWebView.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        };
        

        
        commentView = BaseCustomView(frame: .init(x: 0, y: height() - 50, width: width(), height: 50), type: .commentItemView);
        commentView.textField.delegate = self;
        commentView.isAddKeyBoradNotification = true;
        addView(tempView: commentView);
        commentView.subButton.addTarget(self, action: #selector(buttonAction(btn:)), for: .touchUpInside);
        commentView.titleButton.addTarget(self, action: #selector(buttonAction(btn:)), for: .touchUpInside);
        commentView.titleButton.tag = ViewTagSense.shareTag.rawValue;
        commentView.subButton.tag = ViewTagSense.supTag.rawValue;
        
        commentView.isHidden = !isShowInpuView;
        
        createTable(delegate: self);
        baseTable.register(CommentTableCell.classForCoder(), forCellReuseIdentifier: "CommentTableCell");
        baseTable.removeFromSuperview();
        baseTable.rowHeight = UITableViewAutomaticDimension;
        baseTable.estimatedRowHeight = 100;
        baseTable.isScrollEnabled = false;
        baseTable.separatorStyle = .singleLine;
        contentScrollView.addSubview(baseTable);
//        baseTable.backgroundColor = UIColor.red;
    }
    
    @objc override func buttonAction(btn: UIButton) {
        
        if btn.tag == ViewTagSense.supTag.rawValue {
            surportNews();
            btn.isSelected = !btn.isSelected;
        }else if btn.tag == ViewTagSense.shareTag.rawValue{
            
            let shareCtrl = ShareViewController();
            let sTitle = subTitle ?? title ?? "";
            //            "实时发布当新闻和活动"
            let msg = ShareMessage.createMessage(title: sTitle, content: baseWebView.contentBody, img: #imageLiteral(resourceName: "icons_57.png"), url: linkURL);
            msg.type = .webPage;
            shareCtrl.shareMsg = msg;
            self.present(shareCtrl, animated: true, completion: {
                
            })
            
        }
    }
    
    override func loadDataFromNet(net: Bool) {
        
        let reqeust = UserRequest(value: "\(id)", jointType: .newsDetial);
        reqeust.cls = NewsDetialModel.classForCoder();
        
        reqeust.loadJsonStringFinished { (result, success) in
            self.baseWebView.scrollView.mj_header?.endRefreshing();
            guard let model = result as? BaseModel,
            let subModel = model.baseDataModel as? NewsDetialModel else{
                return;
            }
            self.baseWebView.loadHTMLString(subModel.post_content, baseURL: nil);
        };
        
        loadCommentList();
    }
    // 获取评论 14
    // 评论
    func loadCommentList() -> Void {
        let request = UserRequest(value: "\(id)", jointType: .commentList);
        request.cls = CommentDeitalModel.classForCoder();
        request.loadJsonStringFinished {
            [weak self](result, success) in
            self?.baseTable.mj_footer?.endRefreshing();
            guard let model = result as? BaseModel,
                let items = model.baseDataList as? [CommentDeitalModel] else{
                    return;
            }
            self?.commentDetialList = items;
//            self?.tableheaderView.messageLabel.text = "评论(\(items.count))"
            self?.baseTable.reloadData();
            
        };
    }
    
    func commentNews() -> Void {
        
        let request = UserRequest(comment: commentView.textField.text!, postId: id, author: UserInfoModel.getUserName(),commentType:.news);
        request.loadJsonStringFinished { (result, success) in
            guard let model = result as? NSDictionary else{
                return;
            }
            self.loadCommentList();
            
            
        };
        
    }
    
    
    // MARK: - table view delegate
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentDetialList?.count ?? 0;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableCell", for: indexPath) as! CommentTableCell;
        let item = commentDetialList[indexPath.row];
        cell.configCell(model: item);
        return cell;
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    // 点赞支持
    
    func surportNews() -> Void {
        
        let request = UserRequest(value: "\(id)", jointType: .surname);
        
        request.loadJsonStringFinished { (result, success) in
            
            guard let dict = result as? NSDictionary else{
                return;
            }
            
            print("result = \(dict)");
        };
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldDidEndEditing(textField);
        commentNews();
        return true;
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        view.endEditing(true);
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        baseWebView.addObserver(self, forKeyPath: "title", options: .new, context: nil);
        baseWebView.scrollView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil);
        baseTable.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil);

        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        baseWebView.removeObserver(self, forKeyPath: "title");
        baseWebView.scrollView.removeObserver(self, forKeyPath: "contentSize");
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        
        guard let path = keyPath,
            let newValue = change?[NSKeyValueChangeKey.newKey] else {
            return;
        }
        
        switch path {
        case "title":
            subTitle = newValue as? String;
            if self.title == nil {
                self.title = subTitle;
            }
        case "contentSize":
            let contentSize = newValue as? CGSize;

            if object is FMBaseTableView {
                if !scrollContentSize.equalTo(CGSize.zero) {
                    contentScrollView.contentSize = .init(width: 0, height: scrollContentSize.height + contentSize!.height + 44);
                }
                tableContentSize = contentSize!;
                baseTable.frame.size.height = contentSize!.height;
                
            }else if object is UIScrollView {
                
                baseWebView.frame.size = contentSize!;
                baseTable.frame.origin = CGPoint.init(x: 0, y: contentSize!.height + 44);
                scrollContentSize = contentSize!;
                if !tableContentSize.equalTo(CGSize.zero) {
                    contentScrollView.contentSize = .init(width: scrollContentSize.width, height: tableContentSize.height + contentSize!.height + 44);

                }
            }
            
//            print("T:\(tableContentSize),W:\(scrollContentSize),S:\(contentScrollView.contentSize)");
            
            
            
        default:
            break;
        }
        
        if path == "title" {
            
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated);
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
        
        createHTMLContent();
        
        
    }
    
    func createHTMLContent() -> Void {
        
        if linkURL.hasPrefix("http://") || linkURL.hasPrefix("https://") {
            guard let url = URL(string: linkURL) else {
                return;
            }
            var request = URLRequest(url: url);
            let timestamp = Date().timestamp;
            request.setValue(timestamp, forHTTPHeaderField: RequestConfigList.timesamp);
            request.setValue(RequestConfigList.getTokenValue(time: timestamp), forHTTPHeaderField: RequestConfigList.assetionkey);
            baseWebView.load(request);
        }
    }
    
    
}
