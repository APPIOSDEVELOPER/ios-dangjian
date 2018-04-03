//
//  NewsListViewController.swift
//  StudyApp
//


import UIKit

class NewsListViewController: SuperBaseViewController {

    var studyModel: NewsModel!
    
    var currentIndex = 1;
    override func viewDidLoad() {
        super.viewDidLoad()

        createTable(delegate: self);
        baseTable.rowHeight = UITableViewAutomaticDimension;
        baseTable.estimatedRowHeight = 300;
        baseTable.register(NewsTableViewCell.classForCoder(), forCellReuseIdentifier: "NewsTableViewCell")
        baseTable.separatorStyle = .singleLine;
        baseTable.separatorInset = UIEdgeInsetsMake(0, 10, 0, 15);
        baseTable.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            self.currentIndex += 1;
            self.loadDataFromNet(net: true);
        });
        baseTable.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.currentIndex = 1;
            self.loadDataFromNet(net: true);
        });
        
        setBackStyle();
    }
    

    override func loadDataFromNet(net: Bool) {
        
        let request = UserRequest(colum: 17, name: nil, pageNum: self.currentIndex);
        request.cls = NewsModel.classForCoder();
        request.loadJsonStringFinished { (result, success) in
            
            self.baseTable.mj_footer?.endRefreshing();
            self.baseTable.mj_header?.endRefreshing();
            
            guard let model = result as? BaseModel,
             let nModel = model.baseDataModel as? NewsModel else{
                return;
            }
            
            if self.currentIndex == 1 {
                self.studyModel = nModel;
            }else if let list = nModel.pageInfo.pageList , self.studyModel != nil {
                self.studyModel.pageInfo.pageList.append(contentsOf: list);
            }
            self.baseTable.reloadData();
            
        };
        
    }
    
    // MARK: - table view delgate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = studyModel?.pageInfo?.pageList?.count else {
            return 0;
        }
        return count;
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as! NewsTableViewCell;
        
        
        guard let list = studyModel?.pageInfo?.pageList else {
            return cell;
        }
        if list.count > indexPath.row {
            
            let model = list[indexPath.row];
            cell.configCellByModel(md: model);
//            cell.testView();
//
//            let index = indexPath.row % 2;
//            cell.leftImage.image = UIImage(named:"news_list_\(index)");
        }
        
        
        return cell;
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let list = studyModel?.pageInfo?.pageList else {
            return ;
        }
        if list.count > indexPath.row {
            let ctrl = HTMLContentViewController();
            ctrl.linkURL = list[indexPath.row].getLinkURL();
            navigateCtrl.pushViewController(ctrl, animated: true);
        }
        
        
        
    }

}

class NewsTableViewCell: BaseTableViewCell {
    
    var desLabel:UILabel!
    var sourceLabel: UILabel!
    var timeLabel:UILabel!
    
//    var commentLabel: UILabel!
//    var isCollection: UIImageView!
//    var supportCount: UILabel!
    
    var model: PageInfoListModel!
    
    let fSize: CGFloat = 20;
    
    
    
    override func initView() {
        titleLabel = createLabel();
        titleLabel.textAlignment = .center;
        titleLabel.font = fontBlod(size: fSize);
        titleLabel.textColor = UIColor.darkText;
        titleLabel.numberOfLines = 2;
        titleLabel.snp.makeConstraints { (maker) in
            maker.left.top.equalTo(35);
            maker.right.equalTo(-35);
        }
        
        subTitleLabel = createLabel();
        subTitleLabel.textColor = rgbColor(rgb: 155);
        subTitleLabel.font = fontSize(size: fSize - 3);
        subTitleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(10);
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(15)
        }
        leftImage = createImageView();
        leftImage.contentMode = .scaleAspectFill;
        
        leftImage.snp.makeConstraints { (maker) in
            maker.left.equalTo(10);
            maker.top.equalTo(self.subTitleLabel.snp.bottom).offset(10);
            maker.right.equalTo(-10);
            maker.height.equalTo(150);
        }
        
