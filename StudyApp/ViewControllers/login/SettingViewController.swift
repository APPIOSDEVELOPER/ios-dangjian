//
//  SettingViewController.swift
//  StudyApp
//


import UIKit

class SettingViewController: SuperBaseViewController ,UITextFieldDelegate {
    
    var segmentView: BaseCustomView!
    
    var loginQQWX: BaseCustomView!
    
    var userField: UITextField!
    var passwordField: UITextField!
    
    var configBtn: UIButton!
    
    var vertity:UITextField!
    
    var agreLabel: UILabel!
    var isSelected = true;
    
    var vertityCodeBtn: UIButton!
    
    var forgetPassButton: UIButton!
    
    var operationType = UserOperationType.login;
    var countTime = 60;
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createLoginAndRegister();
        setRedStyle();
        
    }
    
    func createThirdLogin() -> Void {
        if loginQQWX != nil {
            return;
        }
        loginQQWX = BaseCustomView(frame: .init(x: 0, y: configBtn.maxY + 36, width: width(), height: 60), type: .qqWXType);
        addView(tempView: loginQQWX);
        loginQQWX.titleButton.addTarget(self, action: #selector(buttonAction(btn:)), for: .touchUpInside);
        loginQQWX.subButton.addTarget(self, action: #selector(buttonAction(btn:)), for: .touchUpInside);
        loginQQWX.titleButton.tag = ViewTagSense.qqTag.rawValue;
        loginQQWX.subButton.tag = ViewTagSense.wxTag.rawValue;
        
        loginQQWX.alpha = 0;
    }

    
    
    func setRedStyle() -> Void  {
        view.backgroundColor = navigateCtrl.navigationBar.barTintColor//rgbColor(r: 204, g: 16, b: 24);
        userField.backgroundColor = UIColor.white;
        passwordField?.backgroundColor = UIColor.white;
        vertity?.backgroundColor = UIColor.white;
        configBtn?.backgroundColor = UIColor.white;
        configBtn?.setTitleColor(rgbColor(r: 204, g: 16, b: 24), for: .normal);

    }
    
    func createForgetPass() -> Void {
        
    }
    
    func createLoginAndRegister() -> Void {
        
        userField = createTextField(rect: .zero);
        userField.keyboardType = .numberPad;
        userField.placeholder = "手机号";
        userField.attributedPlaceholder = NSAttributedString(string: "手机号", attributes: [NSAttributedStringKey.foregroundColor:UIColor.white]);
        
        passwordField = createTextField(rect: .zero);
        passwordField.placeholder = "密码（6~12位字母或数字）";
        passwordField.attributedPlaceholder = NSAttributedString(string: "密码（6~12位字母或数字）", attributes: [NSAttributedStringKey.foregroundColor:UIColor.white]);

        passwordField.isSecureTextEntry = true;
        vertity = createTextField(rect: .zero);
        vertity.placeholder = "验证码";
        vertity.attributedPlaceholder = NSAttributedString(string: "验证码", attributes: [NSAttributedStringKey.foregroundColor:UIColor.white]);

        vertity.keyboardType = .numberPad;
        configBtn = createButton(rect: .init(x: 80, y: 0, width: width() - 160, height: 40), text: "确定");
        configBtn.titleLabel?.font = fontSize(size: 16);
        configBtn.backgroundColor = rgbColor(r: 208, g: 8, b: 8);
        configBtn.addTarget(self, action: #selector(buttonAction(btn:)), for: .touchUpInside);
        configBtn.tag = ViewTagSense.loginAppTag.rawValue;
        
        addLayerBorder(subView: userField);
        addLayerBorder(subView: vertity);
        addLayerBorder(subView: passwordField);
        
        vertityCodeBtn = UIButton(type: .custom);
        vertityCodeBtn.tag = ViewTagSense.sendVertifyTag.rawValue;
        vertityCodeBtn.addTarget(self, action: #selector(buttonAction(btn:)), for: .touchUpInside);
        vertityCodeBtn.setTitle("发送验证码", for: .normal);
        vertityCodeBtn.titleLabel?.font = fontSize(size: 14);
        vertityCodeBtn.setTitleColor(UIColor.white, for: .normal);
        vertityCodeBtn.setTitleColor(rgbColor(rgb: 245), for: .disabled);
//        vertityCodeBtn.backgroundColor = UIColor.green;
        
        
        if operationType == .login {
            
            
            segmentView = BaseCustomView(frame: .init(x: 0, y: 64, width: width(), height: 60), type: .loginSegmentView);
            segmentView.addTap(target: self, selector: #selector(segmentAction(_:)));
            addView(tempView: segmentView);
            
            
            
            segmentView.currentIndex = 0;
            
            forgetPassButton = createButton(rect: .zero, text: "忘记密码");
            forgetPassButton.setTitleColor(UIColor.white, for: .normal);
            forgetPassButton.titleLabel?.font = fontSize(size: 14);
            forgetPassButton.tag = ViewTagSense.forgetPassTag.rawValue;
            forgetPassButton.addTarget(self, action: #selector(buttonAction(btn:)), for: .touchUpInside);
            
            
            createLoginView();
            
            createThirdLogin();

        }else if operationType == .forgetPass {
            
            createRegisterView();
            agreLabel?.isHidden = true;
            agreLabel?.alpha = 0;
            passwordField.placeholder = "新密码";
            passwordField.attributedPlaceholder = NSAttributedString(string: "新密码（6~12位字母或数字）", attributes: [NSAttributedStringKey.foregroundColor:UIColor.white]);

        }else if operationType == .alterPass {
            createLoginView();
            title = "修改密码";
            userField.placeholder = "原密码";
            userField.attributedPlaceholder = NSAttributedString(string: "原密码", attributes: [NSAttributedStringKey.foregroundColor:UIColor.white]);

            userField.keyboardType = .default;
            passwordField.placeholder = "新密码";
            
            passwordField.attributedPlaceholder = NSAttributedString(string: "新密码（6~12位字母或数字）", attributes: [NSAttributedStringKey.foregroundColor:UIColor.white]);

            
            
        }else if operationType == .alterUser {
            createLoginView();
            title = "修改用户名";

            userField.keyboardType = .default;
            userField.placeholder = "用户名";
            userField.attributedPlaceholder = NSAttributedString(string: "用户名", attributes: [NSAttributedStringKey.foregroundColor:UIColor.white]);

            passwordField.isHidden = true;
            configBtn.frame.origin.y = userField.maxY + 20;
        }
        
        if vertityCodeBtn != nil {
            addView(tempView: vertityCodeBtn);
        }
        
        configBtn?.layer.cornerRadius = 4;
        configBtn?.layer.masksToBounds = true;
    }
    
    func createAgree() -> Void {
        
        agreLabel = createLabel(rect: .init(x: passwordField.maxX - 170, y: passwordField.maxY + 10, width: 170, height: 20), text: "");
        agreLabel.textColor = UIColor.white;
        agreLabel.textAlignment = .center;
        let attribute = NSMutableAttributedString(string: " 同意《党建用户协议》");
        attribute.addAttributes([NSAttributedStringKey.underlineStyle:1], range: NSRange.init(location: 3, length: 8));
        
        
        
        attribute.addAttributes([NSAttributedStringKey.foregroundColor:UIColor.lightGray], range: NSRange.init(location: 0, length:3));
        attribute.addAttributes([NSAttributedStringKey.baselineOffset:4], range: .init(location: 0, length: attribute.length));
        let registerImg = NSTextAttachment();
        registerImg.image = UIImage(named:"regist_select");
        registerImg.bounds = .init(x: 0, y: 2, width: 14, height: 14);
        let attibuteImage = NSAttributedString(attachment: registerImg);
        attribute.insert(attibuteImage, at: 0);
        agreLabel.attributedText = attribute;
        addTarget(target: self, selector: #selector(gestureAction(_:)), subView: agreLabel, delegate: nil);
        
    }
    
    // 修改用户名
    func yaoyuAlterUserName() -> Void {
        
        guard let counts = userField.text?.count , counts > 0 else {
            self.showTip(msg: "请输入用户名");
            return;
        }
        
        let request = UserRequest(value: userField.text!, jointType: .alterUserName);
        request.loadJsonStringFinished { (result, success) in
            guard let dict = result as? NSDictionary else{
                self.showNetworkError();
                return;
            }
            let model = BaseModel(dictM: dict);
            self.didFialModel(model: model);
            
        };
        
    }
    
    func didFialModel(model: BaseModel) -> Void {
        if model.isSuccess {
            self.showTip(msg: model.result_msg, showCancel: false, finsihed: { (tag) -> (Void) in
                self.navigationController?.popViewController(animated: true);

            });
        }else {
            self.showTip(msg: model.result_msg);
        }
    }
    func yaoyuAlterPass() -> Void {
        
        guard let oldStrl = getPassWord(text: userField.text) else {
            return;
        }
        guard let newStrl = getPassWord(text: passwordField.text) else {
            return;
        }
        guard oldStrl == newStrl else {
            showTip(msg: "两次密码不一样")
            return;
        }
        
        let request = UserRequest(alterPass: oldStrl, newpwd: newStrl);
        request.loadJsonStringFinished { (result, success) in
            guard let dict = result as? NSDictionary else{
                self.showNetworkError();
                return;
            }
            let model = BaseModel(dictM: dict);
            self.didFialModel(model: model);

        };
    }
    
    // 获取验证吗
    
    func fetchCode() -> Void {
        
        let type: RouteCateogryType = operationType == .register ? .register : .forgetPass;
        
        guard let phone = getPhoneNumber(text: userField.text) else {
            return;
        }
        
        let request = UserRequest(sendCode: phone, type: type);
//        request.respType = .typeModel;
        request.loadJsonStringFinished { (result, code) in

            guard let dict = result as? NSDictionary else{
                self.showNetworkError();
                return;
            }
            let md = BaseModel.createModel(dict: dict);
            if md.isSuccess {
                self.beginStart();
            }else{
                self.showTip(msg: md.result_msg);
            }
    
        };
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        NSObject.cancelPreviousPerformRequests(withTarget: self);
    }
    
    @objc func beginStart() -> Void {
        if countTime > 0 {
            perform(#selector(beginStart), with: nil, afterDelay: 1);
            vertityCodeBtn.setTitle("(\(countTime))秒后重发", for: .normal);
            countTime -= 1;
            vertityCodeBtn.isEnabled = false;
        }else{
            countTime = 60;
            vertityCodeBtn.isEnabled = true;
            vertityCodeBtn.setTitle("发送验证码", for: .normal);
            NSObject.cancelPreviousPerformRequests(withTarget: self);
        }
    }
    
    // 注册 app
    func registerAppToNet() -> Void {
        
        if operationType == .register {
            if !isSelected {
                showTip(msg: "请先同意协议");
                return;
            }
        }
        
        
        guard let phone = getPhoneNumber(text: userField.text) else {
            return;
        }
        
        guard let pass = getPassWord(text: passwordField.text) else {
            return;
        }
        guard let verStrl = vertity.text,verStrl.count > 0 else {
            self.showTip(msg: "请输入验证码");
            return;
        }
        
        let type = operationType == .forgetPass ? RouteCateogryType.forgetPass : RouteCateogryType.register;
        
        
        let request = UserRequest(register: phone, code: vertity.text!, pass: pass,type: type);
        request.loadJsonStringFinished { (result, success) in
            self.loginAppAfter(result: result);
        };
        
    }
    
    func testColorRandom() {
        let randomRGB = CGFloat(arc4random_uniform(255) / 255);
        
        if #available(iOS 10.0, *) {
            let color = UIColor(displayP3Red: randomRGB, green: randomRGB, blue: randomRGB, alpha: 1)
            print(color.cgColor);
 
        } else {
            // Fallback on earlier versions
        };
        
    }
    
    // 登陆 app
    
    func loginHttpRequest() -> Void {
        
        guard let phone = getPhoneNumber(text: userField.text) else {
            return;
        }
        guard let pass = getPassWord(text: passwordField.text) else {
            return;
        }
        
        let request = UserRequest(login: phone, passWord: pass);
//        request.cls = UserInfoModel.classForCoder();
        request.loadJsonStringFinished { (result, success) in
          
            self.loginAppAfter(result: result);
        };
    }
    
    
    
    func loginAppAfter(result: AnyObject?) -> Void {
        
        guard let dict = result as? NSDictionary else {
            self.showNetworkError();
            return;
        }
        
        let model = BaseModel(anyCls: UserInfoModel.classForCoder(), dict: dict);
        
        if model.isSuccess {
            navigateCtrl.popViewController(animated: false);
            tabbarCtrl.selectedIndex = 4;
            navigateCtrl.navigationBar.topItem?.title = "用户设置";

            
        }else{
            self.showTip(msg: model.result_msg);
        }
    }
    
    func showNetworkError() -> Void {
        self.showTip(msg: "网络出错,请检查网络")
    }
    
    
    @objc override func buttonAction(btn: UIButton) {
        
        
        if btn.tag == ViewTagSense.qqTag.rawValue {
            
//            ShareSDKManager.getUserInfo(type: .typeQQ) { (success, error, user) in
//
//                print("succes = \(success)");
//            };
            
        }else if btn.tag == ViewTagSense.wxTag.rawValue {
            
            
        }else if btn.tag == ViewTagSense.forgetPassTag.rawValue {
            let ctrl = SettingViewController();
            ctrl.operationType = .forgetPass;
            ctrl.title = "忘记密码";
            navigationController?.pushViewController(ctrl, animated: true);
            
        }else if btn.tag == ViewTagSense.loginAppTag.rawValue {
            if operationType == .login {
                loginHttpRequest();
            }else if operationType == .register {
                registerAppToNet();
            }else if operationType == .alterUser {
                yaoyuAlterUserName();
            }else if operationType == .alterPass{
                yaoyuAlterPass();
            }else if operationType == .forgetPass {
                
                registerAppToNet();
                
            }
            
        }else if btn.tag == ViewTagSense.sendVertifyTag.rawValue {
            fetchCode();
        }
    }
    
    func getPhoneNumber(text:String?) -> String? {
        guard let temptext = text, temptext.isPhone else {
            self.showTip(msg: "请输入正确的手机号")
            return nil;
        }
        return text;
    }
    
    func getPassWord(text: String?) -> String? {
        guard let pass = text, pass.isPassWord else {
            showTip(msg: "请输入密码（6~12位字母或数字）")
            return nil;
        }
        return pass;
    }
    
    @objc func gestureAction(_ tap: UITapGestureRecognizer) -> Void {
        
        let point = tap.location(in: tap.view)
        
        if point.x < 58 {
            isSelected = !isSelected;
            
            let registerImg = NSTextAttachment();
            registerImg.image = UIImage(named:!isSelected ? "regist_select" : "regist_unselect");
            registerImg.bounds = .init(x: 0, y: 2, width: 14, height: 14);
            let attrbuteText = agreLabel.attributedText?.mutableCopy() as? NSMutableAttributedString;
            attrbuteText?.replaceCharacters(in: NSRange.init(location: 0, length: 1), with: NSAttributedString.init(attachment: registerImg));
            agreLabel.attributedText = attrbuteText;
        }else {
            let ctrl = HTMLContentViewController();
            ctrl.isShowInpuView = false;
            ctrl.linkURL = baseURLAPI + "/userDeal";
            navigateCtrl.pushViewController(ctrl, animated: true);
            
        }
        
        
        
    }
    
    @objc func segmentAction(_ tap: UITapGestureRecognizer) -> Void {
        let index = Int(tap.location(in: tap.view).x / (width() / 2));
        segmentView.currentIndex = index;
        if index == 0{
            createLoginView();
            operationType = .login;
            
        }else{
            operationType = .register;
            createRegisterView();
        }
        agreLabel?.isHidden = index == 0;
        loginQQWX?.isHidden = index == 1;

    }
    
    
    func addLayerBorder(subView: UITextField) -> Void {
        subView.delegate = self;
        subView.font = fontSize(size: 17.4);
        subView.textColor = UIColor.white;
        subView.layer.borderColor = UIColor.white.cgColor//rgbColor(rgb: 234).cgColor;
        subView.layer.borderWidth = 2;
        let leftView = UIView(frame: .init(x: 0, y: 0, width: 15, height: 10));
        subView.leftView = leftView;
        subView.leftViewMode = .always;
        subView.tintColor = UIColor.white;
        subView.backgroundColor = navigateCtrl.navigationBar.barTintColor;
        subView.borderStyle = .none;
        subView.background = UIImage.createImage(color: navigateCtrl.navigationBar.barTintColor!);
        //        subView.backgroundColor = UIColor.white;
        
    }
    
    func createRegisterView() -> Void {
        
        let py = segmentView == nil ? 140 : segmentView.maxY + 40;
        userField.frame = .init(x: 26, y: py, width: width() - 52, height: 44);
        vertity.frame = .init(x: userField.minX, y: userField.maxY + 20, width: userField.width, height: userField.height);
        vertity.isHidden = false;
        passwordField.frame = .init(x: userField.minX, y: vertity.maxY + 20, width: userField.width, height: userField.height);
        configBtn.frame = .init(x: 60, y: passwordField.maxY + 60, width: width() - 120, height: 40);
        
        vertityCodeBtn.frame = .init(x: vertity.maxX - 20 * 6, y: vertity.minY, width: 20 * 6, height: 40);
        vertityCodeBtn.isHidden = false;
        forgetPassButton?.isHidden = true;
        
        
        createAgree();
    }
    
    func createLoginView() -> Void {
        let py = segmentView == nil ? 140 : segmentView.maxY + 40;

        userField.frame = .init(x: 26, y: py, width: width() - 52, height: 44);
        passwordField.frame = .init(x: userField.minX, y: userField.maxY + 20, width: userField.width, height: userField.height);
        vertity.isHidden = true;
        vertityCodeBtn.isHidden = true;
        
        
        configBtn?.frame = .init(x: 60, y: passwordField.maxY + 60, width: width() - 120, height: 40);
        

        forgetPassButton?.isHidden = false;
        forgetPassButton?.frame = .init(x: passwordField.maxX - 13*5, y: passwordField.maxY + 3, width: 13*5, height: 24);

    }

    
    ///// text view delegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return true;
    }

}
