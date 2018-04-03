//
//  PartyManagerViewController.swift
//  StudyApp
//

import UIKit

class PartyManagerViewController: SuperBaseViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    var dataSource = [String]();
    
    var sepratarLineView: BaseCustomView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = rgbColor(rgb: 246);
        
        setBackStyle();

        
        title = "功能管理";
        
        dataSource.append("党建e连心");
        dataSource.append("党员档案");
        dataSource.append("党组织管理");
        dataSource.append("党费管理");
        dataSource.append("党建看板");
        dataSource.append("党建百宝箱");
        
        let titleImageView = createImageView(rect: .init(x: 0, y: 60, width: sWidth, height: sWidth * 450 / 750), name: "party_manager_title");
        titleImageView.autoresizingMask = [.flexibleWidth,.flexibleBottomMargin];
        titleImageView.contentMode = .scaleAspectFill;
        titleImageView.clipsToBounds = true;
        
        
        sepratarLineView = BaseCustomView(frame: .init(x: 0, y: titleImageView.maxY + 5, width: sWidth, height: 36), type: .managerLineView);
        addView(tempView: sepratarLineView);
        
        
        let layout = UICollectionViewFlowLayout();
        layout.sectionInset = UIEdgeInsetsMake(20, 18, 10, 18);
        let scalePad: CGFloat = iOSIPhoneInfoData.isIphone1_5 ? 10 : 35;
        
        layout.minimumLineSpacing = scalePad;
        layout.minimumInteritemSpacing = scalePad;
        let pw = (width() - scalePad * 2 - 37)/3;
        layout.itemSize = CGSize.init(width: pw, height: pw);

        createCollection(frame: .init(x: 0, y: sepratarLineView.maxY, width: sWidth, height: height() - sepratarLineView.maxY - 49), layout: layout, delegate: self);
        baseCollectionView.register(ManagerCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "cell");
        
        

    }
    
    
    override func loadDataFromNet(net: Bool) {
//        let request = UserRequest(pathType: .allApp);
//        request.loadJsonStringFinished { (result, success) in
//            guard let dict = result as? NSDictionary else{
//                return;
//            }
//            print("dict = \(dict)");
//        }
    }

    // MARK:- collection view delegate
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return dataSource.count;
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ManagerCollectionViewCell;
        cell.imageView.image = UIImage(named:"party_manager_\(indexPath.row)");
        cell.titleLabel.text = dataSource[indexPath.row];
        
        return cell;
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        
        switch indexPath.row {
        case 0:
            let ctrl = NewsListViewController();
            ctrl.title = dataSource[indexPath.row];
            navigateCtrl.pushViewController(ctrl, animated: true);
        case 1:
            let ctrl = PartyListViewController();
            ctrl.title = dataSource[indexPath.row];
            navigateCtrl.pushViewController(ctrl, animated: true);
            
        case 2:
            let ctrl = MapUntilViewController();
            ctrl.title = dataSource[indexPath.row];
            navigateCtrl.pushViewController(ctrl, animated: true);
        case 3:
            let ctrl = PartyPayManagerViewController();
            ctrl.title = dataSource[indexPath.row];

            navigateCtrl.pushViewController(ctrl, animated: true);
            
        case 4:
            let ctrl = CountViewController();
            ctrl.title = dataSource[indexPath.row];

            navigateCtrl.pushViewController(ctrl, animated: true);
        case 5:
            let ctrl = FunViewController();
            ctrl.title = dataSource[indexPath.row];

            navigateCtrl.pushViewController(ctrl, animated: true);
        default:
            break;
        }
        

    }

}


class ManagerCollectionViewCell: BaseCollectionViewCell {
    
    var backImageView: UIImageView!
    
    override func initView() {
        backImageView = createImageView();
        backImageView.image = UIImage(named:"party_manager_background");
        backImageView.snp.makeConstraints { (maker) in
            maker.edges.equalTo(UIEdge(size: 0));
        }
        
        imageView = createImageView();
        imageView.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(self.snp.centerX);
            maker.centerY.equalTo(self.snp.centerY).offset(-10);
            maker.size.equalTo(CGSize.init(width: 31, height: 31));
        }
        titleLabel = createLabel();
        titleLabel.numberOfLines = 1;
        titleLabel.textAlignment = .center;
        titleLabel.font = fontSize(size: 14);
        titleLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(self.snp.centerX);
            maker.top.equalTo(self.imageView.snp.bottom).offset(5);
        }
    }
}