        sourceLabel = createLabel();
        sourceLabel.textColor = rgbColor(rgb: 105);
        sourceLabel.font = fontSize(size: fSize - 4);
        sourceLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(10);
            maker.top.equalTo(self.leftImage.snp.bottom).offset(4);
        }
        desLabel = createLabel();
        desLabel.font = fontSize(size: fSize - 4);
        desLabel.textColor = rgbColor(rgb: 141);
        desLabel.numberOfLines = 2;
        desLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(10);
            maker.right.equalTo(-10);
            maker.top.equalTo(self.sourceLabel.snp.bottom).offset(4);
        }
        
        timeLabel = createLabel();
        timeLabel.font = desLabel.font;
        timeLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(10);
            maker.top.equalTo(self.desLabel.snp.bottom).offset(15);
            maker.right.equalTo(-10);
            maker.bottom.equalTo(-15);
        }
        
//        supportCount = createLabel();
//        supportCount.text = "15";
//        supportCount.font = fontSize(size: 10);
//        supportCount.snp.makeConstraints { (maker) in
//            maker.right.equalTo(-10);
//            maker.bottom.equalTo(self.timeLabel.snp.bottom);
//        }
//
//        let supportIcon = createImageView();
//        supportIcon.image =  #imageLiteral(resourceName: "praise01.png");
//        supportIcon.snp.makeConstraints { (maker) in
//            maker.right.equalTo(self.supportCount.snp.left).offset(-4);
//            maker.centerY.equalTo(self.supportCount.snp.centerY);
//            maker.size.equalTo(CGSize.init(width: 17*0.8, height: 18*0.8));
//        }
//
//        isCollection = createImageView();
//        isCollection.isHidden = true;
//        isCollection.image = #imageLiteral(resourceName: "collect01.png");
//        isCollection.snp.makeConstraints { (maker) in
//            maker.right.equalTo(supportIcon.snp.left).offset(-8);
//            maker.centerY.equalTo(self.supportCount.snp.centerY);
//            maker.size.equalTo(CGSize.init(width: 17 * 0.8, height: 16 * 0.8));
//        }
//
//        commentLabel = createLabel();
//        commentLabel.font = fontSize(size: 10);
//        commentLabel.text = "12";
//        commentLabel.snp.makeConstraints { (maker) in
//            maker.right.equalTo(self.isCollection.snp.left).offset(-8)
//            maker.centerY.equalTo(self.supportCount.snp.centerY)
//
//        }
//
//        let commentIcon = createImageView();
//        commentIcon.image = #imageLiteral(resourceName: "comment.png");
//        commentIcon.snp.makeConstraints { (maker) in
//            maker.right.equalTo(self.commentLabel.snp.left).offset(-4);
//            maker.centerY.equalTo(self.supportCount.snp.centerY);
//            maker.size.equalTo(CGSize.init(width: 17*0.8, height: 16*0.8));
//        }
        
    }
    
    
    func configCellByModel(md: PageInfoListModel) -> Void {
        model = md;
        titleLabel.text = md.getTitle()
        desLabel.text = md.post_excerpt;
        timeLabel.text = md.post_date;
        sourceLabel.text = md.post_source;
        subTitleLabel.text = md.post_name;
        leftImage.sd_setImage(withURLString: md.cover_url);
        
    }
    
    func testView() {
        titleLabel.text = "朝着我们党确立的伟大目标奋勇前进";
        subTitleLabel.text = "新华社北京1月9日电";
        leftImage.image = UIImage(named:"");
        timeLabel.text = "2018年01月07日";
        sourceLabel.text = "央视网消息:";
        desLabel.text = "新年伊始，万象更新。1月5日至8日，新进中央委员会的委员、候补委员和省部级主要领导干部学习贯彻习近平新时代中国特色社会主义思想和党的十九大精神研讨班在中央党校举行。";
    }
}






