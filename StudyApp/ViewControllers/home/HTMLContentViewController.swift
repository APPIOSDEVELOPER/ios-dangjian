//
//  NewsContentViewController.swift
//  CathAssist
//


import Foundation
import WebKit

enum HTMLContentType : Int{
    case typeDayItem = 0
    case typeNew = 1 // 新闻
    case typePrayer = 2
    case typeDogmata = 3
    case recommendNews = 4
    
}

class HTMLContentViewController: SuperBaseViewController,UITextFieldDelegate {


    var commentView: BaseCustomView!
    
    
    var baseWebView: CustomWebView!
    
    var id = 0;

    var linkURL = "";
    
    var isShowInpuView = true;
    
    var image = UIImage()
    
    private var subTitle: String?;
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        
        self.automaticallyAdjustsScrollViewInsets = false;

        self.navigationController?.navigationBar.tintColor = UIColor.white;
        
        baseWebView = CustomWebView.createWebView(frame: navigateRect);
        addView(tempView: baseWebView);
        
        baseWebView.scrollView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.loadDataFromNet(net: true);
        });

        
        commentView = BaseCustomView(frame: .init(x: 0, y: height() - 50, width: width(), height: 50), type: .commentItemView);
        commentView.textField.delegate = self;
        commentView.isAddKeyBoradNotification = true;
        addView(tempView: commentView);
        commentView.subButton.addTarget(self, action: #selector(buttonAction(btn:)), for: .touchUpInside);
        commentView.titleButton.addTarget(self, action: #selector(buttonAction(btn:)), for: .touchUpInside);
        commentView.titleButton.tag = ViewTagSense.shareTag.rawValue;
        commentView.subButton.tag = ViewTagSense.supTag.rawValue;
        
        commentView.isHidden = !isShowInpuView;
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
            guard let model = result as? BaseModel else{
                return;
            }
            let subModel = model.baseDataModel as? NewsDetialModel;
            self.baseWebView.loadHTMLString(subModel!.post_content, baseURL: nil);
        };
        
    }
    // 获取评论 14
    // 评论
    func commentNews() -> Void {
        
        let request = UserRequest(comment: commentView.textField.text!, postId: id, author: UserInfoModel.getUserName(),commentType:.news);
//        request.respType = .typeModel;
//        request.cls = NewsDetialModel.classForCoder();
        request.loadJsonStringFinished { (result, success) in
            guard let model = result as? NSDictionary else{
                return;
            }
//            let subModel = model.baseDataModel as? NewsDetialModel;
//            print("subm = \(subModel?.post_content)")
            
            
        };
        
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
            print("content = \(contentSize)")
            
        default:
            break;
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
            let request = URLRequest(url: url);
            baseWebView.load(request);
        }
    }
    
    
}

class NewsDetialModel: BaseModel {
    @objc var id = 0;
    @objc var post_date = 0;
    @objc var post_excerpt = "";
    @objc var post_content = "";
    @objc var post_column = 0;
    @objc var author = "";
    @objc var photo = "";
    @objc var surname = false;
}

