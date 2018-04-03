//
//  MsgListViewController.swift
//  StudyApp
//


import UIKit

class MsgListViewController: SuperBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "消息";

        createTable(delegate: self);
        baseTable.register(BaseTableViewCell.classForCoder(), forCellReuseIdentifier: "cell");
        baseTable.separatorStyle = .singleLine;
        baseTable.rowHeight = 44;
        baseTable.estimatedRowHeight = 44;
    }

    // MARK: - table view delgate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10;
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath);
        cell.textLabel?.text = "消息列表";
        return cell;
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let ctrl = MsgDeitalViewController();
        navigateCtrl.pushViewController(ctrl, animated: true);
        
        
    }
    

}
