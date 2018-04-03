//
//  DoptStedeView.swift
//  StudyApp
//
//  Created by yaojinhai on 2018/1/3.
//  Copyright © 2018年 yaojinhai. All rights reserved.
//

import UIKit
import MobileCoreServices

@available(iOS 11.0, *)
class DoptStedeView: UIView ,UIDropInteractionDelegate{

    func addDropAction() -> Void {
        let drop = UIDropInteraction(delegate: self);
        addInteraction(drop);
        
//        let cofing = UIPasteConfiguration(forAccepting: NSString.self);
//        cofing.addAcceptableTypeIdentifiers([kUTTypeImage as String,kUTTypeMovie as String])
//        self.pasteConfiguration = cofing;
        
        
        
    }
    
//    override func paste(itemProviders: [NSItemProvider]) {
//
//        for item in itemProviders {
//            let objsBl = item.canLoadObject(ofClass: UIImage.self);
//            print("objs bl = \(objsBl)");
//        }
//
//    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy);
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        
        let items = session.items;
        
//        for idx in items {
//           let press = idx.itemProvider.loadDataRepresentation(forTypeIdentifier: "abdc", completionHandler: { (data, error) in
//
//            });
//
//        }
        
        let obj = items[0].localObject as? TFinderItem;
        
        print("obj = \(obj?.name)");
        
//        obj?.loadData(withTypeIdentifier: TFinderItem.writableTypeIdentifiersForItemProvider.first!, forItemProviderCompletionHandler: { (data, error) in
//
//            let dataStrl = String.init(data: data!, encoding: String.Encoding.utf8);
//
//            print("data string = \(dataStrl)");
//
//        });
        
        
        
        
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return true;
    }
    
    
}
