//
//  TKPlayAudio.swift
//  TKRecordAudio
//
//  Created by quanjunt on 2018/9/14.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

import UIKit
import AVFoundation

class TKPlayAudio: NSObject {

    /// 声音
    var volumn: Float {
        set {
            self.player.volume = volumn
        }
        get {
            return self.player.volume
        }
    }
    /// 播放进度
    var progress: Float {
        return Float(player.currentTime / player.duration)
    }
    
    /** 单例 */
    open class var shared: TKPlayAudio {
        return TKPlayAudio()
    }
    
    fileprivate var player = AVAudioPlayer()
}


// MARK: 对外暴露接口
extension TKPlayAudio {
    /** 播放音频 */
    @discardableResult func playAudio(path: String) -> AVAudioPlayer {
        var url = URL(string: path)
        if url == nil {
            let nsPath = NSString(string: path)
            url = Bundle.main.url(forResource: nsPath.lastPathComponent, withExtension: nil)
        }
        do {
            player = try AVAudioPlayer(contentsOf: url!)
        } catch {
            print("Throws：\(error)")
        }
        player.prepareToPlay()
        player.play()
        return player
    }
    
    /** 恢复当前音频 */
    func resumeCurrent() {
        player.play()
    }
    
    /** 暂停当前音频 */
    func pauseCurrent() {
        player.pause()
    }
    
    /** 停止当前音频 */
    func stopCurrent() {
        player.stop()
    }
}
