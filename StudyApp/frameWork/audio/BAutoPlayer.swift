//
//  BAutoPlayer.swift
//  CathAssist
//


import UIKit
import Foundation
import AVFoundation
import CoreMedia
import MediaPlayer


let playProgress = "player_progress"
let playError = "play_error"
let playStop = "play_stop"
let playPause = "play_pause"
let playStart = "play_start"
let playLoadRange = "loaded_time_ranges"
let playReadStart = "play_read_start";


enum PlayerModel : Int{
    case repeatOne = 0 // 单曲播放
    case repeatOneForever // 单曲循环
    case randomAll // 随机播放
    case repeatList // 列表循环
    
    
    static func getPlayModel(_ next : Bool = false) -> String{
        let array = PMType.repeatModelArray;
        let index = PMType.selectedModel + (next ? 1 : 0);
        let cdix = (index > (array?.count)! - 1) ? 0 : index;
        PMType.selectedModel = cdix;
        return array![PMType.selectedModel] as! String;
    }
    
    static func repeatMusicModel() -> PlayerModel {
        return PlayerModel(rawValue:PMType.selectedModel)!;
    }
    static func saveModel() -> Void {
        UserDefaults.standard.set(PMType.selectedModel, forKey:PMType.PlayerModelKey);
    }
    
}




struct PMType {
    
    static let repeatModelArray = NSArray(contentsOfFile: Bundle.main.path(forResource: "MusicPlayModel", ofType: "plist")!);
    static let PlayerModelKey = "player_model_key";
    static var selectedModel = UserDefaults.standard.integer(forKey: PMType.PlayerModelKey);
    
}


class BAutoPlayer: NSObject ,AVAudioPlayerDelegate{

    
    
    fileprivate var songPlayer : AVPlayer!
    
    fileprivate var observePlayer: AnyObject!
    
    fileprivate var assetDuration: Float64 = 1;
    
    
    fileprivate static let playerInstance = BAutoPlayer();
    
    fileprivate var currentModel : MusicSong?
    
    static var currentPlayerURL = "";
    

    static var memeryProgress : Float = 0;
    
    static var isUpdateProgress = false;
    
    fileprivate var songItem: JHPlayerItem!
    
    var musickSongsArray : Array<MusicSong> = [];
    fileprivate var currentPlayIndex : Int = 0;
    
    fileprivate var preIndex = -1;

    fileprivate var playRate : Float{
        didSet{
            if songPlayer != nil {
                songPlayer.rate = playRate
            }
        }
    }
    
    // MARK: -
    // FIXME: private init()
    
    
    fileprivate var isPushLoadRangeTime = true;
    
    fileprivate var sessionPlaying = false;
    
