//
//  FlySpeechManager.swift
//  StudyApp
//
//  Created by yaojinhai on 2017/9/15.
//  Copyright © 2017年 yaojinhai. All rights reserved.
//

import UIKit

class FlySpeechManager: NSObject,IFlySpeechRecognizerDelegate,IFlyPcmRecorderDelegate {
    
    
    private let flySpeechRecognizer = IFlySpeechRecognizer.sharedInstance();
    private var finishedBlock: ((String,Bool) -> Void)!;
    
//    private let pcmRecorder = IFlyPcmRecorder.sharedInstance();
    static let flySpeechManger = FlySpeechManager();
    
    static var listeningResultStrl  = "";
    
    private override init() {
        super.init();
        flySpeechRecognizer?.setParameter("", forKey: IFlySpeechConstant.params());
        flySpeechRecognizer?.setParameter("iat", forKey: IFlySpeechConstant.ifly_DOMAIN());
        flySpeechRecognizer?.delegate = self;
        flySpeechRecognizer?.setParameter("json", forKey: IFlySpeechConstant.result_TYPE());

        
        let instance = IATConfig.sharedInstance();
        
        flySpeechRecognizer?.setParameter(instance?.speechTimeout, forKey: IFlySpeechConstant.speech_TIMEOUT());
        flySpeechRecognizer?.setParameter(instance?.vadEos, forKey: IFlySpeechConstant.vad_EOS());
        flySpeechRecognizer?.setParameter(instance?.vadBos, forKey: IFlySpeechConstant.vad_BOS());
        flySpeechRecognizer?.setParameter("20000", forKey: IFlySpeechConstant.net_TIMEOUT());
        flySpeechRecognizer?.setParameter(instance?.sampleRate, forKey: IFlySpeechConstant.sample_RATE_16K());
        flySpeechRecognizer?.setParameter("en_us", forKey: IFlySpeechConstant.language());
        flySpeechRecognizer?.setParameter(instance?.dot, forKey: IFlySpeechConstant.asr_PTT());
        flySpeechRecognizer?.setParameter("1", forKey: "audio_source");

    }
    
    func cancelSpeech() -> Void {
        flySpeechRecognizer?.cancel();
    }
    class func stopListening() -> Void {
        flySpeechManger.flySpeechRecognizer?.stopListening();
    }
    
    class func isListening() -> Bool {
        return flySpeechManger.flySpeechRecognizer?.isListening ?? false;
    }
    
    class func beginRecoder(name: String,block: @escaping ((String,Bool) -> Void)) -> Void {
        flySpeechManger.finishedBlock = block;
        flySpeechManger.flySpeechRecognizer?.cancel();
//        asr.pcm
        flySpeechManger.flySpeechRecognizer?.setParameter("asr.pcm", forKey: IFlySpeechConstant.asr_AUDIO_PATH());
        
   
       let ret = flySpeechManger.flySpeechRecognizer?.startListening() ?? false;
        
        if ret {
            printObject("开始监听");
        }else {
            printObject("启动服务器失败");
        }
        
    }
    
    class func checkRecorderPermission() -> Void {
        if AVAudioSession.sharedInstance().recordPermission() != .granted{
            
            AVAudioSession.sharedInstance().requestRecordPermission { (finished) in
                
            };
        }
        
    }

//     MARK: - IFlyDataUploaderDelegate
    func onIFlyRecorderError(_ recoder: IFlyPcmRecorder!, theError error: Int32) {
        
        printObject("their ######## \(error)");
    }
    func onIFlyRecorderBuffer(_ buffer: UnsafeRawPointer!, bufferSize size: Int32) {
        
        

        
        let data = Data.init(bytes: buffer, count: Int(size));
        
        let ret = flySpeechRecognizer?.writeAudio(data) ?? false;
        if !ret {
            flySpeechRecognizer?.stopListening();
            
        }
        
        printObject("onIFlyRecorderBuffer ret = \(ret)");

        
    }
    
    
    
    // MARK: - IFlyPcmRecorderDelegate
    func onError(_ errorCode: IFlySpeechError!) {
        
        if errorCode.errorCode == 0 {
            finishedBlock("",true);
        }else{
            finishedBlock(errorCode.errorDesc,false);
        }

    }
    
    func onBeginOfSpeech() {
        printObject("开始录音onBeginOfSpeech");
    }
    func onResults(_ results: [Any]!, isLast: Bool) {
        
        printObject("onResults  11111");

        
        guard let dict = results?.first as? NSDictionary else {
            return;
        }
        
        var resultString = "";
        for key in dict {
            resultString.append("\(key.key)");
        }
        
        if let resultFormJson = ISRDataHelper.string(fromJson: resultString),resultFormJson.count > 1 {
            
            FlySpeechManager.listeningResultStrl = resultFormJson;
        }else{
//            FlySpeechManager.listeningResultStrl = "无法识别录音";
        }
        

        
    }
    func onEndOfSpeech() {
        
        finishedBlock("",true);
        
        printObject("onEndOfSpeech");
        
    }
}








