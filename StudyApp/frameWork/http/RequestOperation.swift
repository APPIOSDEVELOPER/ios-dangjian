//
//  RequestOperation.swift
//  CathAssist
//

import UIKit
import Foundation

let baseURLAPI = "http://dangjian.yaoyu-soft.com/langur/api" //api/"; // 测试
//let baseURLAPI = "http://dkj.free.ngrok.cc/langur/api" //api/";
//



typealias proBlock = (_ perceces: Float) -> Void
typealias finishedTask = (_ data: AnyObject?,_ success: Bool) -> Void
typealias startLoaing = () -> Void

enum ResponseType : Int {
    case typeData = 0
    case typeJson
    case typeModel
    case typeImage
    case typeString
}

enum HttpState : Int{
    case ready
    case execing
    case cancle
    case finshed
}

enum NoParmanterType {
    
//    case versionLatest // 检查版本更新
    case homeData // 获取首页的新闻类别
    case vedioCatogery // 视频类别
    case allApp // 党建百宝箱 column
    case userDetial // 用户信息
    case board // 党建看板
    
}

enum RouteCateogryType {
    case unknownType
    case news
    case video
    case articleList // 党建e连心 列表 ps：columnid=17 查询的是党建e连心的数据
    
    case register
    case forgetPass
}

enum JiontToURLEndType {
    
    case newsList // #获取首页的指定类别的新闻列表
    case surname // 新闻点赞接口 【完成】
    case learnSurname // 学习点赞接口 【完成】
    case commentList // 获取 评论 列表 (学习 和 新闻)
    case newsDetial // 获取新闻详情 【完成】
    case alterUserName // 修改用户名
    case partyExpenses // 党费管理
    case actionOther // 互动接口
    case onlineAnswer // 在线竞答
    case mangers // 查询党员【完成】
    case fetchCode // 获取验证码
    case managerDetialId //获取档案信息【完成】
}


class UserRequest : SuperHttpRequest {
    
    // MARK: - 无参数类型 请求
    
    var isAdduserid = false;
    
    convenience init(pathType: NoParmanterType){
        self.init();
        switch pathType {
        case .homeData:
            pathName = "1/column";
        case .vedioCatogery:
            pathName = "2/column";
        case .allApp:
            pathName = "14/column";
//            ps: 党建百宝箱分类下的文章接口（同建党e连心接口），只需要把columnid替换成栏目id
        case .userDetial:
            pathName = "managers/" + "\(UserInfoModel.getUserId())";
//            httpMethod = .POST;
            break;
            
        case .board:
            pathName = "board";
            
        }
    }
    
    // MARK:  - 只有一个参数并且 拼接到 url 后边
    convenience init(value: String,jointType: JiontToURLEndType){
        self.init();
        switch jointType {
        case .newsList:
            pathName = "";
        case .surname:
            pathName = "slender/article/surname";
            add(value: value, key: "post_id");
            self.httpMethod = .POST;
        case .learnSurname:
            pathName = "slender/learn/surname";
            httpMethod = .POST;
        case .commentList:
            pathName = "slender/comment/" + value;
        case .newsDetial:
            pathName = "learn/" + value;
            add(valueInt: UserInfoModel.getUserId(), key: "managerid");
            
//            add(value: , key: "id")
        case .alterUserName:
            pathName = "edit";
            httpMethod = .POST;
            isAdduserid = true;
            add(value: value, key: "name");
        case .partyExpenses:
            pathName = "party/expenses";
            add(value: value, key: "salary")
        case .actionOther:
            pathName = "square/list";
            add(value: value, key: "pageNum");
        case .onlineAnswer:
            pathName = "square/list/" + value;
        case .fetchCode:
            pathName = "code";
            httpMethod = .POST;
            add(value: value, key: "phone");
            add(valueInt: 1, key: "type");
        case .mangers:
            pathName = "managers";
            add(value: value, key: "pageNum");
        case .managerDetialId:
            pathName = "square/record/" + value;
            httpMethod = .POST;
            
        }
    }
    
    
    /// 获取大事件
    convenience init(bigevent pageNum: Int,name: String? = nil) {
        self.init();
        self.add(valueInt: pageNum, key: "pageNum");
        pathName = "bigevent/list";
    }
    
