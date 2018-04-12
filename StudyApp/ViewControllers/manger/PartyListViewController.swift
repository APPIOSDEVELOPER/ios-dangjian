//
//  PartyListViewController.swift
//  StudyApp
//


import UIKit

class PartyListViewController: SuperBaseViewController ,UISearchBarDelegate{
    
    private var dataSource = [String]();
    
    private var searchBarView: UISearchBar!
    
    private var currentIndex = 1;
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        searchBarView = UISearchBar.init(frame: .init(x: 40, y: 74, width: sWidth - 80, height: 35));
        addView(tempView: searchBarView);
        searchBarView.delegate = self;
        searchBarView.returnKeyType = .search;
        searchBarView.setBackgroundImage(UIImage(), for: .any, barMetrics: .default);
        searchBarView.setSearchFieldBackgroundImage(UIImage(named:"search_bg"), for: .normal);
        
        
        createTable(frame: .init(x: 0, y: searchBarView.maxY, width: sWidth, height: sHeight - searchBarView.maxY), delegate: self);
        baseTable.rowHeight = 64;
        baseTable.separatorStyle = .singleLine;
        baseTable.register(PersonListTableCell.classForCoder(), forCellReuseIdentifier: "cell");
        baseTable.sectionIndexBackgroundColor = rgbColor(rgb: 221);
        baseTable.sectionIndexTrackingBackgroundColor = UIColor.gray;
        baseTable.sectionIndexColor = UIColor.white;
        baseTable.register(UITableViewHeaderFooterView.classForCoder(), forHeaderFooterViewReuseIdentifier: "header");
        baseTable.sectionHeaderHeight = 12;
        
    }
    
    
    override func loadDataFromNet(net: Bool) {
        
        let request = UserRequest(value: "\(currentIndex)", jointType: .mangers);
        request.loadJsonStringFinished { (result, success) in
            guard let model = result as? NSDictionary else{
                return;
            }
            print("model = \(model)");
        };
        
    }
    
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    
    // MARK: - table view delgate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0;
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count;
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return UILocalizedIndexedCollation.current().sectionTitles;
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index;
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header");
        return headerView;
        
    }

    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PersonListTableCell;
        cell.leftImage?.image = UIImage(named:"part_list_\(indexPath.row)");
        cell.titleLabel?.text = "\(indexPath.row + 1) :" + dataSource[indexPath.row % dataSource.count];
        
        return cell;
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let ctrl = PersonDetialViewController();
        navigateCtrl.pushViewController(ctrl, animated: true);
        
        
    }
}

class PersonListTableCell: BaseTableViewCell {
    override func initView() {
        leftImage = createImageView(rect: .init(x: 10, y: 10, width: 44, height: 44));
        titleLabel = createLabel(rect: .init(x: 64, y: 0, width: sWidth - 84, height: 64), text: "");
        
    }
}
