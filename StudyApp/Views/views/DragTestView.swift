//
//  DragTestView.swift
//  StudyApp
//
//  Created by yaojinhai on 2017/12/29.
//  Copyright © 2017年 yaojinhai. All rights reserved.
//

import UIKit
import MobileCoreServices
@available(iOS 11.0, *)
class DragTestView: UIView,UIDragInteractionDelegate,UIDropInteractionDelegate {
    
    var objItm = TFinderItem();
    var iconView: UIImageView!
    
    
    func dragInteraction(_ interaction: UIDragInteraction, previewForLifting item: UIDragItem, session: UIDragSession) -> UITargetedDragPreview? {
        
        let paramter = UIDragPreviewParameters.init();
        paramter.backgroundColor = UIColor.green.withAlphaComponent(0.5);
        
        self.iconView = UIImageView(frame: .init(x: 30, y: 30, width: 40, height: 40));
        self.iconView.image = #imageLiteral(resourceName: "home_2.png");
        addSubview(self.iconView);
        
        
        let preview = UITargetedDragPreview.init(view: iconView, parameters: paramter);
        let dragView = interaction.view;
        let pointer = session.location(in: dragView!);
        let target = UIDragPreviewTarget(container: dragView!, center: pointer);
        
//        return UITargetedDragPreview(view: iconView, parameters: paramter, target: target);
        
        return preview;
    }
    func dragInteraction(_ interaction: UIDragInteraction, previewForCancelling item: UIDragItem, withDefault defaultPreview: UITargetedDragPreview) -> UITargetedDragPreview? {
        
        return nil;
        
//        let paramter = UIDragPreviewParameters.init();
//        paramter.backgroundColor = UIColor.green.withAlphaComponent(0.5);
//        iconView = UIImageView(frame: .init(x: 0, y: 0, width: 100, height: 100));
//        iconView.image = #imageLiteral(resourceName: "home_4.png");
//        let preview = UITargetedDragPreview.init(view: iconView, parameters: paramter);
//
//
//        return preview;
    }
    
    func dragInteraction(_ interaction: UIDragInteraction, session: UIDragSession, didEndWith operation: UIDropOperation) {
        print("cancel = \(operation.rawValue)");
    }

    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        return itemDargSession(session: session);
    }
    
    func itemDargSession(session: UIDragSession) -> [UIDragItem] {
        let provider = NSItemProvider(object: objItm);
//        provider.registerObject(NSString.self, visibility: .all);
//        provider.registerObject(UIImage.self, visibility: .all);
        let item = UIDragItem.init(itemProvider: provider);
        objItm.name = "name123";
        item.localObject = objItm;
        return [item];
    }
    
    func addDrage() -> Void {
        let dragItem = UIDragInteraction(delegate: self);
        addInteraction(dragItem);
        dragItem.isEnabled = true;
    }
    func dragInteraction(_ interaction: UIDragInteraction, sessionAllowsMoveOperation session: UIDragSession) -> Bool {
        return true;
    }
    
    // add drop second
    
    
}


class TFinderItem: NSObject,NSItemProviderWriting {
    
    var name = "张三";

    
    static var writableTypeIdentifiersForItemProvider: [String]{
        return ["public.jpeg","public.png"];
    }
    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        
        
        DispatchQueue(label: "load").asyncAfter(deadline: .now() + 2) {
            
            completionHandler("data".data(using: String.Encoding.utf8), nil);
            
            print("DispatchQueue")

        }
        
        
        
        return Progress.init();
    }
    
    
}