    //// 照片墙
    
    convenience init(branchPhotoWall page:Int) {
        self.init();
        pathName = "branchPhotoWall";
        add(valueInt: page, key: "pageNum");
        add(valueInt: UserInfoModel.getUserId(), key: "managerid");
    }
   
    convenience init(commited: [[String:Any]]) {
        self.init();
        pathName = "square/answer";
//        httpMethod = .POST;
        
        
        
//        let dict = [["subject_id":1,"option_opt":["a"]]];
        
        let jsonData = try? JSONSerialization.data(withJSONObject: commited, options: .prettyPrinted);
        let jsonStrl = String.init(data: jsonData!, encoding: String.Encoding.utf8);
        addBody(value: jsonStrl, key: "answer");
        
    }
    
    // 获取学习指定的视频列表
    convenience init(vedio: Int?,name: String?,pageNum: Int) {
        self.init();
        pathName = "learn/list";
//        httpMethod = .POST;
        if let name = name {
            add(value: name, key: "name");
        }
        if let id = vedio {
            add(valueInt: id, key: "columnid");
        }
        add(valueInt: pageNum, key: "pageNum");
    }
    
    
    
    
    // 新闻 和 视频 品论接口
    
    convenience init(comment: String,postId: Int,author: String,commentType: RouteCateogryType) {
        self.init();
        
        if commentType == .news {
            pathName = "slender/article/comment";
            httpMethod = .POST;
            addBody(value: author, key: "comment_author");
            addBody(value: comment, key: "comment_content");
            addBodyInt(valueInt: postId, key: "comment_postid");
            isAdduserid = true;
        }else if commentType == .video {
            pathName = "slender/learn/comment";
            httpMethod = .POST;
            isAdduserid = true;
            addBody(value: author, key: "comment_author");
            addBody(value: comment, key: "comment_content");
            addBodyInt(valueInt: postId, key: "comment_postid");
        }
        
        
    }
    
//    获取首页的指定类别的新闻列表 【完成】
    convenience init(colum id:Int?,name: String?,pageNum: Int = 1,type: RouteCateogryType = RouteCateogryType.news) {
        self.init();
        
        if type == .news {
            
            
            self.pathName = "article/list";
            if let cName = name {
                add(value: cName, key: "name")
            }
            if let cId = id {
                
//                ps：columnid=17 查询的是党建e连心的数据
                add(valueInt: cId, key: "columnid");
            }
            add(valueInt: pageNum, key: "pageNum");
            
        }
        
        
    }
    
    override init() {
        super.init();
    }

    
    // MARK:  登录有关的 接口
    
    convenience init(login account: String,passWord: String) {
        self.init();
        self.pathName = "login";
        self.httpMethod = .POST;
        add(value: account, key: "account");
        add(value: passWord, key: "password");
    }
    
    convenience init(sendCode phone: String,type: RouteCateogryType = RouteCateogryType.register) {
        self.init();
        
        if type == .register {
            pathName = "code";
            httpMethod = .POST;
            add(value: phone, key: "phone");
            add(valueInt: 1, key: "type");
            
        }else if type == .forgetPass {
            pathName = "code";
            httpMethod = .POST;
            add(value: phone, key: "phone");
            add(valueInt: 2, key: "type");
        }
        
        
        
    }
    
    convenience init(alterImage: UIImage) {
        self.init();
        pathName = "photo";
        httpMethod = .POST;
        self.isAdduserid = true;
        addBodyImageData(image: alterImage, key: "photo.png");
    }
    
    convenience init(alterPass oldpwd: String,newpwd: String) {
        self.init();
        
        pathName = "edit";
        httpMethod = .POST;
        isAdduserid = true;
        addBody(value: oldpwd, key: "oldpwd");
        addBody(value: newpwd, key: "password");
        
    }
    
