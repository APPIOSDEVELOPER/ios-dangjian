//
//  MsgDeitalViewController.swift
//  StudyApp


import UIKit

class MsgDeitalViewController: SuperBaseViewController {

    var detial: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        detial = createLabel(rect: navigateRect, text: "消息详情");
        detial.font = fontSize(size: 20);
        detial.textAlignment = .center;
        detial.textColor = UIColor.darkGray;
    }

    

}
