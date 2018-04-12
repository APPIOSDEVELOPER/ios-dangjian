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
    lazy var selectedRows = [Int]();
    lazy var anwserOpts = [String]()
    var questModel: QuestionListModel!
    var questionIndex = 0;
    
    var questionResult = [[String:Any]]();
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createTableHeader();

        createTable(frame: navigateRect, delegate: self);
        baseTable.register(QuestionTableCell.classForCoder(), forCellReuseIdentifier: "cell");
        baseTable.register(ButtonTableCell.classForCoder(), forCellReuseIdentifier: "button");
        baseTable.rowHeight = UITableViewAutomaticDimension;
        baseTable.estimatedRowHeight = 50;
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
//            self?.tableHeader.baseView.countScond = (self?.questModel.countSecond)!;
            if let qModel = self?.questModel?.subject.first {
                
                let sized = qModel.subject_name.size(size: .init(width: self!.width() - 40, height: CGFloat.greatestFiniteMagnitude), font: 14);
                
                self?.tableHeader.frame = .init(x: 0, y: 0, width:self!.width(), height: sized.height + 120);
                self?.tableHeader.titleLabel.text = qModel.subject_name;

            }
            self?.tableHeader.subTitleLabel.text = "1/\(self!.questModel.subject.count)"

//            self?.tableHeader.baseView.beginTime();
        };
    }
    
    func commitResult() -> Void {
        
        SVProgressHUD.show(withStatus: "正在上传")
        let request = UserRequest(commited: questionResult);
        request.respType = .typeModel;
        request.loadJsonStringFinished { (result, success) in
            SVProgressHUD.dismiss();
            guard let model = result as? BaseModel else{
                self.showTip(msg: "上传失败", showCancel: false, finsihed: { (tag ) -> (Void) in
                    navigateCtrl.popViewController(animated: true);
                })
                return;
            }
            if model.isSuccess {
                self.showTip(msg: "上传成功", showCancel: false, finsihed: { (tag ) -> (Void) in
                    navigateCtrl.popViewController(animated: true);
                })
            }else{
                self.showTip(msg: model.result_msg, showCancel: false, finsihed: { (tag ) -> (Void) in
                    navigateCtrl.popViewController(animated: true);
                })
            }
            
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
//        tableHeader.baseView.endTimer();
    }
    
    func createTableHeader() -> Void {
        tableHeader = BaseCustomView(frame: .init(x: 0, y: 0, width: width(), height: 200), type: .beginOptionView);
//        tableHeader.baseView.delegate = self;
        tableHeader.titleLabel.numberOfLines = 0;
        tableHeader.titleLabel.text = "()是关系党的事业兴衰的第一位问题";
    }
    
    // base custom view delegate
    
    func overTime(view: BaseCustomView) {
        showTip(msg: "时间到了,必须提交", showCancel: false) { (tag) -> (Void) in
            
        };
    }
    
    func didFinishedTime(view: BaseCustomView) {
        
    }
    
    
    @objc override func buttonAction(btn: UIButton) {
        if let cell = btn.superview as? ButtonTableCell {
            cell.rightImage.isHidden = false;


            let qModel = questModel.subject[questionIndex];
           
            if qModel.isSingle && qModel.optionEntity.count > selectedRow && selectedRow > -1 {

                let selectedAwser = qModel.optionEntity[selectedRow];
                cell.rightImage.isHighlighted = selectedAwser.isRight
                
            }else {
                var isRight = true;
                for item in qModel.optionEntity.enumerated() {
                    if item.element.isRight && !selectedRows.contains(item.offset) {
                        isRight = false;
                        break;
                    }else if !item.element.isRight && selectedRows.contains(item.offset) {
                        isRight = false;
                        break;
                    }
                }
                cell.rightImage.isHighlighted = isRight;

                
            }
            self.view.isUserInteractionEnabled = false;
            perform(#selector(reloadDataByDelay), with: nil, afterDelay: 2);
            

        }
    }
    
    @objc func reloadDataByDelay() -> Void {
        
        defer {
            self.view.isUserInteractionEnabled = true;
        }
        
        guard let subject = questModel?.subject else {
            return;
        }
        
        
        let qModel = subject[questionIndex];
        var dict = [String:Any]();
        dict["subject_id"] = qModel.id;
        dict["option_opt"] = anwserOpts;
        questionResult.append(dict);
        
        anwserOpts.removeAll();
        selectedRow = -1;
        selectedRows.removeAll();
        
        
        questionIndex += 1;
        
        if subject.count > questionIndex {
            
            let sized = qModel.subject_name.size(size: .init(width: width() - 40, height: CGFloat.greatestFiniteMagnitude), font: 14);
            tableHeader.frame = .init(x: 0, y: 0, width: width(), height: sized.height + 120);
            
            tableHeader.titleLabel.text = qModel.subject_name;
            
            self.baseTable.reloadData();
            tableHeader.subTitleLabel.text = "\(questionIndex + 1)/\(subject.count)"

        }else {
//            let sized = "".size(size: .init(width: width() - 40, height: CGFloat.greatestFiniteMagnitude), font: 14);
//            tableHeader.frame = .init(x: 0, y: 0, width: width(), height: sized.height + 120);
//            tableHeader.titleLabel.text = "";
//
//            self.baseTable.reloadData();
            commitResult();
            questionIndex -= 1;
        }
    }
    
    // MARK: - table view delgate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
//        let model = questModel.subject[questionIndex].optionEntity[indexPath.row];
//
//        let rowHeight: CGFloat = model.isOption ? 48 : 100;
//        return rowHeight;
//
//    }
    
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
        
        let supModel = questModel.subject[questionIndex];
        let model = supModel.optionEntity[indexPath.row];
        
        if model.isOption {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! QuestionTableCell;
            cell.backgroundColor = UIColor.white;
            cell.configCellByModel(md: model);
            if supModel.isSingle {
                cell.selectedItem = selectedRow == indexPath.row;
            }else {
                cell.selectedItem = selectedRows.contains(indexPath.row);
                
            }
            return cell;
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "button", for: indexPath) as! ButtonTableCell;
        cell.btn.addTarget(self, action: #selector(buttonAction(btn:)), for: .touchUpInside);
        cell.btn.setTitle("下一题", for: .normal);
        cell.addAnwserFlag();
        cell.rightImage.isHidden = true;
        cell.btn.isEnabled = false;
        return cell;
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let model = questModel.subject[questionIndex];

        
        let btnCell = tableView.cellForRow(at:IndexPath.init(row: model.optionEntity.count - 1, section: 0)) as? ButtonTableCell;
        
        
        
//        MobClick.event("study_id", attributes: ["__ct__":"12"]);
        
        guard let nextCell = tableView.cellForRow(at: indexPath) as? QuestionTableCell else{
            return;
        }
        

        
        if model.isSingle {
            if indexPath.row != selectedRow {
                let preCell = tableView.cellForRow(at: IndexPath.init(row: selectedRow, section: 0)) as? QuestionTableCell;
                preCell?.selectedItem = false;
                
                nextCell.selectedItem = true;
                
                selectedRow = indexPath.row;
                
                anwserOpts.removeAll();
                anwserOpts.append(nextCell.model.option_opt);
            }else{
                selectedRow = -1;
                nextCell.selectedItem = false;
                anwserOpts.removeAll();

            }
            
            
        }else {
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
        btnCell?.btn.isEnabled = anwserOpts.count > 0;

        
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
        titleLabel.attributedText = md.questionAttribute;
        selectedItem = false;
        rightImage.isHidden = true;

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
        
        
        rightImage = createImageView();
        rightImage.contentMode = .scaleAspectFit;
        rightImage.snp.makeConstraints { (maker) in
            maker.right.equalTo(-10);
            maker.height.equalTo(self.snp.height);
            maker.width.equalTo(30);
            maker.top.equalTo(0);
        }
        rightImage.image = #imageLiteral(resourceName: "selected_error.png");
        rightImage.highlightedImage = #imageLiteral(resourceName: "selected_right.png");
        rightImage.isHidden = true;
        
        titleLabel = createLabel();
        titleLabel.numberOfLines = 0;
        titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.leftImage.snp.right).offset(10);
            maker.right.equalTo(self.rightImage.snp.left).offset(-10);
//            maker.height.equalTo(self.snp.height);
            maker.top.equalTo(10);
            maker.bottom.equalTo(-10)

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
        btn.setBackgroundImage(UIImage.createImage(color: rgbColor(r: 58, g: 122, b: 210)), for: .normal);
        btn.setBackgroundImage(UIImage.createImage(color: UIColor.gray), for: .disabled);
        btn.isEnabled = false;
        btn.snp.makeConstraints { (maker) in
            maker.left.equalTo(40);
            maker.centerY.equalTo(self.snp.centerY);
            maker.height.equalTo(40);
            maker.right.equalTo(-40);
            maker.top.equalTo(40);
        }
        
    }
    
    func addAnwserFlag() -> Void {
        
        if rightImage != nil {
            return;
        }
        
        rightImage = createImageView();
        rightImage.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(self.snp.centerX);
            maker.top.equalTo(10);
            maker.size.equalTo(CGSize.init(width: 24, height: 24));
        }
        rightImage.image = #imageLiteral(resourceName: "selected_error.png");
        rightImage.highlightedImage = #imageLiteral(resourceName: "selected_right.png");
        rightImage.isHidden = true;
    }
    
}