    convenience init(register phone: String,code: String,pass: String,type: RouteCateogryType = RouteCateogryType.register) {
        self.init();
        if type == .register {
            pathName = "register";
            httpMethod = .POST;
            add(value: phone, key: "account");
            add(value: pass, key: "password");
            add(value: code, key: "code");
        }else if type == .forgetPass{
            pathName = "forget";
            httpMethod = .POST;
            add(value: phone, key: "account");
            add(value: pass, key: "password");
            add(value: code, key: "code");
        }
        

    }
    
    override func configParater() {
        if isAdduserid {
            addBodyInt(valueInt: UserInfoModel.getUserId(), key: "managerid"); // 用户id
        }
//        let formate = DateFormatter();
//        formate.dateFormat = "yyyyMMddHHmmss";
//        let times = formate.string(from: Date());
//
//        addBody(value: times, key: "timestamp");
//        addBody(value: RequestConfigList.getTokenValue(time: times), key: "assetionkey");

        
    }
}






class SuperHttpRequest: NSObject {
    // 文件保存路劲
    var savePath: String = ""
    // 文件名字
    var fileName: String = ""
    
    var respType = ResponseType.typeJson;
    
    var downProgress: proBlock!
    
    var startDown: startLoaing!
    
    var isAddToken = true;
    
    var cls: AnyClass!

    
    var memeryProgress: Float = 0;
    var stringURL = "";
    
    
    var httpMethod: HttpMethodType = .GET;
    var postType = PostParamterType.formdata; // 0 formdate 1 json
    enum PostParamterType {
        case json
        case formdata
    }
    
    
    var state = HttpState.ready;
    
    var parameter = [String:String]();
    var bodyParameter: [String:String]!;
    var bodyDataParamter: [String:String]!
    
    var bodyImageData: [String:UIImage]!
    
    
    var albumId: Int64 = 1;
    
    var tableName = "";
    var columnsName = "";
    
    var pathName = "";
    
   

    
   fileprivate override init() {
        super.init();
    }
    convenience init(baseUrl: String) {
        self.init();
        self.stringURL = baseUrl;
        self.fileName = baseUrl;
    
    }
    
    
    


    class func cancel(_ url: String) {
        RequestManager.cancel(url);
    }
    
    func add(value: String,key: String) {
        parameter[key] = value;
    }
    
    func add(valueInt: Int, key: String) -> Void {
        parameter[key] = "\(valueInt)";
    }
    
    func addBodyPathName(valueData: String,key: String) -> Void {
        if bodyDataParamter == nil {
            bodyDataParamter = [String:String]();
        }
        bodyDataParamter[key] = valueData;
        
    }
    
    func addBodyInt(valueInt: Int,key: String) -> Void {
        addBody(value: "\(valueInt)", key: key);
    }
    
    func addBody(value: String?,key: String) -> Void {
        if bodyParameter == nil {
            bodyParameter = [String:String]();
        }
        if let va = value{
            bodyParameter[key] = va;
        }
    }
    
    func addBodyImageData(image: UIImage?,key: String) -> Void {
        if bodyImageData == nil {
            bodyImageData = [String:UIImage]();
        }
        bodyImageData[key] = image;
    }
    
    func addBodyArray(values: [Int],key: String) -> Void {
        
        let data = try? JSONSerialization.data(withJSONObject: values, options: .prettyPrinted);
        let strl = String.init(data: data ?? Data(), encoding: .utf8);
        self.addBody(value: strl, key: key);
        
    }
    
    func configParater()  {
        
    }
    
    
    func configBody() -> Data? {
        
        guard let paraterDict = bodyParameter else {
            return nil;
        }
        
        let boundary = "--" + bodyBoundary() + "\r\n";
        
        var bodyData = Data();
        
        let boundaryData = boundary.data(using: .utf8);
        for item in paraterDict {
            bodyData.append(boundaryData!);
            
            let key = item.key;
  
            let formStrl = "Content-Disposition: form-data; name=" + "\"" + key + "\"" + "\r\n\r\n";
            bodyData.append(formStrl.data(using: .utf8)!);
            bodyData.append(item.value.data(using: .utf8)!);
            bodyData.append("\r\n".data(using: .utf8)!);
        }
        
        let boundaryEnd = "\r\n--" + bodyBoundary() + "--\r\n"
        bodyData.append(boundaryEnd.data(using: .utf8)!);
        
        return bodyData;
        
        

    }
    
