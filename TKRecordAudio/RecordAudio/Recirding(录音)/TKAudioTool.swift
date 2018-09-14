//
//  TKAudioTool.swift
//  TKRecordAudio
//
//  Created by quanjunt on 2018/9/14.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

import UIKit
import AVFoundation


typealias successBlock = (_ ret: Bool) -> Void

class TKAudioTool: NSObject {

    /// 录音文件路径
    var recordPath = ""
    
    /// 回调
    fileprivate var successBlock: successBlock?
    fileprivate lazy var audioRecorder = { () -> AVAudioRecorder? in
        do {
            // 0. 设置绘画录音
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Throws：\(error)")
        }
        
        // 1. 确定录音存放位置
        guard let url = URL(string: recordPath) else { return nil }
        
        // 2. 设置录音参数
        var settingDic = [String: Any]()
        
        // 设置编码格式
        settingDic[AVFormatIDKey] = kAudioFormatMPEG4AAC
        // 采样率
        settingDic[AVSampleRateKey] = NSNumber(value: 11025.0)
        // 通道数
        settingDic[AVNumberOfChannelsKey] = NSNumber(value: 2)
        // 音频质量采样质量
        settingDic[AVEncoderAudioQualityKey] = NSNumber(value: AVAudioQuality.min.rawValue)
        
        // 3. 创建录音对象
        do {
            let audioRecord = try AVAudioRecorder(url: url, settings: settingDic)
            // 是否启用音频测量, 以便及时获取音频分贝等信息
            audioRecord.isMeteringEnabled = true
            return audioRecord
        } catch {
            print("Throws：\(error)")
            return nil
        }
    }()
    
    
    /** 单例 */
    open class var shared: TKAudioTool {
        return TKAudioTool()
    }
}

// MARK: 对外暴露接口
extension TKAudioTool {
    /** 开始录音 */
    func beginRecord(recPath: String) {
        self.recordPath = recPath
        self.audioRecorder?.prepareToRecord()
        self.audioRecorder?.record()
    }
    
    /** 结束录音 */
    func endRecord() {
        self.audioRecorder?.stop()
    }
    
    /** 暂停录音 */
    func pauseRecord() {
        self.audioRecorder?.pause()
    }
    
    /** 删除录音 */
    func removeRecord() {
        self.audioRecorder?.stop()
        self.audioRecorder?.deleteRecording()
    }
    
    /** 重新录音 */
    func againRecord() {
        self.audioRecorder = nil
        beginRecord(recPath: recordPath)
    }

    /** 更新音频测量值 */
    func updateMeters() {
        self.audioRecorder?.updateMeters()
    }
    
    /** 获得指定声道的分贝峰值 */
    func peakPowerForChannel0() -> Float {
        // 注意如果要获得分贝峰值必须在此之前调用updateMeters方法
        updateMeters()
        return self.audioRecorder!.peakPower(forChannel: 0)
    }
}
