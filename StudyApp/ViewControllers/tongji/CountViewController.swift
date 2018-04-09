//
//  CountViewController.swift
//  StudyApp


import UIKit

class CountViewController: SuperBaseViewController {

    var dataModel: CountBordModel!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        createTable(delegate: self);
        
        baseTable.register(FirstTableCell.classForCoder(), forCellReuseIdentifier: "FirstTableCell");
        baseTable.register(SecondTableCell.classForCoder(), forCellReuseIdentifier: "SecondTableCell")
        baseTable.register(PNLineCharTableViewCell.classForCoder(), forCellReuseIdentifier: "PNLineCharTableViewCell")
        

    }
    
    
    override func loadDataFromNet(net: Bool) {
        let request = UserRequest(pathType: .board);
        request.loadJsonStringFinished { (result, success) in
            guard let dict = result as? NSDictionary else{
                return;
            }
            let model = BaseModel(anyCls: CountBordModel.classForCoder(), dict: dict);
            guard let entity = model.baseDataModel as? CountBordModel else{
                return;
            }
            self.dataModel = entity;
            self.baseTable.reloadData();
            
        };
        
    }
    
    
    // MARK: - table view delgate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 140;
        }
        if indexPath.row == 1 {
            return 170;
        }
        return 200;
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if  indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SecondTableCell", for: indexPath) as! SecondTableCell;
            cell.titleLabel?.text = "党委----党支部信息数";
            cell.configCell(model: dataModel);
            return cell;
        }else if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FirstTableCell", for: indexPath) as! FirstTableCell;
            cell.configCell(model: dataModel);
            return cell;
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "PNLineCharTableViewCell", for: indexPath) as! PNLineCharTableViewCell;
        if let list = dataModel?.weekInfoCount {
            cell.config(list: list);
        }
        return cell;
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }

    

}


class FirstTableCell: BaseTableViewCell ,UICollectionViewDelegate,UICollectionViewDataSource{
    
    var collectioinView: FMBaseCollectionView!
    var dataSource = ["党员人数","党委人数","党支部"];
    var countsList: [String]!
    
    override func initView() {
        let layout = UICollectionViewFlowLayout();
        layout.itemSize = CGSize.init(width: 70, height: 120);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = (sWidth - 210 - 61)/2;
        layout.sectionInset = UIEdgeInsetsMake(10, 30, 0, 30);
        
        collectioinView = FMBaseCollectionView(frame: .init(x: 0, y: 20, width: sWidth, height: layout.itemSize.height), collectionViewLayout: layout)
        collectioinView.register(TongJiColletionCell.classForCoder(), forCellWithReuseIdentifier: "cellIndex");
        collectioinView.delegate = self;
        collectioinView.dataSource = self;
        collectioinView.isScrollEnabled = false;
        addSubview(collectioinView);
        
    }
    
    func configCell(model: CountBordModel?) -> Void {
        guard let model = model else {
            return;
        }
        countsList = [String]();
        countsList.append(model.memberCount);
        countsList.append(model.committeeCount);
        countsList.append(model.branchCount);
        collectioinView.reloadData();
    }
    
    // MARK:- collection view delegate
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return dataSource.count;
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellIndex", for: indexPath) as! TongJiColletionCell;
        cell.imageView.image = UIImage(named:"count_party_\(indexPath.row)");
        cell.titleLabel.text = dataSource[indexPath.row];
        cell.titleLabel.textColor = rgbColor(rgb: 203);
        if countsList != nil && countsList.count > indexPath.row {
            let cd = countsList[indexPath.row];
            cell.countLabel.text = cd;
        }
        
        return cell;
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
    }
}

class TongJiColletionCell: BaseCollectionViewCell {
    var countLabel: UILabel!
    
    override func initView() {
        if titleLabel != nil {
            return;
        }
        
        titleLabel = createLabel();
        titleLabel.textAlignment = .center;
        imageView = createImageView();
        imageView.contentMode = .scaleAspectFit;
        imageView.snp.makeConstraints({ (maker) in
            maker.width.height.equalTo(self.snp.width).offset(-20);
            maker.top.equalTo(0);
            maker.left.equalTo(10);
        })
        
        countLabel = createLabel();
        countLabel.text = "40";
        countLabel.textAlignment = .center;
        countLabel.font = fontSize(size: 16);
        countLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(0);
            maker.top.equalTo(self.imageView.snp.bottom).offset(6);
        }
        
        titleLabel.snp.makeConstraints({ (maker) in
            maker.left.right.equalTo(0);
            maker.top.equalTo(self.countLabel.snp.bottom).offset(6);
        })
    }
    
}

class SecondTableCell: BaseTableViewCell {
    