    // MARK: - 配置 request 参数
    
    func getBodyDataParamter() -> Data? {
        guard let dataParater = bodyImageData else {
            return nil;
        }
        
        let boundary = "--" + bodyBoundary() + "\r\n";
        
        var bodyData = Data();
        
        let boundaryData = boundary.data(using: .utf8);
        
        if let paraterDict = bodyParameter {
            
            for item in paraterDict {
                bodyData.append(boundaryData!);
                
                let key = item.key;
                let formStrl = "Content-Disposition: form-data; name=" + "\"" + key + "\"" + "\r\n\r\n";
                bodyData.append(formStrl.data(using: .utf8)!);
                bodyData.append(item.value.data(using: .utf8)!);
                bodyData.append("\r\n".data(using: .utf8)!);
            }
        }
        
//        let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first;
        
        
        for item in dataParater {
            
            bodyData.append(boundaryData!);
            
            let contentType = "image/png";
            let name = "file";
            let fileName = item.key;
            
            let formStrl = "Content-Disposition: form-data; name=" + "\"" + name + "\"" + ";fileName=\"\(fileName)\";" + contentType + "\r\n\r\n";
            
            bodyData.append(formStrl.data(using: .utf8)!);
            
            let imageData = item.value
            let data = UIImageJPEGRepresentation(imageData, 0.8)
            bodyData.append(data!);
            
//            let imageData = "image.png";
//            bodyData.append(imageData.data(using: String.Encoding.utf8)!);
        }
        let boundaryEnd = "\r\n--" + bodyBoundary() + "--\r\n"
        bodyData.append(boundaryEnd.data(using: .utf8)!);
        return bodyData;
    }
    
    
//    func getBodyDataParamter() -> Data? {
//        guard let dataParater = bodyDataParamter else {
//            return nil;
//        }
//
//        let boundary = "--" + bodyBoundary() + "\r\n";
//
//        var bodyData = Data();
//
//        let boundaryData = boundary.data(using: .utf8);
//
//        if let paraterDict = bodyParameter {
//
//            for item in paraterDict {
//                bodyData.append(boundaryData!);
//
//                let key = item.key;
//                let formStrl = "Content-Disposition: form-data; name=" + "\"" + key + "\"" + "\r\n\r\n";
//                bodyData.append(formStrl.data(using: .utf8)!);
//                bodyData.append(item.value.data(using: .utf8)!);
//                bodyData.append("\r\n".data(using: .utf8)!);
//            }
//        }
//
//
//
//
//
//        let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first;
//
//
//        for item in dataParater {
//
//            bodyData.append(boundaryData!);
//
//            var contentType = "Content-Type= audio/mp3";
//            if item.value.lowercased().contains("png") || item.value.lowercased().contains("jpg") {
//                contentType = "image/png";
//            }
//
//            var key = item.key;
//            if key.contains("image[idex]") {
//                key = "image[]";
//            }
//
//
//            let formStrl = "Content-Disposition: form-data; name=" + "\"" + key + "\"" + ";fileName=\"\(item.value)\";" + contentType + "\r\n\r\n";
//
//            bodyData.append(formStrl.data(using: .utf8)!);
//
//            if item.value.lowercased().contains("png") || item.value.lowercased().contains("jpg") {
//
//                if let imageData = bodyImageData?[item.value] {
//
//                    let data = UIImageJPEGRepresentation(imageData, 0.8)
//                    bodyData.append(data!);
//
//                }else if let dataImage = UIImage.init(contentsOfFile: (path!.appending("/" + item.value))),
//                    let data = UIImageJPEGRepresentation(dataImage, 0.8) {
//                    bodyData.append(data);
//                }
//
//            }else {
//                let dataPath = RecorderManger.mp3Path();
//                if let data = try? Data.init(contentsOf: URL.init(fileURLWithPath: dataPath)) {
//                    bodyData.append(data);
//                }else{
//
//                    printObject("\n##########################################\n录音文件没有保存\nmp3Pah = \(dataPath)\n##########################################\n");
//                }
//            }
//        }
//        let boundaryEnd = "\r\n--" + bodyBoundary() + "--\r\n"
//        bodyData.append(boundaryEnd.data(using: .utf8)!);
//
//
//
//        return bodyData;
//    }
    
