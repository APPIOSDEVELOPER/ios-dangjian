//
//  MangerVideoViewController.swift
//  StudyApp
//

import UIKit
import MediaPlayer
import AVKit
import AVFoundation

class MangerVideoViewController: SuperBaseViewController {

    var tableheaderView: BaseCustomView!
    
    var keyBardView: KeybaordCustomView!
    
    var id = 0;
    var cModel: ContentDetialModel!
    
    var webView: CustomWebView!
    
    var commentDetialList: [CommentDeitalModel]!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableheaderView = BaseCustomView(frame: .init(x: 0, y: 0, width: sWidth, height: 286), type: .videoView);
        tableheaderView.backgroundColor = UIColor.white;
        tableheaderView.supNameLabel.addTarget(self, action: #selector(buttonAction(btn:)), for: .touchUpInside);
        tableheaderView.supNameLabel.tag = ViewTagSense.supTag.rawValue;
        tableheaderView.commentButton.addTarget(self, action: #selector(buttonAction(btn:)), for: .touchUpInside);
        tableheaderView.commentButton.tag = ViewTagSense.sendMsgFlagTag.rawValue;
        tableheaderView.subButton.addTarget(self, action: #selector(buttonAction(btn:)), for: .touchUpInside);
        tableheaderView.subButton.tag = ViewTagSense.playOrStopTag.rawValue;
        tableheaderView.titleButton.addTarget(self, action: #selector(buttonAction(btn:)), for: .touchUpInside);
        tableheaderView.shareBtn.addTarget(self, action: #selector(buttonAction(btn:)), for: .touchUpInside);
        tableheaderView.titleButton.tag =  ViewTagSense.fullScreenVedioTag.rawValue;
        tableheaderView.shareBtn.tag = ViewTagSense.shareTag.rawValue;
        

        createTable(delegate: self);
        baseTable.rowHeight = UITableViewAutomaticDimension;
        baseTable.estimatedRowHeight = 70;
        baseTable.separatorStyle = .singleLine;
        baseTable.register(CommentTableCell.classForCoder(), forCellReuseIdentifier: "cell");
        
        
        
        keyBardView = KeybaordCustomView(frame: .init(x: 0, y: height() - 52, width: width(), height: 52));
        keyBardView.backgroundColor = UIColor.white;
        addView(tempView: keyBardView);
        keyBardView.doneBtn.tag = ViewTagSense.sendMsgTag.rawValue;
        keyBardView.doneBtn.addTarget(self, action: #selector(buttonAction(btn:)), for: .touchUpInside);
        
        
//        createWebView();
        
//        playerURL(videoURL: "http://112.126.73.158:80/images/upload/video/20180130/1517290045205019332.mp4");
    }
    
    func playerURL(vedioURL: URL?) -> Void {
        if tableheaderView.playerView.player != nil && tableheaderView.playerView.player!.rate > 0 {
            tableheaderView.playerView.player?.pause();
        }
        if vedioURL != nil {
            let play = AVPlayer(url: vedioURL!);
            tableheaderView.playerView.player = play;
            play.play();
        }
    }
    
    func reloadDataByModel(md: ContentDetialModel) -> Void {
        self.playerURL(vedioURL: md.vedioURL)
        tableheaderView.titleLabel.text = md.post_excerpt;
//        tableheaderView
    }
    
    func createWebView() -> Void {
        webView = CustomWebView.createWebView(frame: navigateRect);
        addView(tempView: webView);

        let urlString = baseURLAPI + "/note/" + "\(id)";
        let url = URL(string:urlString);
        webView.load(URLRequest(url: url!));
        
        
    }
    
    deinit {
        tableheaderView.playerView.player?.pause();
        
    }
    
    
    func loadStudyDetial() -> Void {
        
        let request = UserRequest(value: "\(id)", jointType: .newsDetial);
        request.cls = ContentDetialModel.classForCoder();
        request.loadJsonStringFinished {
            [weak self](result, success) in
            guard let model = result as? BaseModel,
                 let cM = model.baseDataModel as? ContentDetialModel else{
                return;
            }
            self?.reloadDataByModel(md: cM);
            
            
//            self.cModel = model.baseDataModel as? ContentDetialModel;
        };
        
    }
    

    
    override func loadDataFromNet(net: Bool) {
        
        loadStudyDetial();
        loadCommentList();
        
    }
    func loadCommentList() -> Void {
        let request = UserRequest(value: "\(id)", jointType: .commentList);
        request.cls = CommentDeitalModel.classForCoder();
        request.loadJsonStringFinished {
            [weak self](result, success) in
            self?.baseTable.mj_footer?.endRefreshing();
            guard let model = result as? BaseModel,
                let items = model.baseDataList as? [CommentDeitalModel] else{
                    return;
            }
            self?.commentDetialList = items;
            self?.tableheaderView.messageLabel.text = "评论(\(items.count))"
            self?.baseTable.reloadData();
            
        };
    }
    
    @objc override func buttonAction(btn: UIButton) {
        
        if btn.tag == ViewTagSense.fullScreenVedioTag.rawValue {
            
            let videoCtrl = AVPlayerViewController();
            videoCtrl.allowsPictureInPicturePlayback = true;
            videoCtrl.player = tableheaderView.playerView.player
            videoCtrl.player?.play();
            self.present(videoCtrl, animated: true) {
                
            }
            
            
        }else if btn.tag == ViewTagSense.playOrStopTag.rawValue {
            btn.isSelected = !btn.isSelected;
            if btn.isSelected {
                tableheaderView.playerView.player?.pause();
            }else{
                tableheaderView.playerView.player?.play();
            }
            beginAlphaView();
        }else if btn.tag == ViewTagSense.sendMsgTag.rawValue {
            self.view.endEditing(true);
            commentNews();
            keyBardView.text = "";
        }else if btn.tag == ViewTagSense.sendMsgFlagTag.rawValue {
            keyBardView.isActivityTextView = true;
        }else if btn.tag == ViewTagSense.supTag.rawValue {
            btn.isSelected = !btn.isSelected;
            supNews();
        }else if btn.tag == ViewTagSense.shareTag.rawValue {
            let ctrl = ShareViewController();
            self.present(ctrl, animated: true, completion: {
                
            });
        }
        
        
        
    }
    
    func supNews() -> Void {
        let request = UserRequest(value: "\(id)", jointType: .learnSurname);
        request.cls = BaseModel.classForCoder();
        request.loadJsonStringFinished {//[weak self]
            (result, success) in
            guard let model = result as? BaseModel else{
                return;
            }
            self.showTip(msg: model.result_msg);
        };
    }
    
    
    func commentNews() -> Void {
        let request = UserRequest(comment: keyBardView.text, postId: id, author: "",commentType:.news);
        request.respType = .typeModel;
        request.loadJsonStringFinished { [weak self](result, success) in
            guard let model = result as? BaseModel else{
                return;
            }
            if model.isSuccess {
                self?.loadCommentList();
            }else{
                self?.showTip(msg: model.result_msg);
            }
        };
        
    }
    
    func beginAlphaView() -> Void {
        stopALphaView();
        self.perform(#selector(reverserView(_:)), with: nil, afterDelay: 2);
    }
    func stopALphaView() -> Void {
        NSObject.cancelPreviousPerformRequests(withTarget: self);
    }
    
    
    @objc func reverserView(_ auto: Bool = false) -> Void {
        
        UIView.animate(withDuration: 0.2) {
            if auto {
                let alpha: CGFloat = self.tableheaderView.vedioCtrl.alpha == 1 ? 0 : 1;
                self.tableheaderView.vedioCtrl.alpha = alpha;
            }else{
                self.tableheaderView.vedioCtrl.alpha = 1;
            }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        stopALphaView();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        guard let rate = tableheaderView.playerView.player?.rate else {
            return;
        }
        if rate == 0 {
            tableheaderView.playerView.player?.play();
        }
    }
    
    @objc func showFullScreen(_ tap:UITapGestureRecognizer) -> Void {
        
        
        reverserView(true);
        
//        let point = tap.location(in: tap.view);
//        if point.x > tableheaderView.maxY - 100 {
//            return;
//        }
//
//
        
    }

    // MARK: - table view delgate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableheaderView;
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableheaderView.height;
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentDetialList?.count ?? 0;
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CommentTableCell;
        let item = commentDetialList[indexPath.row];
        cell.configCell(model: item);
        
        return cell;
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
    }
    

}

class CommentTableCell: BaseTableViewCell {
    
//    var anwserLabel: UILabel!
    
    
    func configCell(model: CommentDeitalModel) -> Void {
        titleLabel.text = model.comment_author;
        subTitleLabel.text = model.comment_date;
        rightText.text = model.comment_content;
        
        guard let url = model.photoURL else {
            leftImage.image = #imageLiteral(resourceName: "icons_57.png");
            return;
        }
        leftImage.sd_setImage(withURLString: url);

    }
    
    override func initView() {
        leftImage = createImageView();
        leftImage.image = #imageLiteral(resourceName: "Comments_head01.png");
        leftImage.snp.makeConstraints { (maker) in
            maker.left.equalTo(10);
            maker.top.equalTo(10);
            maker.size.equalTo(CGSize.init(width: 35, height: 35));
        }
        
        titleLabel = createLabel();
        titleLabel.text = "特朗普总统";
        titleLabel.numberOfLines = 1;
        titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.leftImage.snp.right).offset(6);
            maker.top.equalTo(self.leftImage.snp.top).offset(6);
            maker.right.equalTo(-30);
        }
        
//        anwserLabel = createLabel();
//        anwserLabel.text = "回复";
//        anwserLabel.font = fontSize(size: 12);
//        anwserLabel.textColor = UIColor.lightGray;
//        anwserLabel.snp.makeConstraints { (maker) in
//            maker.right.equalTo(self.snp.right).offset(-10);
//            maker.top.equalTo(self.titleLabel.snp.top);
//        }
        
        
        subTitleLabel = createLabel();
        subTitleLabel.font = fontSize(size: 10);
        subTitleLabel.text = "发表于1小时前";
        subTitleLabel.numberOfLines = 1;
        subTitleLabel.textColor = rgbColor(rgb: 204);
        subTitleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.titleLabel.snp.left);
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(4);
            maker.right.equalTo(self.titleLabel.snp.right);
        }
        
        rightText = createLabel();
        rightText.text = "新华社北京1月11日电 中共中央总书记、国家主席、中央军委主席习近平11日上午在中国共产党第十九届中央纪律检查委员会第二次全体会议上发表重要讲话。他强调，在中国特色社会主义新时代，完成伟大事业必须靠党的领导，党一定要有新气象新作为。要全面贯彻党的十九大精神，重整行装再出发，以永远在路上的执着把全面从严治党引向深入";
        rightText.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.titleLabel.snp.left);
            maker.right.equalTo(-10);
            maker.bottom.equalTo(-10);
            maker.top.equalTo(self.leftImage.snp.bottom).offset(10);
        
        }
        
    }
}




