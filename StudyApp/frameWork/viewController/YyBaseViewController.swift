//
//  YyBaseViewController.swift
//  StudyApp
//

import UIKit
//import 

class YyBaseViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var baseTable: FMBaseTableView!
    var nothingImageView: UIImageView!
    
    var baseCollectionView: FMBaseCollectionView!
    
    var contentScrollView: UIScrollView!
    
    var navigateBar: UINavigationBar!
    
    var isUserEnable = true {
        didSet{
            self.view.isUserInteractionEnabled = isUserEnable;
        }
    }
    
    var isUserEnableSubviews = true {
        didSet{
            for item in view.subviews{
                item.isUserInteractionEnabled = isUserEnableSubviews;
            }
        }
    }
    
    enum NaviBarState {
        case black
        case white
    }
    
    var currentStateIndex = NaviBarState.white;
    
    var stateBar = false;
    
    var navigateTitle = "" {
        didSet {
            let top = UINavigationItem(title: navigateTitle);
            navigateBar.pushItem(top, animated: false);
        }
    }
    
    
    var addBackItem: Bool = false {
        didSet {
            if addBackItem {
                let backitem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(backItem(_:)));
                navigateBar.topItem?.leftBarButtonItem = backitem;
            }
        }
        
    }
    
    

    
    
    func navCtrlWhiteAndDark(tag: Int = 1) -> Void {
        
        currentStateIndex = tag == 1 ? .black : .white;
        
        if tag == 0 { // 黑色主题 白色字体
            
//            self.navigationController?.navigationBar.tintColor = UIColor.white;

//            self.navigationController?.navigationBar.barTintColor = navigateColor;
//            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white];
            
        }else if tag == 1{ // 白色主题 黑色 字体
//            self.navigationController?.navigationBar.barTintColor = UIColor.white;
//            self.navigationController?.navigationBar.tintColor = UIColor.darkGray;
//            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.darkGray];
        }else if tag == 2 {
            // 首页主题
//            if navigateCtrl.navigationBar.topItem?.titleView == nil {
//                let logoImg = #imageLiteral(resourceName: "logo_app.png");
//                let titleView = UIImageView(frame:CGRect.init(x: 0, y: 0, width: logoImg.size.width, height: logoImg.size.height));
//                titleView.image = logoImg;
//                navigateCtrl.navigationBar.topItem?.titleView = titleView;
//            }
            
        }else if tag == 3 {
            
        }

    }
    
    func buttonAction(btn: UIButton) -> Void {
        
    }
    
    func setHiddenNavigateBarAndState(hidden: Bool) -> Void {
        
        if currentStateIndex == .white {
            UIApplication.shared.statusBarStyle = .lightContent; // 白色
        }else{
            UIApplication.shared.statusBarStyle = .default; // 黑色
        }
//        UIApplication.shared.isStatusBarHidden = hidden;
//        navigateCtrl.isNavigationBarHidden = hidden;
        stateBar = hidden;
        navigateCtrl.navigationBar.isHidden = hidden;
        setNeedsStatusBarAppearanceUpdate();
        

//        if  hidden {
//        }else {
//            navigateCtrl.isNavigationBarHidden = false;
//        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return stateBar;
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if currentStateIndex == .white {
            return .default;
        }
        return .lightContent;
    }
    
    
    func setNavibarLeftBackAndHome() -> Void {
        setNavibarLeftBackAndShare(leftName: "d_back_flag", rightName: "home_flag_image");
    }
    func setNavibarLeftBackAndShare(leftName: String = "d_back_flag",rightName: String = "share_item_flag" ) -> Void {
    
//        back_pre_ctrl
        
        let sel = #selector(buttonItemAction(_:));
        let leftItem = UIBarButtonItem(image: UIImage(named:leftName)?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: sel);
        leftItem.tag = 0;
        
        let rightItem = UIBarButtonItem(image: UIImage(named:rightName)?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: sel);
        rightItem.tag = 1;
        
        self.navigationItem.leftBarButtonItem = leftItem;
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    
    @objc func buttonItemAction(_ item: UIBarButtonItem) -> Void {
        if item.tag == 0 {
            navigateCtrl.popViewController(animated: true);
        }
    }
    

    
    var navigateRect: CGRect {
        return CGRect(x: 0, y: 64, width: width(), height: height() - 64);
    }
    
    var tabbarRect: CGRect {
        return CGRect(x: 0, y: 64, width: width(), height: height() - 64 - 49);
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigateBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: width(), height: 64));
        navigateBar.autoresizingMask = .flexibleWidth;

        self.view.clipsToBounds = true;
//
        
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white;
        
        setAdjust();
        
        loadDataFromNet(net: false);

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        SVProgressHUD.dismiss();
        