    func contentDispostion() -> String {
       return "form-data";
        
    }
    
    private func bodyBoundary() -> String {
        return "wfWiEWrgEFA9A78512weF7106A";
    }
    
    //MARK: - 创建 request
 
    func createRequest() -> URLRequest {
        
        configParater();

        
        var paterString = encode(str: baseURLAPI.appending("/\(self.pathName)"));
        if self.stringURL.hasPrefix("http") {
            paterString = self.stringURL;
        }
        
        if parameter.count > 0 {
            paterString.insert("?", at: paterString.endIndex);
        }
        
        for value in parameter {
            let valueString = encode(str: value.key) + "=" + encode(str: value.value) + "&";
            paterString = paterString.appending(valueString);
            
        }
        if parameter.count > 0 {
            
//            paterString = paterString.substring(to: paterString.index(before: paterString.endIndex));
//            paterString = String(paterString[paterString.startIndex..<paterString.index(before: paterString.endIndex)]);
            paterString = String(paterString.dropLast());
            
        }
        
        
        var request = URLRequest(url: URL(string:paterString)!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 25);
        request.httpMethod = httpMethod.rawValue;
        
        if postType == .json && bodyParameter != nil {
            
            let bodyData = try? JSONSerialization.data(withJSONObject: bodyParameter, options: .prettyPrinted);
            
            request.httpBody = bodyData;
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("\(bodyData!.count)", forHTTPHeaderField: "Content-Length")
            
        }else if let bodyData = getBodyDataParamter() {
            request.httpBody = bodyData
            
            request.setValue("multipart/form-data;boundary=" + bodyBoundary(), forHTTPHeaderField: "Content-Type");
            request.setValue("\(bodyData.count)", forHTTPHeaderField: "Content-Length")
            
        }else  if let bodyData = configBody() {
            request.httpBody = bodyData
            request.setValue("multipart/form-data;boundary=" + bodyBoundary(), forHTTPHeaderField: "Content-Type");
            request.setValue("\(bodyData.count)", forHTTPHeaderField: "Content-Length")

        }
        
        
        request.setValue("UTF-8", forHTTPHeaderField: "Accept-Charset");
        request.setValue("no-cache", forHTTPHeaderField: "Cache-Control");
        
        
        
        //        let formate = DateFormatter();
        //        formate.dateFormat = "yyyyMMddHHmmss";
        let times = Date().timestamp;//formate.string(from: Date());
        request.setValue(times, forHTTPHeaderField: RequestConfigList.timesamp);
        request.setValue(RequestConfigList.getTokenValue(time: times), forHTTPHeaderField: RequestConfigList.assetionkey);

        
        
        
        
        let infoDict = Bundle.main.infoDictionary;
        if let appVersion = infoDict?["CFBundleShortVersionString"] as? String{
            request.setValue(appVersion, forHTTPHeaderField: "version");
        }
        
        return request;
        
    }
    
    
 
//    func base64Encode(str: String) -> String {
//
//        
//        let dataString = NSString(string: str).data(using: 0, allowLossyConversion: true);
//        let sbd = Data.Base64EncodingOptions.endLineWithLineFeed.union(.lineLength64Characters).union(.endLineWithCarriageReturn)
//        let datas = dataString?.base64EncodedString(options: sbd);//NSData(data: dataString!).base64EncodedString(options: .lineLength64Characters);
//        
//        
//        return datas!
//
//    }
    
    func encode(str: String) -> String {
        let encode = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed);
        return encode!;
    }
    
