//
//  FMBaseTableView.swift
//  KuaiJi
//
//  Created by yaojinhai on 2017/6/20.
//  Copyright © 2017年 yaojinhai. All rights reserved.
//

import UIKit

class FMBaseTableView: UITableView {
    
    convenience init(frame: CGRect) {
        self.init(frame: frame, style: .plain);
    }

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style);
        self.showsVerticalScrollIndicator = false;
        keyboardDismissMode = .onDrag
        separatorStyle = .none
        clipsToBounds = true;
        backgroundColor = UIColor.clear;


    }
    
    convenience init(frame: CGRect, delegate: UITableViewDelegate & UITableViewDataSource) {
        self.init(frame: frame);
        self.dataSource = delegate;
        self.delegate = delegate;
        backgroundColor = UIColor.clear;
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
   

}
