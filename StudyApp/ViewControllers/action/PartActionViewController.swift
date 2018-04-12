//
//  PartActionViewController.swift
//  StudyApp
//

import UIKit

class PartActionViewController: SuperBaseViewController {

    var tableHeader: UIImageView!
    var aModel: ActionModel!
    var currentIndex = 0;
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = rgbColor(rgb: 246);
        
        createTable(frame: navigateRect, delegate: self);
        baseTable.rowHeight = UITableViewAutomaticDimension;
        baseTable.estimatedRowHeight = 80;
        baseTable.register(PartActionTableCell.classForCoder(), forCellReuseIdentifier: "cell");
        
        tableHeader = createImageView(rect: .init(x: 0, y: 0, width: width(), height: 160), name: "banner_img02");
        tableHeader.removeFromSuperview();
        baseTable.tableHeaderView = tableHeader;
        
        baseTable.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.currentIndex = 0;
            self.loadDataFromNet(net: true);
        });
        baseTable.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            self.loadDataFromNet(net: true);
        });
    }
    
    override func loadDataFromNet(net: Bool) {
        currentIndex += 1;
        let request = UserRequest(value: "\(currentIndex)", jointType: .actionOther);
        request.cls = ActionModel.classForCoder();
        request.loadJsonStringFinished { (result, success) in
            self.baseTable.mj_header?.endRefreshing();
            self.baseTable.mj_footer?.endRefreshing();
            guard let model = result as? BaseModel else{
                return;
            }
            if self.currentIndex == 1 {
                self.aModel = model.baseDataModel as? ActionModel;
                self.baseTable.reloadData();
            }
            
        };
    }

    // MARK: - table view delgate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = aModel?.modelList?.count else {
            return 0;
        }
        return count;
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PartActionTableCell;
        guard let list = aModel?.modelList else {
            return cell;
        }
        if list.count > indexPath.row {
            let model = list[indexPath.row];
            cell.configCellByModel(md: model);
//            cell.titleLabel.text = "为新时代发展提供坚强政治和组织保证";
//            cell.subTitleLabel.text = "北京市市委书记 马宝玉";
//            cell.flagLabel.text = "学时:8分钟";
        }
        
        return cell;
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) as? PartActionTableCell else {
            return;
        }
        
        if !UserInfoModel.isLogin() {
            let ctrl = SettingViewController();
            ctrl.operationType = .login;
            navigateCtrl.pushViewController(ctrl, animated: true);
            return;
        }
        
        let ctrl = BeginAnwerViewController();
        ctrl.id = cell.model.id;
        ctrl.title = cell.model.square_name;
        navigateCtrl.pushViewController(ctrl, animated: true);
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let ctrl = BeginAnwerViewController();
//        navigateCtrl.pushViewController(ctrl, animated: true);
    }
}

class PartActionTableCell: BaseTableViewCell {
    
    var flagLabel:UILabel!
    var model: ActionModel.ActionInfoModel!
    
    let fSize: CGFloat = 20;
    
    
    func configCellByModel(md: ActionModel.ActionInfoModel) -> Void {
        model = md;
        titleLabel.text = model.square_name;
        subTitleLabel.text = model.square_author;
        flagLabel.text = "学时:\(model.square_time)分钟";
//        leftImage.sd_setImage(withURLString: model.square_photo);
    }
    
    
    override func initView() {
        baseView = createView();
        baseView.backgroundColor = UIColor.white;
        baseView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(0);
            maker.top.equalTo(10);
//            maker.height.equalTo(70);
            maker.bottom.equalTo(-10);
        }
        
        flagLabel = createLabel();
        flagLabel.numberOfLines = 1;
        flagLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(-10);
            maker.bottom.equalTo(-20);
        }
        
        titleLabel = createLabel();
        titleLabel.font = fontSize(size: fSize);
        titleLabel.numberOfLines = 2;
        titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(10);
            maker.right.equalTo(self.snp.right).offset(-20);
            maker.top.equalTo(20);
        }
        
        subTitleLabel = createLabel();
        subTitleLabel.numberOfLines = 1;
        subTitleLabel.font = fontSize(size: fSize - 3);
        subTitleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.titleLabel.snp.left);
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(5);
            maker.right.equalTo(self.titleLabel.snp.right);
            maker.bottom.equalTo(self.snp.bottom).offset(-20)
        }
    }
}



