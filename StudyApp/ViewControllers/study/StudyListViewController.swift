//
//  StudyListViewController.swift
//  StudyApp
//

import UIKit

class StudyListViewController: SuperBaseViewController {
    
    var dataSource = [String]();
    
    @objc var id = 0;
    
    var newModel: NewsModel!

    var currentIndex = 1;
    
    @objc var subTitle = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createTable(frame: .init(x: 0, y: 0, width: width(), height: height() - 49 - 64 - 40), delegate: self);
        baseTable.estimatedRowHeight = 80;
        baseTable.rowHeight = UITableViewAutomaticDimension;
        
        baseTable.register(StudyTableCell.classForCoder(), forCellReuseIdentifier: "cell");
        view.backgroundColor = rgbColor(rgb: 246);
        baseTable.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            self.currentIndex += 1;
            self.loadDataFromNet(net: true);
        });
        
        baseTable.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.currentIndex = 1;
            self.loadDataFromNet(net: true);
        });
//        baseTable.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
//            self.loadDataFromNet(net: true);
//        });
        
//        headerView = BaseCustomView(frame: .init(x: 0, y: 0, width: sWidth, height: 35), type: .studyItemTitle);
//        baseTable.tableHeaderView = headerView;
        
        
        
    }
    override func loadDataFromNet(net: Bool) {
        
        let request = UserRequest(vedio: id, name: nil, pageNum: currentIndex);
        request.cls = NewsModel.classForCoder();
        request.loadJsonStringFinished { (result, success) in
            self.baseTable.mj_footer?.endRefreshing();
            self.baseTable.mj_header?.endRefreshing();
            
            guard let bModel = result as? BaseModel,
                let nModel = bModel.baseDataModel as? NewsModel else{
                return;
            }
            if self.currentIndex == 1 {
                self.newModel = nModel;
            }else if let list = nModel.pageInfo.pageList , self.newModel != nil{
                self.newModel.pageInfo.pageList.append(contentsOf: list);
            }
            self.baseTable.reloadData();
        };
        
    }
    

    
    
    // MARK: - table view delgate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = self.newModel?.pageInfo?.pageList?.count else {
            return 0;
        }
        return count;
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StudyTableCell;
        
        guard let listModel = self.newModel?.pageInfo?.pageList else {
            return cell;
        }
        if listModel.count > indexPath.row {
            
            let model = listModel[indexPath.row];
            cell.configCellByModel(model: model);
            

            
        }
        
        return cell;
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) as? StudyTableCell else {
            return;
        }
        
        let ctrl = MangerVideoViewController();
        ctrl.id = cell.pModel.id;
        ctrl.title = subTitle;
        navigateCtrl.pushViewController(ctrl, animated: true);
        
        
    }
    
}


class StudyTableCell: BaseTableViewCell {
    
    var playFlag: UIImageView!
    var pModel: PageInfoListModel!
    
    
    override func initView() {
        
        baseView = createView();
        baseView.backgroundColor = UIColor.white;
        baseView.snp.makeConstraints { (maker) in
            maker.left.equalTo(10);
            maker.top.equalTo(0);
            maker.right.equalTo(-10);
            maker.height.equalTo(100);
            maker.bottom.equalTo(-5);
        }
        
        leftImage = createImageView();
        leftImage.contentMode = .scaleAspectFill;
        leftImage.clipsToBounds = true;
        leftImage.snp.makeConstraints { (maker) in
            maker.left.equalTo(10);
            maker.top.equalTo(self.baseView.snp.top).offset(10);
            maker.size.equalTo(CGSize.init(width: 120, height: 80));
        };
        
        playFlag = UIImageView();
        playFlag.image = UIImage(named:"play@2x");
        leftImage.addSubview(playFlag);
        playFlag.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(60)
            maker.centerY.equalTo(45)
            maker.width.height.equalTo(28);
        }
        
        titleLabel = createLabel();
        titleLabel.font = fontSize(size: 17);
        titleLabel.numberOfLines = 2;
        titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.leftImage.snp.right).offset(10);
            maker.top.equalTo(self.leftImage.snp.top).offset(4);
            maker.right.equalTo(-20);
        }
        
        subTitleLabel = createLabel();
        subTitleLabel.textColor = rgbColor(rgb: 162);
        subTitleLabel.font = fontSize(size: 14);
        subTitleLabel.numberOfLines = 1;
        subTitleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.titleLabel.snp.left);
            maker.right.equalTo(self.titleLabel.snp.right);
            maker.bottom.equalTo(self.leftImage.snp.bottom);
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(4);
        }
        
    }
    
    func configCellByModel(model: PageInfoListModel) -> Void {
        pModel = model;
        leftImage.sd_setImage(withURLString: model.cover_url);
        titleLabel.text = pModel.getTitle()
        subTitleLabel.text = pModel.post_excerpt;
        
        
        
    }
    
}
