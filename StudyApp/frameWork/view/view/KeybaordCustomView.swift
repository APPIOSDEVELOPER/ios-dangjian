//
//  KeybaordCustomView.swift
//  StudyApp
//
//  Created by yaojinhai on 2018/1/25.
//  Copyright © 2018年 yaojinhai. All rights reserved.
//

import UIKit

class KeybaordCustomView: BaseView,UITextViewDelegate {
    
    var doneBtn: UIButton!
    var text: String{
        set{
            textView.text = newValue;
            changeTextViewSize();
        }
        get{
            return textView.text;
        }
    }

    var isActivityTextView = false {
        didSet{
            if isActivityTextView {
                textView.becomeFirstResponder();
            }else {
                textView.resignFirstResponder();
            }
        }
    }
    
    private var textView: UITextView!
    private var keyBaordFrame = CGRect.zero;
    
    
    
    override func initView() {
        
        // 40
        let lineView = UIView(frame: .init(x: 0, y: 0, width: width, height: 1));
        addSubview(lineView);
        lineView.backgroundColor = rgbColor(rgb: 233);
        
        
        textView = UITextView(frame: .init(x: 10, y: 8, width: width - 80, height: height - 16));
        textView.layer.borderWidth = 1;
        textView.layer.borderColor = rgbColor(rgb: 233).cgColor;
        addSubview(textView);
        textView.font = fontSize(size: 14);
        textView.layer.cornerRadius = 4;
        textView.autoresizingMask = [.flexibleHeight,.flexibleWidth];
        textView.delegate = self;
        
        doneBtn = UIButton(frame: .init(x: textView.maxX + 10, y: 10, width: 50, height: height - 20));
        doneBtn.layer.cornerRadius = 4;
        doneBtn.setTitle("发送", for: .normal);
        doneBtn.titleLabel?.font = fontSize(size: 13);
        addSubview(doneBtn);
        doneBtn.setTitleColor(UIColor.darkText, for: .normal);
        doneBtn.autoresizingMask = [.flexibleLeftMargin,.flexibleRightMargin];
        doneBtn.layer.borderColor = rgbColor(rgb: 233).cgColor;
        doneBtn.layer.borderWidth = 1;
        
        addNotification();
        
    }
    
    private func addNotification() -> Void {
        NotificationCenter.default.addObserver(self, selector: #selector(notificationAction(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(notificationAction(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(notificationAction(_:)), name: NSNotification.Name.UITextViewTextDidChange, object: nil);

    }
    
    private func changeTextViewSize(){
        var size = textView.sizeThatFits(.init(width: width - 80, height: CGFloat.greatestFiniteMagnitude));
        
        if size.height > 100 {
            size.height = 100;
        }else if size.height < 36 {
            size.height = 36;
        }
        frame.size = CGSize.init(width: width, height: size.height + 16);
        
        if textView.isFirstResponder {
            frame.origin.y = sHeight - frame.height - keyBaordFrame.height;
        }else {
            frame.origin.y = sHeight;
        }
        
    }
    
    @objc func notificationAction(_ notifer:NSNotification) -> Void {
        
        
        if notifer.name == NSNotification.Name.UITextViewTextDidChange {
            
            changeTextViewSize();
            return;
        }
        
        guard let keyFrame = notifer.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect else {
            return;
        }
        keyBaordFrame = keyFrame;
        if notifer.name == NSNotification.Name.UIKeyboardWillShow {
            
            frame.origin.y = sHeight - keyFrame.height - frame.height;
            
        }else if notifer.name == NSNotification.Name.UIKeyboardWillHide{
            frame.origin.y = sHeight;
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self);
    }

}