//        MobClick.endLogPageView("\(self)");
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
//        MobClick.beginLogPageView("\(self)")
    }
    
    @objc func backItem(_ item: UIBarButtonItem) -> Void {
        self.navigationController?.popViewController(animated: true);
    }
    
    
    @discardableResult
    func addTarget(target: Any,selector: Selector,subView: UIView,delegate: UIGestureRecognizerDelegate?) -> UITapGestureRecognizer {
        let tap = UITapGestureRecognizer(target: target, action: selector);
        subView.addGestureRecognizer(tap);
        subView.isUserInteractionEnabled = true;
        tap.delegate = delegate;
        return tap;
    }
    
    
    func showNothingData(show: Bool = true) -> Void {
        if show && nothingImageView == nil {
            nothingImageView = UIImageView(frame: CGRect(x: 0, y: 200, width: width(), height: height() - 200));
            addView(tempView: nothingImageView);
            nothingImageView.contentMode = .center;
            nothingImageView.backgroundColor = UIColor.clear;
            nothingImageView.image = UIImage(named: "pic_nothing@2x.png");
        }
        nothingImageView?.isHidden = !show;
        
        
    }
    
    func setAdjust() -> Void {
        let line = UIView();
        addView(tempView: line);
        
    }
    
    func createLabel(rect: CGRect,text: String) -> UILabel {
        let label = UILabel(frame: rect);
        label.text = text;
        label.font = fontSize(size: 14);
        label.textColor = UIColor.gray;
        addView(tempView: label);
        label.numberOfLines = 0;
        return label;
    }
    
    func createTextField(rect: CGRect) -> UITextField {
        let textFiel = UITextField(frame: rect);
        textFiel.autocorrectionType = .no;
        textFiel.autocapitalizationType = .none;
        textFiel.spellCheckingType = .no;
        addView(tempView: textFiel);
        textFiel.layer.cornerRadius = 4;
        textFiel.layer.masksToBounds = true;
        return textFiel;
    }
    
    
    
    func createButton(rect: CGRect,text: String) -> UIButton {
        let btn = UIButton(frame: rect);
        btn.setTitle(text, for: .normal);
        btn.backgroundColor = UIColor.clear;
        btn.titleLabel?.font = fontSize(size: 14);
        btn.setTitleColor(UIColor.white, for: .normal);
        addView(tempView: btn);
        return btn;
    }
    
    func setBackStyle() -> Void {
        let backItem = UIBarButtonItem();
        backItem.title = "";
        self.navigationItem.backBarButtonItem = backItem;
        
    }
    
    func createImageView(rect: CGRect,name: String?) -> UIImageView {
        let imageView = UIImageView(frame: rect);
        imageView.contentMode = .scaleAspectFill;
        imageView.clipsToBounds = true;
        addView(tempView: imageView);
        if let prefix = name {
            imageView.image = UIImage(named:prefix);
        }
        imageView.backgroundColor = UIColor.clear;
        return imageView;
    }
    
    func createView(rect: CGRect,isAdd: Bool = true) -> UIView {
        let tempView = UIView(frame: rect);
        if isAdd {
            addView(tempView: tempView);
        }
        tempView.backgroundColor = UIColor.lightGray;
        return tempView;
    }
    
    func loadDataFromNet(net: Bool = false) -> Void {
        
    }
    
    
    func setContentScrollView(rect: CGRect?) -> Void {
        
        let cRect = rect ?? sBound;
        contentScrollView = UIScrollView(frame: cRect);
        view.insertSubview(contentScrollView, at: 0);
        contentScrollView.backgroundColor = UIColor.clear;
        contentScrollView.showsVerticalScrollIndicator = false;
        contentScrollView.showsHorizontalScrollIndicator = false;
        contentScrollView.keyboardDismissMode = .onDrag;
        self.automaticallyAdjustsScrollViewInsets = false;
        if #available(iOS 11.0, *) {
            contentScrollView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        };

    }
    
    
    // MARK: - table view delgate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10;
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath);
        
        return cell;
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    

    
    func createTable(frame: CGRect,delegate: UITableViewDataSource&UITableViewDelegate) -> Void {
        
        baseTable = FMBaseTableView(frame: frame);
        baseTable.delegate = delegate;
        baseTable.dataSource = delegate;
        view.addSubview(baseTable);
        baseTable.tableFooterView = UIView();
        baseTable.estimatedSectionHeaderHeight = 0;
        baseTable.estimatedRowHeight = 0;
        
        if #available(iOS 11.0, *) {
            baseTable.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        };
    }
    
    func addRefresh() -> Void {
        let refreshView = UIRefreshControl();
        refreshView.addTarget(self, action: #selector(beginRefreshData(_:)), for: .valueChanged);
        if #available(iOS 10.0, *) {
            baseTable.refreshControl = refreshView
            
        } else {
            // Fallback on earlier versions
        };
    }
    
    @objc func beginRefreshData(_ refreshView: UIRefreshControl) -> Void {
        
    }
    


    func createTable(delegate: UITableViewDataSource & UITableViewDelegate) {
        createTable(frame: navigateRect, delegate: delegate);
    }
    
    func createCollection(frame: CGRect,layout: UICollectionViewLayout,delegate: UICollectionViewDelegate & UICollectionViewDataSource) -> Void {
        
        baseCollectionView = FMBaseCollectionView(frame: frame, collectionViewLayout: layout);
        addView(tempView: baseCollectionView);
        baseCollectionView.delegate = delegate;
        baseCollectionView.dataSource = delegate;
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true);
        self.baseTable?.isUserInteractionEnabled = true;
        self.isUserEnableSubviews = true;
        super.touchesBegan(touches, with: event);
    }
    
    func didSelectedImage(info:[String : Any],image: UIImage) -> Void {
        
    }
    
    deinit {
        printObject("deinit = \(self)");
    }

}

