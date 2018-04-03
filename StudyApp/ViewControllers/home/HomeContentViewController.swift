//
//  HomeContentViewController.swift
//  StudyApp
//


import UIKit

class HomeContentViewController: SuperBaseViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    
    var navigateScrollView: FMBaseCollectionView!
    var pageCtrl: UIPageControl!
    
    @objc var id = 0;
    
    @objc var textTitle = "";
    
    private var currentIndex = 0;
    
    private var newModel: NewsModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createTable(frame: .init(x: 0, y: 0, width: width(), height: height() - 49 - 64 - 40), delegate: self);
        baseTable.rowHeight = UITableViewAutomaticDimension;
        baseTable.estimatedRowHeight = 110;
        baseTable.register(HomeTableCell.classForCoder(), forCellReuseIdentifier: "cell");
        baseTable.separatorStyle = .singleLine;
        baseTable.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            self.loadDataFromNet(net: true);
        });
        baseTable.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.currentIndex = 0;
            self.loadDataFromNet(net: true);
        });
        
        let layout = UICollectionViewFlowLayout();
        layout.itemSize = CGSize.init(width: sWidth, height:160);
        layout.scrollDirection = .horizontal;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        navigateScrollView = FMBaseCollectionView(frame: .init(x: 0, y: 0, width: sWidth, height: layout.itemSize.height), collectionViewLayout: layout);
        navigateScrollView.delegate = self;
        navigateScrollView.dataSource = self;
        navigateScrollView.register(HomeCollectionCell.classForCoder(), forCellWithReuseIdentifier: "cellIndex");
        navigateScrollView.isPagingEnabled = true;
        let headerVew = UIView(frame: .init(x: 0, y: 0, width: width(), height: navigateScrollView.height))
        headerVew.addSubview(navigateScrollView);
        
        pageCtrl = UIPageControl(frame: .init(x: width() - 60, y:headerVew.height - 20, width: 60, height: 20));
        pageCtrl.currentPage = 0;
        headerVew.addSubview(pageCtrl);
        pageCtrl.numberOfPages = 3;
        baseTable.tableHeaderView = headerVew;
        
    }
    
    override func loadDataFromNet(net: Bool) {
        self.currentIndex += 1;
        
        let request = UserRequest(colum: id, name: nil, pageNum: self.currentIndex);
        request.cls = NewsModel.classForCoder();
        request.loadJsonStringFinished { (result, success) in
            self.baseTable.mj_footer.endRefreshing();
            self.baseTable.mj_header.endRefreshing();
            
            
            guard let model = result as? BaseModel,
                let nModel = model.baseDataModel as? NewsModel else{
                return;
            }
            
            if self.currentIndex == 1 {
                self.newModel = nModel;
                let count = nModel.linksList.count;
                self.pageCtrl.numberOfPages = count;
            }else if self.newModel != nil ,
                let list = nModel.pageInfo?.pageList {
                
                 self.newModel.pageInfo.pageList.append(contentsOf: list);
            }
            self.baseTable.reloadData();
            self.navigateScrollView.reloadData();
            
            
        };
        
    }
    
    
    
    // scroll view delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView === navigateScrollView {
            let index = pageCtrl.currentPage;
            let scrollIndex = Int((scrollView.contentOffset.x + scrollView.width/2) / scrollView.width);
            if index != scrollIndex {
                pageCtrl.currentPage = scrollIndex;
            }
        }
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeTableCell;
        
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
        
        
//        let ctrl = HistoryViewController();
//        navigateCtrl.pushViewController(ctrl, animated: true);
        
        let model = newModel.pageInfo.pageList[indexPath.row];
        enterHTMLContent(url: model.getLinkURL(),id: model.id);
        
    }
    
    func enterHTMLContent(url: String,id: Int) -> Void {
        let ctrl = HTMLContentViewController();
        ctrl.linkURL = url;
        ctrl.id = id;
        ctrl.title = textTitle;
        navigateCtrl.pushViewController(ctrl, animated: true);
    }
    
    // MARK:- collection view delegate
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        guard let count = newModel?.linksList?.count else {
            return 0;
        }
        return count;
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellIndex", for: indexPath) as! HomeCollectionCell;
        
        guard let modelList = newModel?.linksList else {
            return cell;
        }
        if modelList.count > indexPath.row {
            let model = modelList[indexPath.row];
            cell.configCellByModel(md: model);
        }
        
        return cell;
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let model = newModel.linksList[indexPath.row];
        enterHTMLContent(url: model.link_url,id: 17);
    }
    
}