//    func encodeString(str: String) -> String {
//        
//        
//       let urls = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, str as CFString, nil, "!*'();:@&=+$,/?%#[]" as CFString, CFStringBuiltInEncodings.UTF8.rawValue);
//        
//        return urls as! String;
//    }

    
    // 只从网络上获取
    //    是否强制刷新 数据json
    
    func loadJsonStringFinished(forceRefresh: Bool = true, _ finished:@escaping finishedTask){
        
        
        
        let requestURL = createRequest();
        self.fileName = (requestURL.url?.absoluteString)!;

//        !forceRefresh
        if  !forceRefresh {
            fetchMemeryData(finished);
            return;
        }
        let request = RequestOperation.createOperation(request: requestURL);

        request.parameter = parameter;
        
        request.finiTask = {
            (data,success) -> Void in
            if success {
                
                if !self.savePath.isEmpty {
//                    ReadFileManager.writeFilePath(data! as! Data, path: self.savePath);
                }else if !self.fileName.isEmpty {
//                    ReadFileManager.writeFile(data! as! Data, name: self.fileName);
                }
                let result = self.getResponsTypeData(data as? Data);

                
                finished(result, true);
            }else{
//                let result = self.getDataFromMemer();
                finished(nil,false);
//                let delegate = UIApplication.shared.delegate as? AppDelegate;
                
            }
        }
        
        RequestManager.addJsonRequest(request);
    }

    deinit {
        print("allinit =\(self)");
    }
    
    // 只从 本地获取
  
    func getDataFromMemer(exp: Bool = false) -> AnyObject? {
        
//        return nil;
        
        let fileMger = ReadFileManager(name: "audio");
        fileMger.isExpCheck = exp;
        var data = fileMger.readFileData(self.fileName);
        if data == nil {
            data = fileMger.readFileData(self.savePath);
        }
        let result = getResponsTypeData(data);
        return result;
    }

    
    
// 从内存获取 如果 当前的 数据 超过两天 就重新获取
    
    func fetchMemeryData(exp: Bool = false,_ finished: @escaping finishedTask){
        
        let requestURL = createRequest();
        self.fileName = (requestURL.url?.absoluteString)!;
        
        let result = getDataFromMemer(exp: exp);
        if result != nil {
            if Thread.current.isMainThread {
                finished(result, true);
            }else{
                DispatchQueue.main.async(execute: {
                    finished(result, true);
                })
            }
        }else{
            loadJsonStringFinished(finished);
        }
    }
     
   
    fileprivate func getDataFromTempPath() -> AnyObject? {
        if self.respType == .typeData {
            let files = ReadFileManager(name: "image", path: "path");
            let dict = files.isHasFile(self.stringURL);
            if dict.has == true {
                return files.readFileData(self.stringURL) as AnyObject?;
            }
        }
        return nil;
    }
    
    fileprivate func getResponsTypeData(_ data: Data?) -> AnyObject? {
        
        if data == nil {
            return nil;
        }
        
        var result : AnyObject? = nil;
        
        switch self.respType {
        case ResponseType.typeData:
            result = data as AnyObject?;
            break;
        case ResponseType.typeJson:
            do {
                
                if data != nil {
                    let result = NSString(data: data!, encoding: String.Encoding.utf8.rawValue);
//                    print("\n\n链接************************************************ \n\n 返回数据: \n\(result) \n \n\n************************************************ \n\n ");

                }

                
                let dict = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers);
                
                
                printObject("\n\n************************************************ \n\n 返回数据: \n\(dict) \n \n\n************************************************ \n\n ");
                
                if let clls = cls as? BaseModel.Type , let nDict = dict as? NSDictionary {
                    let model = BaseModel(anyCls: clls, dict: nDict);
                    result = model;
                }else {
                    result = dict as AnyObject?;
                    
                    if (result as? NSDictionary) != nil {
                        
                    }else{
                        print("******\n\n json error debug: \n\n\n");
                        let errorInfo = NSString(data: data!, encoding: String.Encoding.utf8.rawValue);
                        print("****************************** \n\n \(String(describing: errorInfo)) \n\n******************************")
                    }
                    
                   
                }
            }catch {
                print("******\n\n json error debug: \n\n\(error)\n\n");
                let errorInfo = NSString(data: data!, encoding: String.Encoding.utf8.rawValue);
                print("****************************** \n\n \(String(describing: errorInfo)) \n\n******************************")
            }
            break;
        case ResponseType.typeImage:
            result = UIImage(data: data!);
            break;
        case ResponseType.typeString:
            result = NSString(data: data!, encoding: String.Encoding.utf8.rawValue);
        case .typeModel:
            
            guard let dict = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary ,
                let nDict = dict else{
                return nil;
            }
            result = BaseModel(dictM: nDict);
        }
        
        return result;
    }
    
    
}



