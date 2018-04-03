//
//  BaseCustomView.swift
//  KuaiJi
//


import UIKit
import CoreVideo
enum BaseCustomViewType : Int {
    case customUnkonw
    case beginOptionView // 回答问题的view
    case studyItemTitle // 学习 view 上边的分栏
    case commentItemView // 评论view
    case managerLineView // 功能管理的line
    case timerLabel // 时间 表
    case funSegment // 2 个 选择
    case personDetial // 档案详情 的 头部
    case videoView
    case loginSegmentView // 登陆的view
    case qqWXType
}


protocol BaseCustomViewDelegate: NSObjectProtocol {
    // over timer fun
    
    func overTime(view: BaseCustomView) -> Void;
    func didFinishedTime(view: BaseCustomView) -> Void;
}

class BaseCustomView: UIView {

    var titleLabel: UILabel!
    var subTitleLabel: UILabel!
    var messageLabel: UILabel!
    
    var titleImageView: UIImageView!
    var subTitleImageView: UIImageView!
    
    var textField: UITextField!
    var subTextField: UITextField!
    
    var textView: UITextView!
    var subTextView: UITextView!
    
    var titleButton: UIButton!
    var subButton: UIButton!
    
    var commentButton: UIButton!
    var supNameLabel: UIButton!
    var shareBtn: UIButton!
    var closeBtn: UIButton!
    
    var webView: UIWebView!
    
    var baseView: BaseCustomView!
    
    var playerView: AVPlayerLayer!
    
    var vedioCtrl: UIView!
    
    var delegate: BaseCustomViewDelegate!
    
    var countScond = 100; // 秒
    
    
    var speakImageView: UIImageView!
    var speakLabel: UILabel!
    
    var isAddKeyBoradNotification = false{
        didSet{
            if isAddKeyBoradNotification {
                addKeyBoradNotification();
            }
        }
    }
    private var currentType = BaseCustomViewType.customUnkonw;

    private var preIndex = -1;
    
    var currentIndex = 0 {
        didSet{
            setCurrentIndex();
        }
    }
    var lineTextView: UILabel!
    
    
    // private attrubte
    
    private var keyboardFrame = CGRect.zero;

    
    override init(frame: CGRect) {
        super.init(frame: frame);
    }
    convenience init(frame: CGRect,type: BaseCustomViewType){
        self.init(frame: frame);
        setType(type: type);
    }
    // 只用来设置 播放 初始化状态
    