    fileprivate override init() {
        self.playRate = 1
        super.init();
        NotificationCenter.default.addObserver(self, selector: #selector(BAutoPlayer.playerItemDidEnd(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(interrpution(_:)), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil);
        
        updateSession();
        
    }

    fileprivate func updateSession() {
    
        let session = AVAudioSession.sharedInstance();
        do {
            try session.setActive(true);
            try session.setCategory(AVAudioSessionCategoryPlayback, with: AVAudioSessionCategoryOptions.defaultToSpeaker);
            
        }catch{
            
        }
    }
    
    
    @objc func playerItemDidEnd(_ notifi : Notification){
        let b = playNextItem();
        if b == false {
            stopUrlPlayer();
        }
        
    }
    
    /// 是否正在播放
    
    class func isPlaying() -> Bool {
        return playerInstance.songPlayer != nil && playerInstance.songPlayer.rate > 0;
    }
    
    class func autoPlayOrStop(){
        if isPlaying() {
            stopPlaying();
        }else{
            playerCurrentFile();
        }
    }
    
    
    //  设置 当前 的进度
    class func setCurrentProgress(_ value : Float){
        playerInstance.setCurrentProgress(value);
    }
    
    
    // MARK: - 播放 当前已经 暂停 的音乐
    
    class func playerCurrentFile(){
        playerInstance.playerCurrentFile();
    }
    
    class func playPreItem(){
        playerInstance.playPreItem();
    }
    
    
    class func playNextItem(){
        playerInstance.playNextItem();
        
    }
    
    class func getRate() -> Int{
        let addRate = Int((playerInstance.playRate-1)*10 + 0.5)
        return Int(addRate/3)
    }
    
    class func playFaster()->Int{
        let nextRate = playerInstance.songPlayer.rate+0.3
        
        let addRate = Int((nextRate-1)*10 + 0.5)
        var result = Int(addRate/3)
        if result <= 5 {
            playerInstance.playRate = nextRate
        }
        else{
            playerInstance.playRate = 1
            result = 0
        }
        
        return result
    }
    class func playSlower(){
        playerInstance.songPlayer.rate -= 0.3
    }
    class func playOrigin(){
        playerInstance.songPlayer.rate = 1
    }
    
    
    
    func playMusicAtIndex(_ index : Int) {
        
        if musickSongsArray.count > index && index > -1 {
            currentPlayIndex = index;
            playerMusicItem(musickSongsArray[index]);
        }
    }
    
    
    class func getCurrentMusicArray() -> Array<MusicSong> {
        return BAutoPlayer.playerInstance.musickSongsArray;
    }
    class func getCurrentMusic() -> MusicSong? {
        return playerInstance.currentModel;
    }
    

    class func getCurrentIndex() -> Int{
    
        if playerInstance.currentModel != nil {
            if let modelIndex = playerInstance.musickSongsArray.index(of: playerInstance.currentModel!) {
                playerInstance.currentPlayIndex = modelIndex;
                return modelIndex;
            }
        }
    
        if playerInstance.currentPlayIndex >= playerInstance.musickSongsArray.count {
            playerInstance.currentPlayIndex = playerInstance.musickSongsArray.count - 1;
        }else if playerInstance.currentPlayIndex < 0 {
            playerInstance.currentPlayIndex = 0;
        }
        return playerInstance.currentPlayIndex;
    }
    
   
    // MARK:
    // TODO: 自动播放一个音乐列表 musics
    
    
    class func playerMusicSongsArray(_ songs : Array<MusicSong>,atIndex : Int, isAutoPlay : Bool = true) -> Void {
        
        if atIndex >= songs.count {
            return;
        }
        if songs.count < 21 {
            playerInstance.musickSongsArray = songs;
            playerItemIndex(atIndex);
        }else {
            let exeten = songs.count - atIndex ;
            if exeten > 20 {
            
                let subRange = songs[atIndex...(20 + atIndex)];
                playerInstance.musickSongsArray = subRange.reversed().reversed();
                playerItemIndex(0);
            }else{
                let subRange = songs[(songs.count - 20)...songs.count - 1];
                playerInstance.musickSongsArray = subRange.reversed().reversed();
                playerItemIndex(20 - exeten);
            }
        }
    }

    
    class func playerItemIndex(_ index : Int){
        if index > -1 && playerInstance.musickSongsArray.count > index  {
        
            playerInstance.currentPlayIndex = index;
            playerInstance.playerMusicItem(playerInstance.musickSongsArray[index]);
        }
        
    }
    
    

    
    func convertTime(_ timeString : String) -> String {
        let timeNS = timeString as NSString
        let time = timeNS.floatValue;
        let min = Int(time / 60);
        let second = Int(time.truncatingRemainder(dividingBy: 60));
        let stringTimes = min > 9 ? "\(min)" : "0\(min)";
        let secondString = second > 9 ? "\(second)" : "0\(second)"
        
        return "\(stringTimes):\(secondString)";
    }
    
    
    class func stopPlaying(){
        playerInstance.stopUrlPlayer();
    }
    
    
}




class MusicSong : NSObject{
    
    
    

    
    func isHaveLocationSong() -> (path : String,isHave : Bool) {
 
        return ("",true);
    }
    
    
   static func createBibleUrl(_ chapterIndex : Int,subchapterIndex : Int) -> String{
    
        return "";
    }

}


// MARK: -- 播放私有方法

extension BAutoPlayer {
    
    // MARK: - 设置进度
    fileprivate func setCurrentProgress(_ value : Float){
        

        let time = Float(assetDuration) * value;
        let drageTime = CMTimeMake(Int64(time), 1);
        songPlayer.seek(to: drageTime, completionHandler: { (finished) in
            BAutoPlayer.isUpdateProgress = false;
            self.updateInfo();
        })
        
        
    }
    
    // MARK: -
    // TODO:  停止 网络的
   fileprivate func stopUrlPlayer(){
    sessionPlaying = false;
        if songPlayer != nil && songPlayer.rate > 0 {
            songPlayer.pause();
            
        }
    NotificationCenter.default.post(name: Notification.Name(rawValue: playPause), object: nil, userInfo: nil);
        
    }
    
