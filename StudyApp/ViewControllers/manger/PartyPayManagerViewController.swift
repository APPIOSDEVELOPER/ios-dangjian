//
//  PartyPayManagerViewController.swift
//  StudyApp
//


import UIKit

class PartyPayManagerViewController: SuperBaseViewController,UIPickerViewDelegate,UIPickerViewDataSource ,UITextFieldDelegate{

    var dataSource = [String]();
    
    var dataPicker: XPDataPickerView!
    var officeItem: [String]!
    var selectedRow = 0;
    var zhiWei: [String]!
    
    var seletedIndexRow = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource.append("在职党员");
        dataSource.append("年薪");
        
        titleImageView = createImageView(rect: .init(x: 0, y: 64, width: sWidth, height: 120), name: "dang_fei_flag@2x");
        titleImageView.backgroundColor = UIColor.clear;
    
        createTable(frame: .init(x: 0, y: titleImageView.maxY + 30, width: sWidth, height: height() - titleImageView.maxY - 30), delegate: self);
        baseTable.register(PayMangerTableCell.classForCoder(), forCellReuseIdentifier: "cell");
        baseTable.register(PayMangerTableCell.classForCoder(), forCellReuseIdentifier: "input");
        baseTable.register(ButtonTableCell.classForCoder(), forCellReuseIdentifier: "button");
        baseTable.rowHeight = UITableViewAutomaticDimension;
        baseTable.estimatedRowHeight = 80;
        
        NotificationCenter.default.addObserver(self, selector: #selector(notification(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(notification(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil);
    }
    
    
    
    deinit {
        NotificationCenter.default.removeObserver(self);
    }
    
    
    
    @objc func notification(_ notifer:NSNotification) -> Void {
        guard let info = notifer.userInfo else {
            return;
        }
        
        let rect = info[UIKeyboardFrameEndUserInfoKey] as! CGRect;
        
        
        if notifer.name == NSNotification.Name.UIKeyboardWillShow {
            
            view.frame.origin.y = -rect.height
//            baseTable.isUserInteractionEnabled = false;
            
        }else if notifer.name == NSNotification.Name.UIKeyboardWillHide{
            view.frame.origin.y = 0;
//            baseTable.isUserInteractionEnabled = true;
        }
        
    }
    
    func updateFeedModel() -> Void {
        
        guard let cell = baseTable.cellForRow(at: IndexPath(row: 2, section: 0)) as? PayMangerTableCell else {
            return;
        }
        
        let request = UserRequest(value: cell.textField.text!, jointType: .partyExpenses);
        request.loadJsonStringFinished { (result, success) in
            guard let dict = result as? NSDictionary ,
                let cost = dict["result"] as? String else{
                return;
            }
         
            let alert = UIAlertController(title: "计算结果", message: cost, preferredStyle: .alert);
            let cancel = UIAlertAction(title: "确定", style: .cancel, handler: { (action) in
                
            })
            alert.addAction(cancel);
            self.present(alert, animated: true, completion: {
                
            })
            
            
        };
        
    }
    