    func setType(type: BaseCustomViewType) -> Void {
        currentType = type;
        
        switch type {
        case .beginOptionView:
            
            let backView = createView();
            backView.snp.makeConstraints({ (maker) in
                maker.left.right.top.equalTo(0);
                maker.height.equalTo(50);
            })
            
            baseView = BaseCustomView(frame: .init(x: 0, y: 0, width: sWidth, height: 50), type: .timerLabel);
            addSubview(baseView);
            baseView.backgroundColor = UIColor.white;
            baseView.snp.makeConstraints({ (maker) in
                maker.left.right.top.equalTo(0);
                maker.height.equalTo(50);
            })
            
            
            let questionFlagLabel = createLabel(frame: .zero);
            questionFlagLabel.textColor = rgbColor(r: 206, g: 66, b: 69);
            questionFlagLabel.font = fontSize(size: 14);
            questionFlagLabel.text = "单选";
            questionFlagLabel.snp.makeConstraints({ (maker) in
                maker.left.equalTo(10);
                maker.top.equalTo(backView.snp.bottom).offset(15);
            })
            
            let questionLabel = createLabel(frame: .zero);
            questionLabel.font = fontSize(size: 14);
            questionLabel.textColor = UIColor.white;
            questionLabel.backgroundColor = rgbColor(r: 206, g: 66, b: 69);
            questionLabel.text = "1/10"
            questionLabel.snp.makeConstraints({ (maker) in
                maker.left.equalTo(questionFlagLabel.snp.right).offset(5);
                maker.centerY.equalTo(questionFlagLabel.snp.centerY);
                
            })
            
            
            
            titleLabel = createLabel(frame: .zero);
            
            titleLabel.snp.makeConstraints({ (maker) in
                maker.left.equalTo(20);
                maker.bottom.equalTo(-20);
                maker.right.equalTo(-20);
            })
            
        case .loginSegmentView:
            
            titleLabel = createLabel(frame: .zero);
            titleLabel.textAlignment = .center;
            subTitleLabel = createLabel(frame: .zero);
            subTitleLabel.textAlignment = .center;
            titleLabel.font = fontBlod(size: 19);
            subTitleLabel.font = fontBlod(size: 19);
            titleLabel.text = "登录";
            subTitleLabel.text = "注册";
            
//            subTitleLabel.highlightedTextColor =  rgbColor(r: 208, g: 8, b: 8);
//            titleLabel.highlightedTextColor = rgbColor(r: 208, g: 8, b: 8);
            subTitleLabel.textColor = UIColor.white;
            titleLabel.textColor = UIColor.white;
            
            titleLabel.snp.makeConstraints({ (maker) in
                maker.left.top.equalTo(0);
                maker.height.equalTo(self.snp.height);
                maker.width.equalTo(self.snp.width).multipliedBy(0.5);
            })
            subTitleLabel.snp.makeConstraints({ (maker) in
                maker.left.equalTo(self.titleLabel.snp.right);
                maker.top.equalTo(0);
                maker.size.equalTo(self.titleLabel.snp.size);
            })
            
            
            lineTextView = createLabel(frame: .zero);
//            lineTextView.backgroundColor = rgbColor(r: 208, g: 9, b: 9);
            lineTextView.backgroundColor = UIColor.white;// rgbColor(r: 208, g: 9, b: 9);

            
        case .videoView:
            
            
//            http://112.126.73.158/images/upload/video/20180204/1517750064251001992.mp4
            
           let url = "http://video.southcn.com/00f016d0e7f44fd3bcc4bb97f600165c/7df5c69f5f1540469d95d92876e1d544-625b659217983870cbfac26359f7ac1a.mp4"
           
            let player = AVPlayer(url: URL(string: url)!);
            playerView = AVPlayerLayer(player: player);
            playerView.frame = .init(x: 0, y: 0, width: width, height: height - 110)//UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, 0, 60, 0));
            playerView.contentsScale = iOSIPhoneInfoData.scale;
            playerView.videoGravity = .resize;
            layer.addSublayer(playerView);
            playerView.backgroundColor = UIColor.white.cgColor;
            player.play();
           
            
            titleLabel = createLabel(frame: .init(x: 10, y: playerView.frame.maxY + 8, width: width - 60, height: 20));
            titleLabel.text = "普京在东京访问";
            
            let rightFlag = createLabel(frame: .init(x: width - 60, y: titleLabel.minY, width: 60, height: 20), text: "简介＞");
            rightFlag.textAlignment = .center;
            rightFlag.textColor = rgbColor(rgb: 221);
            
            
            
            commentButton = createButton(rect: .init(x: 10, y: rightFlag.maxY + 10, width: 17, height: 16), backImage: nil);
            commentButton.setImage(UIImage(named: "comment"), for: .normal);
            
            
            
            

            supNameLabel = createButton(rect: .init(x: width - 40 - 35, y: commentButton.minY, width: 20, height: 20), backImage: nil);
            supNameLabel.setImage(UIImage(named:"praise.png"), for: .normal);
            supNameLabel.setImage(UIImage(named:"praise01.png"), for: .selected);
            supNameLabel.tag = 0;
           
           shareBtn = createButton(rect: .init(x: width - 40, y: commentButton.minY, width: 20, height: 20), backImage: nil);
           shareBtn.setImage(#imageLiteral(resourceName: "share_btn_icon.png"), for: .normal);
           
           
           
            
            let lineView = createView();
            lineView.backgroundColor = rgbColor(rgb: 221);
            lineView.frame = .init(x: 10, y: supNameLabel.maxY + 10, width: width - 20, height: 1);
            
            messageLabel = createLabel(frame: .init(x: 10, y: lineView.maxY + 5, width: 100, height: 20), text: "评论(0)");
            
            let allComment = createLabel(frame: .init(x: width - 100, y: messageLabel.minY, width: 90, height: 20), text: "全部评论＞");
            allComment.textAlignment = .right;
            
            
            vedioCtrl = createView();
            vedioCtrl.frame = .init(x: playerView.frame.minX, y: playerView.frame.maxY - 30, width: playerView.frame.width, height: 30);
            vedioCtrl.backgroundColor = UIColor.white.withAlphaComponent(0.5);
            
            subButton = createButton(rect: .init(x: (width - 30)/2, y: 0, width: 30, height: 30), backImage: nil);
            subButton.setImage(UIImage(named:"play_icon"), for: .normal);
            subButton.setImage(UIImage(named:"stop_icon"), for: .selected);
            vedioCtrl.addSubview(subButton);
            
            
            titleButton = createButton(rect: .init(x: width - 30, y: 0, width: 30, height: 30), backImage: nil);
            titleButton.setImage(UIImage(named:"fang_da"), for: .normal);
            titleButton.imageEdgeInsets = UIEdge(size: 4);
            vedioCtrl.addSubview(titleButton);
            
            
            
        case .studyItemTitle:
            
            titleLabel = createLabel(frame: .zero);
            titleLabel.font = fontSize(size: 14);
            titleLabel.text = "两学一做"
            titleLabel.textColor = rgbColor(r: 204, g: 0, b: 0);
            titleLabel.snp.makeConstraints({ (maker) in
                maker.left.equalTo(10);
                maker.top.equalTo(15);
            })
            
            let lineView = createImageView(frame: .zero);
            lineView.backgroundColor = rgbColor(r: 188, g: 73, b: 29);
            lineView.snp.makeConstraints({ (maker) in
                maker.left.equalTo(self.titleLabel.snp.left);
                maker.bottom.equalTo(self.snp.bottom);
                maker.width.equalTo(self.titleLabel.snp.width);
                maker.height.equalTo(2);
            })
            
        case .commentItemView:
            
            // height 21 + 30
            backgroundColor = rgbColor(rgb: 237);

            textField = createTextField(rect: CGRect.init(x: 0, y: 0, width: sWidth - 10, height: height));
            textField.autoresizingMask = [.flexibleWidth,.flexibleHeight];
            textField.font = fontSize(size: 14);
            textField.returnKeyType = .done;
            textField.enablesReturnKeyAutomatically = true;
            let leftFlagView = UIImageView.init(frame: .init(x: 10, y: 10, width: 40, height: 21));
            leftFlagView.image = #imageLiteral(resourceName: "compile.png");
            leftFlagView.contentMode = .scaleAspectFit;
            textField.leftView = leftFlagView;
            textField.leftViewMode = .always;
            


            subButton = UIButton(type: .custom);
            subButton.frame = .init(x: 0, y: 0, width: height, height: height);
            subButton.setImage(UIImage(named:"praise.png"), for: .normal);
            subButton.setImage(UIImage(named:"praise01.png"), for: .selected);
            
            titleButton = UIButton(type: .custom);
            titleButton.frame = .init(x: height, y: 0, width: height, height: height);
            titleButton.setImage(#imageLiteral(resourceName: "share_btn_icon.png"), for: .normal);
            
            let rightView = UIView(frame: .init(x: 0, y: 0, width: height * 2, height: height));
            rightView.addSubview(subButton);
            rightView.addSubview(titleButton);

            textField.rightView = rightView;
            textField.rightViewMode = .always;
            
        case .qqWXType:
            let perWidth: CGFloat = height;
            titleButton = createButton(rect: .init(x: (width - perWidth * 2 - 60)/2, y: 0, width: perWidth, height: perWidth), backImage: #imageLiteral(resourceName: "login_qq.png"));
            subButton = createButton(rect: .init(x: titleButton.maxX + 60, y: 0, width: perWidth, height: perWidth), backImage: #imageLiteral(resourceName: "login_weixin.png"));
            
            
        case .managerLineView:
            
            let lineView = createLabel(frame: .init(x: 0, y: height - 1, width: width, height: 1));
            lineView.backgroundColor = rgbColor(rgb: 223);
            
            let titleLabel = createLabel(frame: .init(x: 10, y: 15, width: 100, height: 16));
            titleLabel.font = fontSize(size: 14);
            titleLabel.text = "管理";
            titleLabel.textColor = rgbColor(rgb: 51);
            
                
        case .timerLabel:
            
            titleLabel = createLabel(frame: .init(x: 40, y: 0, width: width - 80, height: height));
            titleLabel.font = fontSize(size: 14);
            titleLabel.textColor = UIColor.gray;
            titleLabel.textAlignment = .center;
            
            
            
        case .funSegment:
            titleLabel = createLabel(frame: .init(x: 0, y: 0, width: width / 2, height: 60));
            subTitleLabel = createLabel(frame: .init(x: width / 2, y: 0, width: width / 2, height: 60));
            
            titleLabel.font = fontSize(size: 15);
            subTitleLabel.font = fontSize(size: 15);
            
            titleLabel.text = "党务制度";
            subTitleLabel.text = "应知应会";
            titleLabel.textAlignment = .center;
            subTitleLabel.textAlignment = .center;
            
            lineTextView = createLabel(frame: .init(x: 0, y: 0, width: 17 * 4, height: 2));
            lineTextView.backgroundColor = rgbColor(r: 237, g: 128, b: 105)
        case .personDetial:
//        176 × 226
            let size = CGSize.init(width: 88 * 1.2, height: 68 * 1.2);
            
            titleImageView = createImageView(frame: .init(x: (width - size.width)/2, y: (height - size.height)/2, width: size.width, height: size.height));
            titleImageView.contentMode = .scaleAspectFit;
            
            
        default:
            break;
        }
    }
    
    func beginTime() -> Void {
        exeTimer();
    }
    func endTimer() -> Void {
        NSObject.cancelPreviousPerformRequests(withTarget: self);
    }
    @objc func exeTimer() -> Void {
        
        let min = countScond / 60;
        let second = countScond % 60;
        
        let minStrl = min > 9 ? "\(min)" : "0\(min)";
        let secondStrl = second > 9 ? "\(second)" : "0\(second)";
        
        if countScond > 0 {
            titleLabel?.text = minStrl + ":" + secondStrl;
            perform(#selector(exeTimer), with: nil, afterDelay: 1);
            countScond -= 1;
        }else {
            endTimer();
            delegate.overTime(view: self);
        }
        
    }
    
    func setCurrentIndex() -> Void {
        
        if preIndex == currentIndex {
            return;
        }
        if currentType == .funSegment {
            let scale: CGFloat = currentIndex == 0 ? 0.25 : 0.75;
            lineTextView.center = CGPoint.init(x: scale * width, y: height / 2 + 10);
        }else if currentType == .loginSegmentView {
            
            
            
            lineTextView.frame = .init(x: width / 2 * CGFloat(currentIndex) + 20, y: height - 2, width: (width / 2 - 40), height: 2);
            titleLabel.isHighlighted = currentIndex == 0 ? true : false;
            subTitleLabel.isHighlighted = currentIndex == 0 ? false : true;
        }
        preIndex = currentIndex;

    }
    
    
    private func addKeyBoradNotification() -> Void {
        
        let selector = #selector(keyBoradChange(notifier:));
        

        
        NotificationCenter.add(observer: self, selector: selector, name: NSNotification.Name.UIKeyboardWillShow);
        NotificationCenter.add(observer: self, selector: selector, name: NSNotification.Name.UIKeyboardWillHide);
        NotificationCenter.add(observer: self, selector: selector, name: NSNotification.Name.UITextViewTextDidChange);
        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyBoradChange(textdidchange:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil);
//        NotificationCenter.default.addObserver(self, selector: #selector(keyBoradChange(notifier:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil);
//        NotificationCenter.default.addObserver(self, selector: #selector(keyBoradChange(notifier:)), name: NSNotification.Name.UITextFieldTextDidChange, object: nil);
    }
    
    @objc func keyBoradChange(notifier: NSNotification) -> Void {
        guard let info = notifier.userInfo else {
            return;
        }
        
        keyboardFrame = info[UIKeyboardFrameEndUserInfoKey] as! CGRect;
        
        
        if notifier.name == NSNotification.Name.UIKeyboardWillShow {
            
            var lrect = self.frame;
            lrect.origin.y = sHeight - keyboardFrame.height - self.frame.height;
            self.frame = lrect;
            
        }else if notifier.name == NSNotification.Name.UIKeyboardWillHide{
            var lrect = self.frame;
            lrect.origin.y = sHeight - self.frame.height;
            self.frame = lrect;
        }else if notifier.name == NSNotification.Name.UITextFieldTextDidChange{
            
            guard let contentText = textField.text else {
                return;
            }
            var size = contentText.size(size: .init(width: sWidth - 130, height: CGFloat.greatestFiniteMagnitude), font: textField.font!.pointSize);
            if size.height < 51 {
                size.height = 51;
            }
            frame.origin.y = sHeight - size.height - keyboardFrame.height;
            frame.size.height = size.height;
            
            
        }
        
    }
    
    func createView() -> UIView {
        let view = UIView();
        addSubview(view);
        return view;
    }
    
    func createTextField(rect: CGRect) -> UITextField {
        let field = UITextField(frame: rect);
        addSubview(field);
        field.autocapitalizationType = .none;
        field.spellCheckingType = .no;
        field.autocorrectionType = .no;
        return field;
    }
    
    func createTextView(rect: CGRect) -> UITextView {
        let textView = UITextView(frame: rect);
        addSubview(textView);
        textView.autocorrectionType = .no;
        textView.autocapitalizationType = .none;
        textView.spellCheckingType = .no;
        textView.backgroundColor = UIColor.clear;
        return textView;
    }
    

    
    
    
    private func getAudioGIFImage(name: String) -> [UIImage]?{
        
        guard let gifPath = Bundle.main.url(forResource: name, withExtension: "gif"),let sourceImages = CGImageSourceCreateWithURL(gifPath as CFURL, nil) else {
            return nil;
        }

        let count = CGImageSourceGetCount(sourceImages);
        
        var images = [UIImage]();
        for idx in 0..<count {
            let cgImage = CGImageSourceCreateImageAtIndex(sourceImages, idx, nil);
            let image = UIImage(cgImage: cgImage!);
            images.append(image);
        }
        return images;
    
    }
    

    func addTap(target: Any,selector: Selector,view: UIView?) -> Void {
        let tap = UITapGestureRecognizer(target: target, action: selector);
        let subView = view ?? self;
        subView.addGestureRecognizer(tap);
        subView.isUserInteractionEnabled = true;
        
    }
    
    func addTap(target: Any,selector: Selector) -> Void {
        addTap(target: target, selector: selector, view: nil);
    }
    
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        print("new key = \(change?[.newKey]),\(titleLabel)<<<");
//    }
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createLabel(frame: CGRect,text: String = "") -> UILabel {
        let label = UILabel(frame: frame);
        label.text = text;
        label.textColor = UIColor.gray;
        label.font = fontSize(size: 14);
        addSubview(label);
        return label;
    }
    
    private func createButton(rect: CGRect,backImage: UIImage?) -> UIButton {
        let btn = UIButton(frame: rect);
        addSubview(btn);
        btn.backgroundColor = UIColor.clear;
        if let image = backImage{
            btn.setBackgroundImage(image, for: .normal);
        }
        btn.titleLabel?.font = fontSize(size: 15);
        return btn;
    }
    private func createImageView(frame: CGRect,name: String = "") -> UIImageView {
        let imageView = UIImageView(frame: frame);
        imageView.image = UIImage(named: name);
        addSubview(imageView);
        imageView.clipsToBounds = true;
        imageView.contentMode = .scaleAspectFill;
        return imageView;
    }
    
    deinit {
        if isAddKeyBoradNotification {
            NotificationCenter.default.removeObserver(self);
        }
    }

}
