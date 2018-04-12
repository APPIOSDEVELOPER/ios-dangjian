//
//  HttpParamterModel.swift
//  StudyApp
//
//  Created by yaojinhai on 2018/4/12.
//  Copyright © 2018年 yaojinhai. All rights reserved.
//

import UIKit

enum HttpViaType {
    case other
    case image
}

class HttpParamterModel: NSObject {

    var isBodyPrammter = false;
    var key = "";
    var value = "";
    var dataValue: Data!
    var isData = false;
    var fileType = HttpViaType.image;
    var typeStrl: String {
        return "image/png";
    }

    
    convenience init(key: String,value: String,isBody: Bool = false) {
        self.init();
        self.key = key;
        self.value = value;
        self.isBodyPrammter = isBody;
    }
    convenience init(key: String,valueData: Data) {
        self.init();
        self.key = key;
        self.dataValue = valueData;
        self.isData = true;
        self.isBodyPrammter = true;
    }
    
    
    class func getHttpBodyData(paramterList: [HttpParamterModel],bodyBoundary:String) -> Data? {
        
        let listModel = getBodyParamter(list: paramterList, isBody: true);
        
        if listModel.count == 0 {
            return nil;
        }
        var bodyData = Data();
        let debugDataString = NSMutableString();
        
        for item in listModel {
            
            let boundLine = "--" + bodyBoundary + "\r\n";
            bodyData.append(boundLine.data);
            debugDataString.append(boundLine);
            
            if item.isData {
                
                let bodyLine = "--" + bodyBoundary + "\r\n";
                bodyData.append(bodyLine.data);
                debugDataString.append(bodyLine);
                
                let inputKey = """
                Content-Disposition: form-data;name="file";fileName="\(item.key)";\(item.typeStrl)\r\n
                """;
                
                bodyData.append(inputKey.data);
                debugDataString.append(inputKey);
                
                
                let endFlag = "\r\n";
                bodyData.append(endFlag.data);
                debugDataString.append(endFlag);
                
                
                bodyData.append(item.dataValue);
                debugDataString.append(item.key);
                
                bodyData.append(endFlag.data);
                debugDataString.append(endFlag);
                
            }else {
                
                let inputKey = "Content-Disposition: form-data; name=\"\(item.key)\"" + "\r\n\r\n";
                bodyData.append(inputKey.data);
                debugDataString.append(inputKey);
                
                bodyData.append(item.value.data);
                debugDataString.append(item.value);
                
                let endFlag = "\r\n";
                bodyData.append(endFlag.data);
                debugDataString.append(endFlag);
                
            }
            
        }
        
        
        
        let endBound = "--" + bodyBoundary + "--\r\n";
        bodyData.append(endBound.data);
        
        debugDataString.append(endBound);
        
        printObject("http body type: \n\(debugDataString)")
        
        
        return bodyData;
    }
    
    
    class func getBodyParamter(list: [HttpParamterModel],isBody: Bool) -> [HttpParamterModel] {
        
        var tempList = [HttpParamterModel]();
        for item in list {
            if item.isBodyPrammter && isBody {
                tempList.append(item);
            }else if !isBody && !item.isBodyPrammter{
                tempList.append(item);
            }
        }
        return tempList;
    }
    class func getPairKeyAndValue(list: [HttpParamterModel]) -> String {
        var tempStrl = "?";
        for item in list {
            if item.isBodyPrammter{
                continue;
            }
            let valueString = item.key.encode + "=" + item.value.encode + "&";
            tempStrl.append(valueString);
        }
        if tempStrl.count > 0 {
            tempStrl = String(tempStrl.dropLast());
        }
        return tempStrl;
    }
    
    
    
    private override init() {
        super.init();
    }
}

extension String {
    var data: Data {
        return self.data(using: String.Encoding.utf8)!;
    }
    var encode: String {
        let encodeStrl = self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed);
        return encodeStrl!;
    }
}
extension UIImage {
    var pngData: Data {
        return UIImagePNGRepresentation(self)!;
    }
    var jpgData: Data {
        return UIImageJPEGRepresentation(self, 1)!;
    }
}