    var leftTitle: UILabel!
    var rightTitle: UILabel!
    
    
    override func initView() {
        titleLabel = createLabel();
        titleLabel.textAlignment = .center;
        titleLabel.snp.makeConstraints { (maker) in
            maker.left.top.equalTo(20);
            maker.right.equalTo(-20);
        }
        
        let backView = createView();
        backView.backgroundColor = rgbColor(rgb: 246);
        backView.layer.borderColor = rgbColor(rgb: 203).cgColor;
        backView.layer.borderWidth = 1;
        backView.snp.makeConstraints { (maker) in
            maker.left.equalTo(10);
            maker.right.equalTo(-10);
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(30);
            maker.bottom.equalTo(-20);
        }
        
        leftTitle = createLabel();
        leftTitle.textAlignment = .center;
        leftTitle.snp.makeConstraints { (maker) in
            maker.left.equalTo(backView.snp.left);
            maker.right.equalTo(backView.snp.centerX);
            maker.centerY.equalTo(backView.snp.centerY);
        }
        
        rightTitle = createLabel();
        rightTitle.textAlignment = .center;
        rightTitle.snp.makeConstraints { (maker) in
            maker.left.equalTo(backView.snp.centerX);
            maker.right.equalTo(backView.snp.right);
            maker.centerY.equalTo(backView.snp.centerY);
        }
    }
    func configCell(model: CountBordModel?) -> Void {
        
        
        guard let model = model else {
            return;
        }
        
        let leftSecondText = "今日工作信息数";
        let leftFirstText = model.todayInfoCount;
        let nextLine = "\n";
        
        let leftText = NSMutableAttributedString(string: leftFirstText + nextLine + leftSecondText);
        
        leftText.addAttributes([NSAttributedStringKey.font:fontSize(size: 20),NSAttributedStringKey.foregroundColor:rgbColor(r: 218, g: 74, b: 76)], range: NSRange.init(location: 0, length: leftFirstText.count));
//        leftText.addAttributes([NSAttributedStringKey.font:fontSize(size: 14)], range: NSRange.init(location: leftFirstText.count + nextLine.count, length: leftSecondText.count));
        
        leftTitle.attributedText = leftText;
        
        
        let rightFirstText = model.totleInfoCount;
        let rightSecondText = "全部工作信息数";
        
        let rightAttribute = NSMutableAttributedString(string: rightFirstText + nextLine + rightSecondText);
        rightAttribute.addAttributes([NSAttributedStringKey.font:fontSize(size: 20),NSAttributedStringKey.foregroundColor:rgbColor(r: 0, g: 170, b: 223)], range: NSRange.init(location: 0, length: rightFirstText.count));
        
        rightTitle.attributedText = rightAttribute;
//        rightAttribute.addAttributes([NSAttributedStringKey.font:fontSize(size: 14)], range: NSRange.init(location: rightFirstText.count + nextLine.count, length: rightSecondText.count));
        
        
    }
}

class PNLineCharTableViewCell: BaseTableViewCell {
    private var lineChar: PNLineChart!
    private var dataItem: PNLineChartData!
    override func initView() {
        lineChar = PNLineChart(frame: .init(x: 10, y: 10, width: sWidth - 20, height: 180));
        addSubview(lineChar);
        lineChar.xLabels = ["周日","周一","周二","周三","周四","周五","周六"];
        lineChar.showLabel = true;
        lineChar.showGenYLabels = true;
        lineChar.showYGridLines = true;
        lineChar.showSmoothLines = false;
        lineChar.isShowCoordinateAxis = true;
        lineChar.axisColor = rgbColor(rgb: 211);
        lineChar.axisWidth = 2;
        
        lineChar.thousandsSeparator = true;
        lineChar.yLabelColor = UIColor.red;
        lineChar.yGridLinesColor = UIColor.lightGray;
        
        dataItem = PNLineChartData.init();
        dataItem.color = rgbColor(r: 236, g: 138, b: 116);
        dataItem.inflexionPointStyle = .circle;
        dataItem.showPointLabel = true;

        dataItem.pointLabelColor = UIColor.red;
        dataItem.pointLabelFont = fontSize(size: 12);
        dataItem.pointLabelFormat = "%1.1f";
        
        
    }
    
    func config(list: [Int]) -> Void {
        
        dataItem.itemCount = UInt(list.count);

        dataItem.getData = {
            (index) -> PNLineChartDataItem in
            return PNLineChartDataItem(y: CGFloat(list[Int(index)]));
        }
        lineChar.chartData = [dataItem];
        lineChar.stroke();
    }
    
}


class CountBordModel: BaseModel {
    @objc var todayInfoCount = "0";
    @objc var memberCount = "1";
    @objc var committeeCount = "0";
    @objc var branchCount = "0";
    @objc var totleInfoCount = "0";
    @objc var weekInfoCount: [Int]!
    
    override func setValue(_ value: Any?, forKey key: String) {
        
        switch key {
        case "weekInfoCount":
            guard let dict = value as? NSDictionary else{
                return ;
            }
            weekInfoCount = [Int]();
            for item in dict {
                guard let countStr = item.value as? String,
                 let count = Int(countStr) else{
                    continue;
                }
                
                
                weekInfoCount.append(count);
            }
            
        default:
            super.setValue(value, forKey: key);
        }
        

    }

}