    // MARK: -
    // TODO: 播放下一个
    @discardableResult
   fileprivate func playNextItem() -> Bool{
//        currentPlayIndex += 1;
    playModel(true);
        var b = true;
        if currentPlayIndex < musickSongsArray.count {
            playMusicAtIndex(currentPlayIndex);
            
        }else{
            b = false;
        }
        return b;
    }
    
    // MARK: -
    // TODO: 播放上一个
    
   fileprivate func playPreItem(){
//        currentPlayIndex -= 1;
    playModel(false);
        if currentPlayIndex > -1 && musickSongsArray.count > currentPlayIndex {
            playMusicAtIndex(currentPlayIndex);
        }
    }
    
    // MAEK: - 播放模式
    
    fileprivate func playModel(_ next : Bool){
        
        let playModel = PlayerModel.repeatMusicModel();
        
        if currentPlayIndex != -10 {
            preIndex = currentPlayIndex;
        }else{
            currentPlayIndex = preIndex;
        }
        
        switch playModel {
        case PlayerModel.randomAll: // 随机播放
            if musickSongsArray.count > 0  {
                currentPlayIndex = Int(arc4random()) % musickSongsArray.count;
            }
            break
        case PlayerModel.repeatOne: // 单曲播放
            
            currentPlayIndex = -10;
            break
        case PlayerModel.repeatOneForever: // 单曲循环
            //            currentIndex = preIndex;
            break
        case PlayerModel.repeatList: // 列表播放
            
            currentPlayIndex = currentPlayIndex + (next ? 1 : -1);
            
//            if currentPlayIndex >= musickSongsArray.count {
//                currentPlayIndex = 0;
//            }else if currentPlayIndex < 0 {
//                if musickSongsArray.count > 0 {
//                    currentPlayIndex = musickSongsArray.count - 1;
//                }
//            }
            
        }
        
    }
    
    // MARK: 继续播放
    
   fileprivate func playerCurrentFile(){
    
    sessionPlaying = true;
    
    BAutoPlayer.isUpdateProgress = false;

        if songPlayer?.currentItem != nil {
        
            
            
            let current = CMTimeGetSeconds((songPlayer.currentItem?.currentTime())!)
            
            if assetDuration <= current {
                playNextItem();

            }else{
                songPlayer.play();
                if observePlayer != nil {
                    songPlayer.removeTimeObserver(observePlayer);
                }
                observePlayer =  songPlayer.addPeriodicTimeObserver(forInterval: CMTimeMake(60, 30), queue: nil, using: {
                    (times) in
                    BAutoPlayer.playerInstance.updateProgress(times);
                    
                }) as AnyObject!
                postPalyingNoti();
            }
            
        }
    }
    
    // MARK: -
    // TODO:  播放一个 音频对象
   fileprivate func playerMusicItem(_ oneSongs : MusicSong) -> Void {
        
        
        var songUrls = "";
        
        if oneSongs.isHaveLocationSong().isHave {
            songUrls = oneSongs.isHaveLocationSong().path;
        }else{
        
           
            
        }
        currentModel = oneSongs;
        playerBibleWithURL(songUrls);
    }
    
    // MARK: -
    // TODO:  播放一个地址
    
    // 测试用的
    
    class func playingURL(url: URL){
        playerInstance.playerBibleWithURL(url: url);
    }
    class func playerURL(_ url: String){
        BAutoPlayer.currentPlayerURL = url;
        playerInstance.playerBibleWithURL(url);
    }
    fileprivate func playerBibleWithURL(url: URL){
        
        resetPlayer();

        
        let playerItem = getPlayerItem(url: url);
        
        songPlayer = AVPlayer(playerItem: playerItem);
        songPlayer.addObserver(self, forKeyPath: "rate", options: NSKeyValueObservingOptions.new, context: nil);
        observePlayer = songPlayer.addPeriodicTimeObserver(forInterval: CMTimeMake(1, 1), queue: nil, using: {
            (times) in
            BAutoPlayer.playerInstance.updateProgress(times);
        }) as AnyObject!
        
        if #available(iOS 10.0, *) {
            songPlayer.automaticallyWaitsToMinimizeStalling = false
        } else {
            // Fallback on earlier versions
        };
        //        automaticallyWaitsToMinimizeStalling
        sessionPlaying = true;
        
