//
//  SalaryListViewController.swift
//  StudyApp
//


import UIKit

class SalaryListViewController: SuperBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        createTable(delegate: self);
        baseTable.register(SalaryTableViewCell.classForCoder(), forCellReuseIdentifier: "SalaryTableViewCell");
        baseTable.rowHeight = UITableViewAutomaticDimension;
        baseTable.estimatedRowHeight = 80;
        baseTable.backgroundColor = rgbColor(rgb: 246);
    }

    // MARK: - table view delgate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10;
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SalaryTableViewCell", for: indexPath) as! SalaryTableViewCell;
        cell.textLabel?.text = "";
        return cell;
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    

}

class SalaryTableViewCell: BaseTableViewCell {
    
    override func initView() {
        baseView = createView();
        baseView.backgroundColor = UIColor.white;
        baseView.snp.makeConstraints { (maker) in
            maker.left.top.equalTo(20);
            maker.right.equalTo(-20);
            maker.height.equalTo(40);
            maker.bottom.equalTo(-30);
        }
        
        titleLabel = createLabel();
        titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.baseView.snp.left).offset(10);
            maker.height.equalTo(self.baseView.snp.height);
            maker.top.equalTo(self.baseView.snp.top);
        }
    }
}
