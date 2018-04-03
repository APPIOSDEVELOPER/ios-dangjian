//
//  BeginAnwerViewController.swift
//  StudyApp
//
// 

import UIKit

class BeginAnwerViewController: SuperBaseViewController ,BaseCustomViewDelegate{
    
    

    var configButn: UIButton!
    var tableHeader: BaseCustomView!
    
    var id = 0;
    var selectedRow = -1;
    var selectedRows: [Int]!
    var anwserOpts: [String]!
    var questModel: QuestionListModel!
    var questionIndex = 0;
    
    var questionResult = [[String:Any]]();
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createTableHeader();

        createTable(frame: navigateRect, delegate: self);
        baseTable.register(QuestionTableCell.classForCoder(), forCellReuseIdentifier: "cell");
        baseTable.register(ButtonTableCell.classForCoder(), forCellReuseIdentifier: "button");
        baseTable.rowHeight = 50;
        baseTable.separatorInset = UIEdge(size: 15);
        baseTable.separatorStyle = .singleLine;
        baseTable.tableHeaderView = tableHeader;
        baseTable.backgroundColor = rgbColor(rgb: 246);
        
    }
    
    override func loadDataFromNet(net: Bool) {
        
        let request = UserRequest(value: "\(id)", jointType: .onlineAnswer);
        request.cls = QuestionListModel.classForCoder();
        request.loadJsonStringFinished {
            [weak self](result, sccess) in
            guard let model = result as? BaseModel else{
                return;
            }
            self?.questModel = model.baseDataModel as? QuestionListModel;
            self?.baseTable.reloadData();
            self?.tableHeader.baseView.countScond = (self?.questModel.countSecond)!;
            if let qModel = self?.questModel?.subject.first {
                self?.tableHeader.titleLabel.text = qModel.subject_name;
            }
            self?.tableHeader.baseView.beginTime();
        };
    }
    
    func commitResult() -> Void {
        
        let request = UserRequest(commited: questionResult);
        request.loadJsonStringFinished { (result, success) in
            guard let model = result as? NSDictionary else{
                return;
            }
            print("model = \(model)");
        };
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        
        

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        tableHeader.baseView.endTimer();
    }
    
    func createTableHeader() -> Void {
        tableHeader = BaseCustomView(frame: .init(x: 0, y: 0, width: width(), height: 160), type: .beginOptionView);
        tableHeader.baseView.delegate = self;
        tableHeader.titleLabel.text = "()是关系党的事业兴衰的第一位问题";
    }
    
    // base custom view delegate
    
    func overTime(view: BaseCustomView) {
        showTip(msg: "作对3道,错误7道,得分30", showCancel: false) { (tag) -> (Void) in
            self.navigationController?.popViewController(animated: true);
        };
    }
    
    func didFinishedTime(view: BaseCustomView) {
        
    }
    
    
    @objc override func buttonAction(btn: UIButton) {
        if let cell = btn.superview as? ButtonTableCell {
            cell.tag = 0;
//            commitResult();
//            let dict = [["subject_id":1,"option_opt":["a"]]];

            let qModel = questModel.subject[questionIndex];
            var dict = [String:Any]();
            dict["subject_id"] = qModel.id;
            dict["option_opt"] = anwserOpts;
            questionResult.append(dict);
            
            tableHeader.titleLabel.text = qModel.subject_name;
            
            print("dict = \(questionResult)");

            
            anwserOpts?.removeAll();
            selectedRow = -1;
            selectedRows?.removeAll();
            
            if questModel?.subject == nil {
                return;
            }
            questionIndex += 1;
            if questModel.subject.count > questionIndex {
                self.baseTable.reloadData();
            }else {
                commitResult();
                questionIndex -= 1;
            }
            return;
        }
    }
    
    // MARK: - table view delgate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let model = questModel.subject[questionIndex].optionEntity[indexPath.row];
        
        let rowHeight: CGFloat = model.isOption ? 48 : 100;
        return rowHeight;
        
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let list = questModel?.subject else {
            return 0;
        }
        
        if list.count > questionIndex {
            let count = list[questionIndex].optionEntity.count;
            return count;
            
        }
        return 0;
    }
    
    
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = questModel.subject[questionIndex].optionEntity[indexPath.row];
        
        if model.isOption {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! QuestionTableCell;
            cell.backgroundColor = UIColor.white;
            cell.selectedItem = false;
            cell.configCellByModel(md: model);
            
            return cell;
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "button", for: indexPath) as! ButtonTableCell;
        cell.btn.addTarget(self, action: #selector(buttonAction(btn:)), for: .touchUpInside);
//        cell.backgroundColor = 
        cell.btn.setTitle("下一题", for: .normal);
        return cell;
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
//        MobClick.event("study_id", attributes: ["__ct__":"12"]);
        
        guard let nextCell = tableView.cellForRow(at: indexPath) as? QuestionTableCell else{
            return;
        }
        
        let model = questModel.subject[questionIndex];
        
        if anwserOpts == nil {
            anwserOpts = [String]();
        }
        
        if model.isSingle {
            if indexPath.row != selectedRow {
                let preCell = tableView.cellForRow(at: IndexPath.init(row: selectedRow, section: 0)) as? QuestionTableCell;
                preCell?.selectedItem = false;
                
                
                nextCell.selectedItem = true;
                
                selectedRow = indexPath.row;
                
                anwserOpts.removeAll();
                anwserOpts.append(nextCell.model.option_opt);
            }
        }else {
            if selectedRows == nil {
                selectedRows = [Int]();
                anwserOpts = [String]();
            }
            
            if let idx = selectedRows.index(of: indexPath.row) {
                anwserOpts.remove(at: idx);
                
                let preCell = tableView.cellForRow(at: IndexPath.init(row: indexPath.row, section: 0)) as? QuestionTableCell;
                preCell?.selectedItem = false;
                
                selectedRows.remove(at: idx);
            }else {
                selectedRows.append(indexPath.row);
                
                nextCell.selectedItem = true;
                anwserOpts.append(nextCell.model.option_opt);

            }
            
            
        }
        
        
    }
    
  

}