        songPlayer.play();
        songPlayer.rate = self.playRate
    }
    fileprivate func playerBibleWithURL(_ urlString : String){
        
        resetPlayer();
        
        let playerItem = getPlayerItem(urlString);
        
        songPlayer = AVPlayer(playerItem: playerItem);
        songPlayer.addObserver(self, forKeyPath: "rate", options: NSKeyValueObservingOptions.new, context: nil);
        observePlayer = songPlayer.addPeriodicTimeObserver(forInterval: CMTimeMake(1, 1), queue: DispatchQueue.main, using: {
            (times) in
            BAutoPlayer.playerInstance.updateProgress(times);
        }) as AnyObject!
        
        if #available(iOS 10.0, *) {
            songPlayer.automaticallyWaitsToMinimizeStalling = false
        } else {
            // Fallback on earlier versions
        };
        //        automaticallyWaitsToMinimizeStalling
        sessionPlaying = true;
        
        songPlayer.play();
        songPlayer.rate = self.playRate
        
        
        
//

    }
    
    func getPlayerItem(_ urlString: String) -> AVPlayerItem {
    
        let playerItem: JHPlayerItem!
        

        
        if urlString.hasPrefix("http") {
        
            let url = URL(string: urlString)!;
            UIApplication.shared.isNetworkActivityIndicatorVisible = true;
            isPushLoadRangeTime = true;
            
            let asset = AVURLAsset(url: url);
            playerItem = JHPlayerItem(asset: asset);
        }else {
            isPushLoadRangeTime = false;
            let url = URL(fileURLWithPath: urlString);
            playerItem = JHPlayerItem(url: url);
        }
        playerItem.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil);
        songItem = nil;
        songItem = playerItem;
        return playerItem;
    }
    
    func getPlayerItem(url: URL) -> AVPlayerItem {
        
        let playerItem = JHPlayerItem(url: url);
        playerItem.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil);
        songItem = nil;
        songItem = playerItem;
        return playerItem;
    }
    
    
    
    fileprivate func resetPlayer() {
        if songPlayer != nil {
            songPlayer.removeObserver(self, forKeyPath: "rate", context: nil);
            songPlayer.removeTimeObserver(observePlayer);
            songPlayer.pause();
            songPlayer.replaceCurrentItem(with: nil);
            songPlayer = nil;
        }
        
    }
    
    // MARK: - 当前进度通知
    fileprivate func updateProgress(_ times : CMTime){

        let progress = CMTimeGetSeconds(times);


        var dict = [String:Any]();

        let perPro = Float(progress) / Float(assetDuration);
        
        let currentTime = "\(progress)"
        
        dict[playProgress] = NSNumber(value: perPro as Float);
        dict["longTime"] = convertTime("\(assetDuration)");
        dict["currentTime"] = convertTime(currentTime);
        
        BAutoPlayer.memeryProgress = perPro;
        NotificationCenter.default.post(name: Notification.Name(rawValue: playProgress), object: nil, userInfo: dict);
        

    }
    
    
    // MARK: 更新信息
    fileprivate func updateInfo() {
        
        updateImage(UIImage(named: "Default-568h@2x-1.png"));
        
        if currentModel != nil {
            
//            UserRequest.imagePath(currentModel!.getImageUrl(), finished: { [weak self] (success, result) in
//                if success == true {
//                    self?.updateImage(result);
//                }
//                
//            })
        }
        
    }
    
    fileprivate func postPalyingNoti(){
    
    
        NotificationCenter.default.post(name: Notification.Name(rawValue: playStart), object: nil, userInfo: ["time":convertTime("\(assetDuration)"),"longTime":assetDuration]);
        
        updateInfo();
        
        
        
    }
    
   fileprivate func updateImage(_ image: UIImage?) {
    
    
//        var mediaInfo = [String:AnyObject]();
//        mediaInfo[MPMediaItemPropertyTitle] = currentModel?.title as AnyObject?;
//        mediaInfo[MPMediaItemPropertyArtist] = currentModel?.artist as AnyObject?;
//        if image != nil {
//            let artWork = MPMediaItemArtwork(image: image!);
//            mediaInfo[MPMediaItemPropertyArtwork] = artWork;
//        }
//        
//        
//        mediaInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = NSNumber(value: CMTimeGetSeconds((songPlayer.currentItem?.currentTime())!) as Double);
//        
//        mediaInfo[MPMediaItemPropertyPlaybackDuration] = NSNumber(value: assetDuration as Double);
//        mediaInfo[MPMediaItemPropertyAlbumTitle] = currentModel?.album as AnyObject?;
//        
//        MPNowPlayingInfoCenter.default().nowPlayingInfo = mediaInfo;
    
    }
    
    
    // MARK: - observe audio session change
    
    @objc func interrpution(_ noti : Notification) {
    
        if noti.name.rawValue == NSNotification.Name.UIApplicationDidEnterBackground.rawValue {
            updateSession();
            return;
        }
        
        guard let userInfo = noti.userInfo else {
            return;
        }
        
        
        if noti.name.rawValue == NSNotification.Name.AVAudioSessionInterruption.rawValue {
            
            if let interType = userInfo[AVAudioSessionInterruptionTypeKey] as? AVAudioSessionInterruptionType {
                if interType == .began {
                    if sessionPlaying {
                        stopUrlPlayer();
                        sessionPlaying = true;
                    }
                    
                }else if interType == .ended {
                    if sessionPlaying {
                        playerCurrentFile();
                    }
                }
            }
            else if let options = userInfo[AVAudioSessionInterruptionOptionKey] as? AVAudioSessionInterruptionOptions {
                if options == .shouldResume && sessionPlaying{
                    playerCurrentFile();
                }
            }
        }
        
        
    }
    
    // 观察
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        
        if let pItem = object as? AVPlayerItem {
            
            
            if keyPath == "status"{
                
                
                print("error = %@",pItem.status.rawValue);
                print("error s = \(pItem.error)");
                
                if pItem.status == .readyToPlay {
//
                    assetDuration = CMTimeGetSeconds((songPlayer.currentItem?.asset.duration)!);
                    postPalyingNoti();
                    
                }else if pItem.error != nil{
                    
//                    printObject("\(pItem.error)")
//
//                    
//                    currentModel?.clearErrorFile();
                    
                }
                
                
            }
            
            if keyPath == "loadedTimeRanges"{
            
                
//                if !isPushLoadRangeTime {
//                    return;
//                }
                
                
                
//                let timeArray = change!["new"] as! NSArray;
//                let value = timeArray[0] as? NSValue;
//                let rangeTime = value?.CMTimeRangeValue;
//                
//                let result = CMTimeGetSeconds((rangeTime?.start)!) + CMTimeGetSeconds((rangeTime?.duration)!);
//                
//                
//                let currentProgress = Float(Float(result) / Float(assetDuration));
//                
//                print("result = \(timeArray),assetDuration = \(assetDuration)");
//
//                
//                print("currentProgress = \(currentProgress)");
//                
//                if currentProgress * 100 >= 100{
//                
//                    isPushLoadRangeTime = false;
//                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false;
//                    NSNotificationCenter.defaultCenter().postNotificationName(playLoadRange, object: nil, userInfo: ["progress":NSNumber(float:1)])
//
//                }else{
//                    NSNotificationCenter.defaultCenter().postNotificationName(playLoadRange, object: nil, userInfo: ["progress":NSNumber(float:currentProgress)])
//
//                }
                
            }
        }else if keyPath == "rate" && object is AVPlayer {
           
            
            if let changeKindValue = change?[.newKey] as? UInt {
                if changeKindValue == 0 {
                    stopUrlPlayer();
                }
            }

        }
        
    }
    
    func exdata(_ assit:AVURLAsset)  {
    
        let tracks = assit.tracks(withMediaType: AVMediaType.audio).first;
        if tracks == nil {
            return;
        }
        
        let mixComposition = AVMutableComposition()
        let audio = mixComposition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: kCMPersistentTrackID_Invalid)
        
        do {
            
            try audio?.insertTimeRange(CMTimeRangeMake(kCMTimeZero, assit.duration), of: tracks!, at: kCMTimeZero);

        }catch {
            
        }
        
        let exporter = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality);
        let stringPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last;
        let rootPath = (stringPath)! + "/abc";
        
        
        exporter?.outputURL = URL(fileURLWithPath: rootPath);
        
        
        if exporter?.supportedFileTypes != nil {

            exporter?.outputFileType = exporter?.supportedFileTypes.first;
            exporter?.shouldOptimizeForNetworkUse = true;
            exporter?.exportAsynchronously(completionHandler: {
            

            });
        }
        
    }
}


import MobileCoreServices
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}



class JHPlayerItem: AVPlayerItem {
    deinit {
        removeObserver(BAutoPlayer.playerInstance, forKeyPath: "status", context: nil);

    }
    
}







