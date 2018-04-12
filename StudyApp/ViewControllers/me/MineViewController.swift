//
//  MineViewController.swift
//  StudyApp
//


import UIKit

class MineViewController: SuperBaseViewController {
    
    var backImageIcon: UIImageView!
    var dataSource: [MeListItemModel]!
    var nameLabel: UILabel!
    var isFistAppear = true;
    
    var isUpAlto = true;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = Bundle.main.url(forResource: "MeListItem", withExtension: "plist");
        let dataArray = NSArray(contentsOf: path!)!;
        dataSource = [MeListItemModel]();
        for item in dataArray {
            let model = MeListItemModel(anyData: item);
            dataSource.append(model);
        }
        
        view.backgroundColor = rgbColor(rgb: 246);
        
        backImageIcon = createImageView(rect: .init(x: 0, y: 64, width: sWidth, height: 160), name: "");
        backImageIcon.contentMode = .scaleAspectFill;
        backImageIcon.image = UIImage(named:"head_bg");
        
        let maskView = createView(rect: .init(x: 0, y: 64, width: sWidth, height: 160));
        maskView.backgroundColor = UIColor.white.withAlphaComponent(0.85);
        
        titleImageView = createImageView(rect: .init(x: (sWidth - 70)/2, y: 64 + 50, width: 70, height: 70), name: "");
        titleImageView.layer.cornerRadius = 35;
        titleImageView.clipsToBounds = true;
        titleImageView.image = UIImage(named:"head_portrait");
        addTarget(target: self, selector: #selector(gestureAction(tap:)), subView: titleImageView, delegate: nil);
        
        nameLabel = createLabel(rect: .init(x: 40, y: titleImageView.maxY + 6, width: sWidth - 80, height: 20), text: "");
        nameLabel.textAlignment = .center;
        nameLabel.font = fontSize(size: 14);
        nameLabel.textColor = UIColor.darkText;
        nameLabel.isHidden = true;
        
        
        
        createTable(frame: .init(x: 0, y: backImageIcon.maxY, width: sWidth, height: height() - backImageIcon.maxY - 49), delegate: self);
        baseTable.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
        baseTable.register(MineTableCell.classForCoder(), forCellReuseIdentifier: "cell");
        baseTable.separatorStyle = .none;
        baseTable.rowHeight = 60;
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        if isFistAppear {
            isFistAppear = false;
        }else{
            if isUpAlto {
                loadDataFromNet(net: false);
            }
            isUpAlto = true;
        }
        
    }
    
 
    
    func reloadDataByModel(md: UserInfoModel) -> Void {
        nameLabel.text = md.name;
        guard let url = md.getPhotoURL() else {
            return;
        }
        titleImageView.sd_setImage(with: url, completed: { (image, error, type, urls) in
//            self.backImageIcon.image = image;
        });
        
    }
    
    override func loadDataFromNet(net: Bool) {
        
        let request = UserRequest(pathType: .userDetial);
        request.cls = UserInfoModel.classForCoder();
        request.loadJsonStringFinished { (result, success) in
            guard let model = result as? BaseModel ,
             let md = model.baseDataModel as? UserInfoModel else{
                return;
            }
            self.reloadDataByModel(md: md);
        };
        
        
    }
    
    @objc func gestureAction(tap:UITapGestureRecognizer) -> Void {
        self.showSystemCamera();
    }
 
    override func didSelectedImage(info: [String : Any], image: UIImage) {
        titleImageView.image = image;
//        let cgimage = image.cgImage?.cropping(to: backImageIcon.frame.insetBy(dx: 60, dy: 60));
//        backImageIcon.image = UIImage(cgImage: cgimage!, scale: iOSIPhoneInfoData.scale, orientation: .up);
        
        isUpAlto = false;
        
        let request = UserRequest(alterImage: image);
        request.respType = .typeModel;
        request.loadJsonStringFinished { (result, success) in
            
            
            guard let model = result as? BaseModel else{
                return;
            }
            self.showTip(msg:model.result_msg);
            
        };
        
    }
    
    //            guard let dict = result as? NSDictionary,let code = dict["result_code"] as? Int else{
    //                return;
    //            }
    //            if code == ResultCodeType.success.rawValue {
    //
    //            }
    
    // MARK: - table view delgate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count;
    }
    
    
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MineTableCell;
        let model = dataSource[indexPath.row];
        
        cell.titleLabel?.text = model.name;
        let imageName = model.image;
        cell.leftImage?.image = UIImage(named:imageName);
        return cell;
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = dataSource[indexPath.row];
        let name = model.name;
        let type = model.type;
        
        if type == 0 {
            let ctrl = PersonDetialViewController();
            ctrl.title = name;
            ctrl.id = UserInfoModel.getUserId();
            navigateCtrl.pushViewController(ctrl, animated: true);
        }else if type == 2{
            let ctrl = SettingViewController();
            ctrl.operationType = .alterPass;
            navigateCtrl.pushViewController(ctrl, animated: true);
        }else if type == 3{
            
            UserInfoModel.logoutApp();
            navigateCtrl.popViewController(animated: true);
            tabbarCtrl.selectedIndex = 0;
            navigateCtrl.navigationBar.topItem?.title = "党建";
            
        }else if type == 1 {
            
            let ctrl = SettingViewController();
            ctrl.operationType = .alterUser;
            navigateCtrl.pushViewController(ctrl, animated: true);
//
        }else if type == 4 {
            let ctrl = PhotoListViewController();
            navigateCtrl.pushViewController(ctrl, animated: true);
        }else if type == 5 {
            let ctrl = PartyManagerViewController();
            navigateCtrl.pushViewController(ctrl, animated: true);
        }else if type == 6 {
            let ctrl = MyClsViewController();
            navigateCtrl.pushViewController(ctrl,animated:true);
        }
    }
    

}

class MineTableCell: BaseTableViewCell{
    
    
    override func initView() {
        baseView = createView(rect: .init(x: 0, y: 0, width: sWidth, height: 50));
        baseView.backgroundColor = UIColor.white;
        
        leftImage = createImageView(rect: .init(x: 10, y: 10, width: 30, height: 30));
        leftImage.contentMode = .scaleAspectFit;
        titleLabel = createLabel(rect: .init(x: 50, y: 0, width: sWidth - 60, height: 50), text: "");
        titleLabel.font = fontSize(size: 14);
        
        
    }
}

class MeListItemModel: BaseModel {
    @objc var name = "";
    @objc var type = 0;
    @objc var image = "";

}