//var i = 0;

enum HttpMethodType : String{
    case GET = "GET"
    case POST = "POST"
}

class RequestOperation: Operation ,URLSessionDataDelegate{
    var savlePath: String!
    var stringURL: String!
    
    var request: URLRequest!
    
    var statusCode = 0;
    
    var progress: proBlock!
    var finiTask: finishedTask!;
    var memeryProgress: Float = 0;
    static let queue = RequestManager.shareInstance;
    
    var startDown: startLoaing!
    
//    private static var session: URLSession!
    
    private var session: URLSession!

    
    private let responseData = NSMutableData();
    
    var methodType: HttpMethodType = .GET;
    var parameter = [String:String]();
    
    var pathName = "";
    
    
    
    private var totalBytesExpectedToReceive: Int64 = 0;
    

    
    private var requestTask: URLSessionDataTask!
    
    fileprivate var _cancle = false;
    override var isCancelled: Bool {
        return _cancle;
    }
    
    fileprivate var _ready = true;
    override var isReady: Bool {

        return _ready;
    }
    
    fileprivate var _executing = false;
    override var isExecuting: Bool {
        return _executing;
    }
    
    fileprivate var _finished = false
    override var isFinished: Bool {
        return false;
    }
    
    var state = HttpState.ready;
    
    override func cancel() {
        super.cancel();
        _cancle = true;
        _finished = true;
        requestTask.cancel();

    }

    
    class func createOperation(request: URLRequest) -> RequestOperation {
        let operation = RequestOperation();
        operation.request = request;
        operation.stringURL = request.url?.absoluteString;
        return operation;
        
    }


    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        responseData.append(data);
        let totalBytesReceived = responseData.length;
        
        if self.progress != nil && !self.isCancelled{
            
            let exten = Float(Float(totalBytesReceived)/Float(totalBytesExpectedToReceive));
            DispatchQueue.main.async(execute: {
                self.memeryProgress = exten;
                self.progress(exten);
            })
            
        }
        
    }
    
//    
//    func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
//    
//        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
//            
//            let card = URLCredential(trust: challenge.protectionSpace.serverTrust!);
//            completionHandler(.useCredential,card);
//            
//        }
//    }
    

    

    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        if isCancelled {
            completionHandler(.cancel);
        }
       totalBytesExpectedToReceive = response.expectedContentLength
        completionHandler(.allow);
    }
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        self._finished = true;
        self._executing = false;
        self.state = .finshed;
        
        statusCode = (task.response as? HTTPURLResponse)?.statusCode ?? -1;
        
        DispatchQueue.main.async(execute: {
            
            

            
            if self._cancle {
                self.finiTask(self.responseData, false);
            }else{
                self.finiTask(self.responseData,error == nil);
            }
            if error != nil {
                print("\n------------------\n\t http error message:\n\n\t \(error!)\n\n--------------\n");
            }
            if self.stringURL != nil {
                RequestOperation.queue.cancel(self.stringURL);
            }
        })
    }
    
   
    
    override func main() {
//        if RequestOperation.session == nil {
//            RequestOperation.session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.current);
//        }
        
        session = URLSession(configuration: URLSessionConfiguration.ephemeral, delegate: self, delegateQueue: OperationQueue.current);
        
        
        print("===============================\n\nrquestURL: \n \(request) \n\n===============================\n\n\nrequestHeader:\n\(request.allHTTPHeaderFields!)\n\n===============================\n\nrequestMethod: \n \(request.httpMethod) \n\n===============================\n\n");
        
        if let body = request.httpBody,let bodyStr = String.init(data: body, encoding: .utf8) {
            print("body = \(bodyStr)");
        }
        
  
        
        requestTask = session.dataTask(with: request!);
        requestTask.resume();
        
        _executing = true;
        _ready = false;
        state = .execing;

        
        DispatchQueue.main.async(execute: {
        
            if self.startDown != nil {
                self.startDown();
            }
        
            UIApplication.shared.isNetworkActivityIndicatorVisible = true;
        })

   
    }
}