extension YyBaseViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func showSystemCamera(canEdit: Bool = true) -> Void {
        let alert = UIAlertController(title: "", message: "打开文件", preferredStyle: .actionSheet);
        let cancel = UIAlertAction(title: "取消", style: .cancel) { (action) in
            
        };
        let camer = UIAlertAction(title: "打开相机", style: .default) { (action) in
            self.openAppCamera(sourceType: .camera,canEdit: canEdit);
        };
        let phonto = UIAlertAction(title: "打开照片", style: .default) { (action) in
            self.openAppCamera(sourceType: .photoLibrary,canEdit: canEdit);
        };
        alert.addActions(aItems: [cancel,camer,phonto]);
        
        
        
        self.present(alert, animated: true) {
            
        };
    }
    
    // MARK: - open camera and phone
    
    func openAppCamera(sourceType: UIImagePickerControllerSourceType,canEdit: Bool = true) -> Void {
        
        if !UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let name = sourceType == .camera ? "相机" : "相册";
            showTip(msg: "不能打开\(name)", showCancel: false, finsihed: { (tag) -> (Void) in
                
            });
            return;
        }
        let name = sourceType == .camera ? "相机" : "相册";

        SVProgressHUD.show(withStatus: "正在打开\(name)")
        
        let ctrl = UIImagePickerController();
        ctrl.sourceType = sourceType;
        ctrl.allowsEditing = canEdit;
        ctrl.delegate = self;
        self.present(ctrl, animated: true) {
            SVProgressHUD.dismiss();
        };
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        picker.dismiss(animated: true) {
            
        };
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            didSelectedImage(info: info, image: image);
        }else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            didSelectedImage(info: info, image: image);
        }
        
    }
    
    
    
//    deinit {
//        printObject("deinit = \(self)");
//    }
}

extension UIViewController {
    func width() -> CGFloat {
        return view.frame.width;
    }
    func height() -> CGFloat {
        return view.frame.height;
    }
    
    func frame() -> CGRect {
        return self.view.frame;
    }
    func bounds(y: CGFloat = 0) -> CGRect {
        
        return CGRect(x: 0, y: y, width: width(), height: height() - y);
    }
    func addView(tempView: UIView) {
        self.view.addSubview(tempView);
    }
    
    
    
    func showTip(msg: String,showCancel: Bool = false,finsihed: ((Int) -> (Void))? = nil) -> Void {
        let alert = UIAlertController(title: "提示", message: msg, preferredStyle: .alert);
        
        if showCancel {
            let cancel = UIAlertAction(title: "取消", style: .cancel) { (action) in
                finsihed?(0);
            };
            alert.addAction(cancel);
        }
        
        let confim = UIAlertAction(title: "确定", style: .destructive) { (action) in
            finsihed?(1);
        };
        alert.addAction(confim);
        
        
        self.present(alert, animated: true) { 
            
        };
    }
    
    func showAlertView(alertTitle: String,msg: String,finished: @escaping ((Int,String) -> (Void))) ->Void {
        let alert = UIAlertController(title: alertTitle, message: msg, preferredStyle: .alert);
        let cancel = UIAlertAction(title: "取消", style: .cancel) { (action) in
            
        };
        let confim = UIAlertAction(title: "确定", style: .destructive) { (action) in
            
            if let textView = alert.textFields?.first {
                if !textView.text!.isEmpty {
                   finished(1,textView.text!);
                }

            }
            
        };
        
        alert.addTextField { (textView) in
            textView.keyboardType = .default;
        }
        alert.addAction(cancel);
        alert.addAction(confim);
        self.present(alert, animated: true) { 
            
        }
    }
    
}

extension UIAlertController{
    func addActions(aItems: [UIAlertAction]) -> Void {
        for item in aItems {
            addAction(item);
        }
    }
}
