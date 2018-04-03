//
//  ForFuncViewController.swift
//  StudyApp
//

import UIKit

class ForFuncViewController: SuperBaseViewController {
    
    @objc var id = 0;
    var newsModel: NewsModel!

    private var currentIndex = 1;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.automaticallyAdjustsScrollViewInsets = false;

        createTable(frame: .init(x: 0, y: 0, width: width(), height: height() - 64 - 40), delegate: self);
        baseTable.register(FuncTableViewCell.classForCoder(), forCellReuseIdentifier: "cell");
        baseTable.estimatedRowHeight = 89;
        baseTable.rowHeight = UITableViewAutomaticDimension;
        baseTable.separatorStyle = .singleLine;
        baseTable.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
        
        baseTable.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            self.currentIndex += 1;
            self.loadDataFromNet(net: true);
        });
        baseTable.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.currentIndex = 1;
            self.loadDataFromNet(net: true);
        });
    }
    
    override func loadDataFromNet(net: Bool) {
        
        let request = UserRequest(colum: id, name: nil, pageNum: currentIndex);
        request.cls = NewsModel.classForCoder();
        request.loadJsonStringFinished { (result, success) in
            self.baseTable.mj_footer?.endRefreshing();
            self.baseTable.mj_header?.endRefreshing();
            guard let model = result as? BaseModel ,
                let nModel = model.baseDataModel as? NewsModel
                else{
                return;
            }
            if self.currentIndex == 1 {
                self.newsModel = nModel;
            }else if let list = nModel.pageInfo?.pageList , self.newsModel != nil {
                self.newsModel.pageInfo.pageList.append(contentsOf: list);
            }
            self.baseTable.reloadData();
        };
    }

    // MARK: - table view delgate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let count = newsModel?.pageInfo?.pageList?.count else {
            return 0;
        }
        return count;
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FuncTableViewCell;
        
        guard let list = newsModel?.pageInfo?.pageList else {
            return cell;
        }
        if list.count > indexPath.row {
            
            let model = list[indexPath.row];
            cell.configCellByModel(md: model);
            
        }
        
        
        return cell;
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let list = newsModel?.pageInfo?.pageList else {
            return;
        }
        if list.count > indexPath.row {
            let ctrl = HTMLContentViewController();
            ctrl.linkURL = list[indexPath.row].getLinkURL();
            navigateCtrl.pushViewController(ctrl, animated: true);
        }
        
    }
    
}

class FuncTableViewCell: BaseTableViewCell {
    
    var timeLabel: UILabel!
    var zanLabel: UILabel!
    var lookLabel: UILabel!
    
    
    override func initView() {
        leftImage = createImageView();
        leftImage.snp.makeConstraints { (maker) in
            maker.left.equalTo(10);
            maker.top.equalTo(15);
            maker.bottom.equalTo(-10);
            maker.width.equalTo(120);
            maker.height.equalTo(74);
        }
        titleLabel = createLabel();
        titleLabel.numberOfLines = 3;
        titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.leftImage.snp.right).offset(10);
            maker.top.equalTo(self.leftImage.snp.top);
            maker.right.equalTo(self.snp.right).offset(-15);
        }
        
        let timeFlag = createImageView();
        timeFlag.image = UIImage(named:"fun_time");
        timeFlag.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.titleLabel.snp.left);
            maker.bottom.equalTo(self.leftImage.snp.bottom);
            maker.size.equalTo(CGSize.init(width: 14, height: 13));
        }
        
        
        timeLabel = createLabel();
        timeLabel.text = "2018-01-08 20:26";
        timeLabel.font = fontSize(size: 12);
        timeLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(timeFlag.snp.right).offset(4);
            maker.centerY.equalTo(timeFlag.snp.centerY);
        }
        
//        zanLabel = createLabel();
//        zanLabel.text = "12";
//        zanLabel.snp.makeConstraints { (maker) in
//            maker.right.equalTo(self.snp.right).offset(-10);
//            maker.centerY.equalTo(timeFlag.snp.centerY);
//        }
//
//        let zanImageView = createImageView();
//        zanImageView.image = UIImage(named:"fun_like");
//        zanImageView.snp.makeConstraints { (maker) in
//            maker.right.equalTo(self.zanLabel.snp.left).offset(-4);
//            maker.centerY.equalTo(timeFlag.snp.centerY);
//            maker.size.equalTo(CGSize.init(width: 18, height: 13));
//        }
//
//        lookLabel = createLabel();
//        lookLabel.text = "12";
//        lookLabel.snp.makeConstraints { (maker) in
//            maker.right.equalTo(zanImageView.snp.left).offset(-8);
//            maker.centerY.equalTo(timeFlag.snp.centerY);
//        }
//
//        let lookImageView = createImageView();
//        lookImageView.image = UIImage(named:"fun_look");
//        lookImageView.snp.makeConstraints { (maker) in
//            maker.right.equalTo(lookLabel.snp.left).offset(-4);
//            maker.centerY.equalTo(timeFlag.snp.centerY);
//            maker.size.equalTo(CGSize.init(width: 18, height: 13));
//        }
    }
    func configCellByModel(md: PageInfoListModel) -> Void {
        titleLabel.text = md.post_excerpt
        timeLabel.text = md.post_date;
        
        leftImage.sd_setImage(withURLString: md.cover_url);
    }
}






