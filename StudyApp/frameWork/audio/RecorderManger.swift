//
//  RecorderManger.swift
//  PhoneApp
//

import UIKit
import AVFoundation


extension RecorderManger {
    class func startRecorder(filePath: String){
        mangerInstance.startRecorder(filePath: filePath);
    }
    class func startRecorder(name: String){
        mangerInstance.startRecoder(name: name);
    }
    class func stopRecorder(){
        mangerInstance.stopRecorder();
    }
    class func pauseRecorder(){
        mangerInstance.pauseRecorder();
    }
    class func deleteRecorder(){
        mangerInstance.deletingRecorder();
    }
    class func currentAudioReocorder() -> AVAudioRecorder? {
        return mangerInstance.recoder;
    }
    class func currentPath() -> URL? {
        let path = mangerInstance.recoder?.url;
        return path;
    }

    class func mp3Path() -> String {
        let cafPath = mangerInstance.audioFilePath;
        let path = AudioConverMp3.audioPCMtoMP3(cafPath);
        return path!;
    }
    
}

class RecorderManger: NSObject,AVAudioRecorderDelegate {
    
    fileprivate var recoder: AVAudioRecorder!
    fileprivate static var mangerInstance = RecorderManger();
    fileprivate var audioFilePath = "";
    
    fileprivate func startRecoder(name: String) {
        guard let rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last?.appending("/\(name)") else{
            return;
        }
        startRecorder(filePath: rootPath);
        
    }
    
    fileprivate func startRecorder(filePath: String) -> Void {
        if recoder == nil {
            setPlayAndRecord();
            audioFilePath = filePath.appending(".caf");
            let url = URL(fileURLWithPath: audioFilePath);
            printObject("audio file path: \n\(audioFilePath)");
            do {
                recoder = try AVAudioRecorder(url: url, settings: getAudioSeting());
                
//                recoder.delegate = self;
                recoder.prepareToRecord();
                let ok = recoder.record();
                
                if !ok {
                    debugPrint("recoder record is error");
                }
            } catch {
                print("init error = \(error)");
            }
            
           
        }else{
            deletingRecorder();
            recoder = nil;
            startRecorder(filePath: filePath);
        }
    }
    
    fileprivate func stopRecorder() -> Void {
        if recoder != nil && recoder.isRecording {
            recoder.stop();
        }
    }
    
    fileprivate func pauseRecorder() -> Void {
        if recoder != nil &&  recoder.isRecording {
            recoder.pause();
        }
    }
    fileprivate func deletingRecorder() -> Void {
        stopRecorder();
        if recoder != nil {
            recoder.deleteRecording();
        }
    }
    
    private func setPlayAndRecord() -> Void {
        let audioSession = AVAudioSession.sharedInstance();
        try? audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord);
        try? audioSession.setActive(true);
        
    }
    
    private func getAudioSeting() -> [String:Any] {
        let recorderSetting = NSMutableDictionary();
        recorderSetting[AVFormatIDKey] = kAudioFormatLinearPCM;
        recorderSetting[AVSampleRateKey] = 11025.0;
        recorderSetting[AVNumberOfChannelsKey] = 2;
        recorderSetting[AVLinearPCMBitDepthKey] = 16;
        return recorderSetting as! [String : Any];
    }
    
 
    
//    
//    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
//        
//        
//    }
//    
//    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
//        print("eroor =\(String(describing: error))");
//    }
}