class QuestionTableCell: BaseTableViewCell {
    
    var isSingle = true{
        didSet {
            
        }
    }
    var selectedItem = false {
        didSet{
            leftImage.isHighlighted = selectedItem;
        }
    }
    
    var model: OptionEntityModel!
    
    
    func configCellByModel(md: OptionEntityModel) -> Void {
        model = md;
        titleLabel.text = md.getQuestionLabel();
    }
    
    
    override func initView() {
        
        leftImage = createImageView();
        leftImage.image = #imageLiteral(resourceName: "Radio.png");
        leftImage.highlightedImage = #imageLiteral(resourceName: "pitch_on.png");
        leftImage.snp.makeConstraints { (maker) in
            maker.left.equalTo(15);
            maker.centerY.equalTo(self.snp.centerY);
            maker.size.equalTo(CGSize.init(width: 6, height: 6));
        }
        
        titleLabel = createLabel();
        titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.leftImage.snp.right).offset(10);
            maker.height.equalTo(self.snp.height);
            maker.top.equalTo(0);

        }
    }
    
    
}


class ButtonTableCell: BaseTableViewCell{
    var btn: UIButton!
    
    override func initView() {
        
        separatorInset = UIEdgeInsetsMake(0, sWidth, 0, 0);
        
        btn = createButton()
        btn.layer.cornerRadius = 4;
        btn.layer.masksToBounds = true;
        btn.setTitleColor(UIColor.white, for: .normal);
        btn.backgroundColor = rgbColor(r: 58, g: 122, b: 210);
        btn.snp.makeConstraints { (maker) in
            maker.left.equalTo(40);
            maker.centerY.equalTo(self.snp.centerY);
            maker.height.equalTo(40);
            maker.right.equalTo(-40);
        }
        
    }
    
    
}




