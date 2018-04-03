//
//  DFSMViewController.swift
//  StudyApp
//
//  Created by yaojinhai on 2018/3/27.
//  Copyright © 2018年 yaojinhai. All rights reserved.
//

import UIKit
// 党费说明
class DFSMViewController: SuperBaseViewController {

    var textView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textView = UITextView(frame: navigateRect);
        addView(tempView: textView);
        textView.textContainerInset = UIEdge(size: 10);
    
    }

    

}
