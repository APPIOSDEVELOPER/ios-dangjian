//
//  PersonDetialViewController.swift
//  StudyApp
//


import UIKit

class PersonDetialViewController: SuperBaseViewController {

    var dataSource: [String]!
    
    var tableHeader:BaseCustomView!
    
    var id = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = Bundle.main.path(forResource: "PersonList", ofType: "plist");
        
        dataSource = NSArray(contentsOfFile: path!) as! [String];
        
        createTable(delegate: self);
        baseTable.register(PersonTableCell.classForCoder(), forCellReuseIdentifier: "cell");
        baseTable.rowHeight = 50;
        
        
        tableHeader = BaseCustomView(frame: .init(x: 0, y: 0, width: sWidth, height: 140), type: .personDetial);
        baseTable.tableHeaderView = tableHeader;
        tableHeader.titleImageView.image = UIImage(named:"head_portrait_rect");
        tableHeader.backgroundColor = rgbColor(r: 126, g: 205, b: 244);

    }
    
    override func loadDataFromNet(net: Bool) {
        let request = UserRequest(value: "\(id)", jointType: .managerDetialId);
        request.loadJsonStringFinished { (result, success) in
            guard let model = result as? NSDictionary else{
                return;
            }
            printObject("model = \(model)");
        };
        
    }


    // MARK: - table view delgate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count;
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PersonTableCell;
        cell.titleLabel.text = dataSource[indexPath.row];
        cell.leftTitle.text = dataSource[indexPath.row];
        return cell;
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }

}


class PersonTableCell: BaseTableViewCell {
    
    var leftTitle: UILabel!
    
    
    override func initView() {
        leftTitle = createLabel(rect: .init(x: 25, y: 0, width: 100, height: 50), text: "");
//        leftTitle.snp.makeConstraints { (maker) in
//            maker.left.equalTo(10);
//            maker.height.equalTo(self.snp.height);
//            maker.top.equalTo(0);
//            maker.width.equalTo(100);
//        }
        
        let firstSepartar = createView(rect: .init(x: 110, y: 0, width: 4, height: 50));
        
        firstSepartar.backgroundColor = rgbColor(rgb: 246);
//        firstSepartar.snp.makeConstraints { (maker) in
//            maker.left.equalTo(self.leftTitle.snp.right).offset(10);
//            maker.top.equalTo(0);
//            maker.height.equalTo(self.snp.height);
//        }
        
        titleLabel = createLabel(rect: .init(x: 130, y: 0, width: sWidth - 140, height: 50), text: "");
        
        let dLine = createView(rect: .init(x: 10, y: 46, width: sWidth - 20, height: 4));
        dLine.backgroundColor = rgbColor(rgb: 246);
        
        
        
        
        
    }
}