class HomeCollectionCell: BaseCollectionViewCell {
    
    var model: LinksEntityModel!
    
    
    override func initView() {
        
        imageView = createImageView();
        imageView.snp.makeConstraints { (maker) in
            maker.left.top.equalTo(0);
            maker.size.equalToSuperview();
        }
        
        let backTitleView = createLabel();
        backTitleView.backgroundColor = UIColor.black.withAlphaComponent(0.6);
        backTitleView.snp.makeConstraints { (maker) in
            maker.left.bottom.right.equalTo(0);
            maker.height.equalTo(30);
        }
        
        
        titleLabel = createLabel();
        titleLabel.text = "习近平,同志发表讲话,统一全国的军训,习近平,同志发表讲话,统一全国的军训";
        titleLabel.textColor = UIColor.white;
        titleLabel.numberOfLines = 1;
        titleLabel.font = fontSize(size: 12);
        titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(10);
            maker.right.equalTo(-80);
            maker.height.equalTo(backTitleView.snp.height);
            maker.bottom.equalTo(self.snp.bottom);
        }
    }
    
    func configCellByModel(md: LinksEntityModel) -> Void {
        titleLabel.text = md.link_name;
        imageView.sd_setImage(withURLString: md.link_image);
    }
}

class HomeTableCell: BaseTableViewCell {
    
    var commentLabel: UILabel!
    var newsModel: PageInfoListModel!
    
    let fSize: CGFloat = 20;
    
    override func initView() {
        leftImage = createImageView(rect: .zero);
        leftImage.contentMode = .scaleAspectFill;
        leftImage.clipsToBounds = true;
//        leftImage.backgroundColor = UIColor.red;
        
        leftImage.snp.makeConstraints { (maker) in
            maker.left.equalTo(10);
            maker.size.equalTo(CGSize.init(width: 140, height: 80));
            maker.top.equalTo(10);
            maker.bottom.equalTo(-10);
        }
        
        
        
        titleLabel = createLabel(rect: .zero, text: "习近平,同志发表讲话,统一全国的军训,习近平,同志发表讲话,统一全国的军训");
        titleLabel.numberOfLines = 2;
        titleLabel.font = fontSize(size: fSize);
        titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(leftImage.snp.right).offset(10);
            maker.right.equalToSuperview().offset(-10);
            maker.top.equalTo(11);
        }
        
        subTitleLabel = createLabel(rect: .zero, text: "2018-09-09");
        subTitleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.titleLabel.snp.left);
            maker.bottom.equalTo(self.leftImage.snp.bottom);
            maker.right.equalTo(self.titleLabel.snp.right);
        }
        subTitleLabel.numberOfLines = 1;
        subTitleLabel.font = fontSize(size: fSize - 3);
        subTitleLabel.textColor = rgbColor(rgb: 210);

        
        commentLabel = createLabel();
        commentLabel.text = "68评论";
        commentLabel.font = fontSize(size: fSize - 3)
        commentLabel.textColor = rgbColor(rgb: 210);
        commentLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(self.snp.right).offset(-10);
            maker.bottom.equalTo(self.subTitleLabel.snp.bottom);
        }
        
    }
    
    func configCellByModel(md: PageInfoListModel) -> Void {
        titleLabel.text = md.getTitle();
        subTitleLabel.text = "\(md.post_date)";
        commentLabel.text = "\(md.comment_count)评论"
        leftImage.sd_setImage(withURLString: md.cover_url);
        
    }
}


