//
//  FileManager.swift
//  StudyApp
//


import UIKit

class FMFileManger: NSObject {
    
    class func key(key: String) -> AnyObject? {
        return fileManager.keyValue(key: key as NSString);
    }
    
    class func add(key: NSString,value: AnyObject) -> Void {
        fileManager.add(key: key, value: value);
    }
    
    //MARK: - private method
    
    private var chaches = NSCache<NSString, AnyObject>();
    private static let fileManager = FMFileManger();
    private override init() {
        super.init();
        chaches.evictsObjectsWithDiscardedContent = true;
        NotificationCenter.default.addObserver(self, selector: #selector(clearMemery(_:)), name: NSNotification.Name.UIApplicationDidReceiveMemoryWarning, object: nil);
        
    }
    @objc private func clearMemery(_ noti: NSNotification) -> Void {
        chaches.removeAllObjects();
    }
    
    private func add(key: NSString,value: AnyObject) -> Void {
        chaches.setObject(value, forKey: key);
    }
    private func keyValue(key: NSString) -> AnyObject? {
        return chaches.object(forKey: key);
    }
    
}