    func showPicker(show: Bool) -> Void {
        selectedRow = 0;
        createPicker();
        
        UIView.animate(withDuration: 0.5) {
            if show {
                self.dataPicker.frame.origin.y = sHeight - self.dataPicker.height;
            }else{
                self.dataPicker.frame.origin.y = sHeight;

            }
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        baseTable.isUserInteractionEnabled = false;
        textField.isUserInteractionEnabled = true;
        return true;
    }
    
    func createPicker() -> Void {
        dataPicker?.reloadAllComponents();
        if dataPicker != nil {
            return;
        }
        
        officeItem = [String]();
        officeItem.append("在职党员")
        officeItem.append("普通党员")
        officeItem.append("流动党员")
        officeItem.append("两新党员")
        officeItem.append("窗口党员")

        dataPicker = XPDataPickerView(frame: .init(x: 0, y: height(), width: width(), height: 210));
        dataPicker.addTarget(target: self, selector: #selector(buttonAction(btn:)));
        dataPicker.backgroundColor = rgbColor(rgb: 234);
        addView(tempView: dataPicker);
        dataPicker.delegate = self;
        dataPicker.dataSource = self;
    }
    
    
    
    @objc override func buttonAction(btn: UIButton) {
        
        if let cell = btn.superview as? UITableViewCell {
            cell.tag = 0;
            updateFeedModel();
            return;
        }
        
        var title = "";
        if seletedIndexRow == 0 {
            title = officeItem[selectedRow];
        }else if seletedIndexRow == 1 {
            title = zhiWei[selectedRow];
        }
        let cell = baseTable.cellForRow(at: IndexPath.init(row: seletedIndexRow, section: 0)) as? PayMangerTableCell;
        cell?.textField.text = title;

        showPicker(show: false);

    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if seletedIndexRow == 0 {
           return officeItem.count
        }
        
        if zhiWei == nil {
            zhiWei = [String]();
            zhiWei.append("月薪");
            zhiWei.append("年薪");
        }
        return zhiWei.count;
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if seletedIndexRow == 0 {
            return officeItem[row];
        }
        if seletedIndexRow == 1 {
            return zhiWei[row];
        }
        return zhiWei[row];
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = row;
    }
    
    // MARK: - table view delgate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count + 2;
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if dataSource.count > indexPath.row {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PayMangerTableCell;
            
            if indexPath.row == 0 {
                cell.textField.text = "职位";
                cell.textField.isEnabled = false;
            }else{
                cell.textField.text = "月薪";
                cell.textField.isEnabled = false;

            }
        
            cell.titleLabel.text = indexPath.row == 0 ? "类型" : "薪水";
            return cell;
        }
        if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "input", for: indexPath) as! PayMangerTableCell;
            cell.textField.placeholder = "请输入...";
            cell.textField.isEnabled = true;
            cell.titleLabel.text = "税后薪水";
            cell.rightImage.isHidden = true;
            cell.textField.delegate = self;
            cell.configView();
            cell.addTarget(target: self, action: #selector(gestureAction));
            return cell;
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "button", for: indexPath) as! ButtonTableCell;
        cell.btn.setTitle("计算结果", for: .normal);
        cell.btn.snp.removeConstraints();
        cell.btn.addTarget(self, action: #selector(buttonAction(btn:)), for: .touchUpInside);
        cell.btn.snp.makeConstraints { (maker) in
            maker.top.equalTo(30);
            maker.left.equalTo(cell.snp.left).offset(60);
            maker.right.equalTo(cell.snp.right).offset(-60);
            maker.height.equalTo(40);
            maker.bottom.equalTo(-20);
        }
    
        return cell;
        
    }
    
    @objc func gestureAction() -> Void {
        let ctrl = HTMLContentViewController();
        ctrl.linkURL = "http://tsg.hbue.edu.cn/be/07/c4885a114183/page.htm";
        ctrl.isShowInpuView = false;
        navigateCtrl.pushViewController(ctrl, animated: true);
        
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        seletedIndexRow = indexPath.row;

        if indexPath.row == 0 {
            showPicker(show: true);
            tableView.isUserInteractionEnabled = false;
        }else if indexPath.row == 1 {
            showPicker(show: true);
            tableView.isUserInteractionEnabled = false;

        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        showPicker(show: false);
        baseTable.isUserInteractionEnabled = true;
        self.view.endEditing(true);
        
    }
}


class XPDataPickerView: UIPickerView {
    var configBtn: UIButton!
    
    func addTarget(target: Any,selector: Selector) -> Void {
        configBtn = UIButton(frame: .init(x: width - 70, y: 4, width: 60, height: 35));
        configBtn.setTitle("确定", for: .normal);
        addSubview(configBtn);
        configBtn.layer.cornerRadius = 4;
        configBtn.layer.borderWidth = 1;
        configBtn.layer.borderColor = rgbColor(rgb: 221).cgColor;
        configBtn.addTarget(target, action: selector, for: .touchUpInside);
        configBtn.setTitleColor(UIColor.gray, for: .normal);
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if configBtn.frame.contains(point) {
            return configBtn;
        }
        return super.hitTest(point, with: event);
    }
    
}


class PayMangerTableCell: BaseTableViewCell {
    

    var textField: UITextField!
    
    var sportManer: UILabel!
    
    
    override func initView() {
        let contentImage = createImageView();
        contentImage.contentMode = .scaleAspectFit;
        contentImage.clipsToBounds = true;
        contentImage.image = UIImage(named:"dang_fei_frame");
//        716 × 70
        contentImage.snp.makeConstraints { (maker) in
            maker.height.equalTo(60);
            maker.width.equalTo(self.snp.width).offset(-32);
            maker.top.equalTo(20);
            maker.bottom.equalTo(-20);
            maker.centerX.equalTo(self.snp.centerX);
        }
        
        textField = createTextField();
        textField.textAlignment = .center;
        textField.keyboardType = .numberPad;
        textField.font = fontSize(size: 14);
        textField.snp.makeConstraints { (maker) in
            maker.left.equalTo(contentImage.snp.left).offset(30);
            maker.right.equalTo(contentImage.snp.right).offset(-30);
            maker.height.equalTo(contentImage.snp.height);
            maker.top.equalTo(contentImage.snp.top);
        }
        
        rightImage = createImageView();
        rightImage.image = UIImage(named:"see_more_item@2x");
        rightImage.snp.makeConstraints { (maker) in
            maker.right.equalTo(contentImage.snp.right).offset(-30);
            maker.centerY.equalTo(contentImage.snp.centerY);
            maker.size.equalTo(CGSize(width: 15, height: 10));
        }
        
        titleLabel = createLabel();
        titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(contentImage.snp.left);
            maker.bottom.equalTo(contentImage.snp.top).offset(-4);
        }
        
    }
    
    func addTarget(target: Any,action: Selector) -> Void {
        let tap = UITapGestureRecognizer(target: target, action: action);
        sportManer.addGestureRecognizer(tap);
        sportManer.isUserInteractionEnabled = true;
        
    }
    
    func configView() -> Void {
        if sportManer != nil {
            return;
        }
        sportManer = createLabel();
        sportManer.snp.makeConstraints { (maker) in
            maker.right.equalTo(self.textField.snp.right);
            maker.bottom.equalTo(self.snp.bottom);
        };
        
        let attbite = NSMutableAttributedString(string: "党费收费说明");
        let flagImg = NSTextAttachment();
        flagImg.image = UIImage(named:"jieshi");
        flagImg.bounds = .init(x: 0, y: 0, width: 14, height: 14);
        attbite.insert(NSAttributedString.init(attachment: flagImg), at: 0);
        attbite.addAttributes([NSAttributedStringKey.baselineOffset:2], range: NSRange.init(location: 1, length: attbite.length-1));
        attbite.addAttributes([NSAttributedStringKey.font:fontSize(size: 14),NSAttributedStringKey.foregroundColor:UIColor.gray], range: NSRange.init(location: 0, length: attbite.length));
        sportManer.attributedText = attbite;
        
    }
}