//MARK: - image view http request extension
//import ObjectiveC.runtime
//let image_url_key = "string_value_obj_run_time_key";


//import ObjectiveC.runtime
//var key_objc_run = "string_value_obj_run_time_key";
//extension UIMenuController {
//    
//    var textContent: String {
//        set {
//            objc_setAssociatedObject(self, &key_objc_run, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        }
//        get {
//            let value = objc_getAssociatedObject(self, &key_objc_run) as? String;
//            return (value)!;
//        }
//    }
//}


class RequestManager: OperationQueue {
    static let shareInstance = RequestManager();
    fileprivate var _operations = [RequestOperation]();
    override var operations: [Operation] {
        get {
            return _operations;
        }
    }
    
    fileprivate var dataOperations = [RequestOperation]();
    
    fileprivate override init() {
        super.init();
        self.maxConcurrentOperationCount = 3;
    }
    class func cancel(_ url: String) {
        shareInstance.cancel(url);
    }
    class func addOperationReqest(_ operation: RequestOperation){
        shareInstance.addOperationReqest(operation);
    }
    
    class func addJsonRequest(_ operation: RequestOperation){
        shareInstance.addJsonRequest(operation);
    }
    func addJsonRequest(_ operation: RequestOperation){
        objc_sync_enter(self);
        dataOperations.append(operation);
        operation.start();
        objc_sync_exit(self);
    }
    
 
    
    func cancel(_ url: String) -> Void {
        objc_sync_enter(self);
        var index = -1;
        for item in operations {
            index += 1;
            guard let temp = item as? RequestOperation else{
                continue;
            }
            if temp.stringURL == url {
                temp.cancel();
                temp.memeryProgress = 0;
                break;
            }
        }
        startRun(index);
        
        if index == -1 {
            for item in dataOperations {
                index += 1;
                if item.stringURL == url {
                    dataOperations.remove(at: index);
                    break;
                }
            }
        }
        
        RequestManager.resetIndicatorVisible();
        objc_sync_exit(self);

    }
    
    fileprivate func startRun(_ atIndex: Int){
        objc_sync_enter(self);
        if atIndex > -1 && atIndex < _operations.count {
            _operations.remove(at: atIndex);
        }
        
        if _operations.count >= self.maxConcurrentOperationCount {
            
            var index = 0;
            
            for item in _operations {
                if item.isExecuting && !item.isFinished {
                    index += 1;
                }
            }
            if index < self.maxConcurrentOperationCount {
                for item in _operations {
                    if !item.isExecuting && item.isReady && !item.isFinished {
                        if index > self.maxConcurrentOperationCount {
                            break;
                        }
                        item.start();
                        item.state = .execing;
                        index += 1;
                    }
                }
            }
        }
        objc_sync_exit(self);
    }
    
    class func resetIndicatorVisible(){
        DispatchQueue.main.async { 
            if shareInstance.operations.count == 0 {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false;
            }
        }
    }
    
    func addOperationReqest(_ operation: RequestOperation) -> Void {
        objc_sync_enter(self);
        for item in operations {
            guard let source = item as? RequestOperation else{
                continue;
            }
            if source.stringURL == operation.stringURL{
                configParate(source, des: operation);
                return;
            }
        }
        
        addOperation(operation);
        objc_sync_exit(self);
    }

    override func addOperation(_ op: Operation) {
    
        if _operations.count > 20 {
            return;
        }
    
        let temp = op as! RequestOperation;
        
        _operations.append(temp);
        if _operations.count < self.maxConcurrentOperationCount {
            temp.start();
            temp.state = .execing;
        }
    }

    func configParate(_ source: RequestOperation,des: RequestOperation)  {
        
        des.memeryProgress = source.memeryProgress;
        des.state = source.state;
        source.startDown = {
            ()->() in
            if des.startDown != nil {
                des.startDown();
            }
        }
        source.progress = {
            (pros) -> Void in
            if des.progress != nil {
                des.progress(pros);
            }
        }
        source.finiTask = {
            (data,success) -> Void in
            des.finiTask(data,success);
        }
 
    }
}
