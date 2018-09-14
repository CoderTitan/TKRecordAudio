//
//  TKAudioFileTool.swift
//  TKRecordAudio
//
//  Created by quanjunt on 2018/9/14.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

import UIKit
import AVFoundation

class TKAudioFileTool: NSObject {
    /** 合成音频 */
    static func appendingAudio(firstPath: String, lastPath: String, outputPath: String) {
        // 1. 获取两个音频原
        let asset1 = AVURLAsset(url: URL(fileURLWithPath: firstPath))
        let asset2 = AVURLAsset(url: URL(fileURLWithPath: lastPath))
        
        // 2. 获取两个音频元的音频轨道素材
        guard let track1 = asset1.tracks(withMediaType: .audio).first else { return }
        guard let track2 = asset2.tracks(withMediaType: .audio).first else { return }

        // 3. 创建一个合成器, 并且在合成器里面追加一个可以编辑的轨道容器
        let compostion = AVMutableComposition()
        let track = compostion.addMutableTrack(withMediaType: .audio, preferredTrackID: 0)
        
        // 4. 往轨道容器里面, 添加不同的音频轨道素材
        do {
            try track?.insertTimeRange(CMTimeRange(start: kCMTimeZero, duration: asset1.duration), of: track1, at: kCMTimeZero)
            try track?.insertTimeRange(CMTimeRange(start: kCMTimeZero, duration: asset2.duration), of: track2, at: asset1.duration)
        } catch {
            print("Thrrow: \(error)")
        }
        
        // 5. 导出音频
        let session = AVAssetExportSession(asset: compostion, presetName: AVAssetExportPresetAppleM4A)
        session?.outputFileType = AVFileType.m4a
        session?.outputURL = URL(fileURLWithPath: outputPath)
        session?.exportAsynchronously {
            let status = session?.status ?? .unknown
            switch status {
            case .waiting:
                print("正在等待导出...")
            case .exporting:
                print("正在导出...")
            case .completed:
                print("导出成功!")
            case .failed:
                print("导出失败")
            case .cancelled:
                print("取消操作")
            default:
                print("操作异常")
            }
        }
    }
    
    /** 剪切音频 */
    static func componentAudio(audioPath: String, fromTime: TimeInterval, toTime: TimeInterval, outputPath: String) {
        // 1. 获取音频源
        let asset = AVURLAsset(url: URL(fileURLWithPath: audioPath))
        
        // 2. 创建一个音频会话, 并且,设置相应的配置
        let session = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A)
        session?.outputFileType = AVFileType.m4a
        session?.outputURL = URL(fileURLWithPath: outputPath)
        
        let startTime = CMTime(value: CMTimeValue(fromTime), timescale: 1)
        let endTime = CMTime(value: CMTimeValue(toTime), timescale: 1)
        session?.timeRange = CMTimeRange(start: startTime, end: endTime)
        
        // 3. 导出
        session?.exportAsynchronously {
            let status = session?.status ?? .unknown
            switch status {
            case .waiting:
                print("正在等待导出...")
            case .exporting:
                print("正在导出...")
            case .completed:
                print("导出成功!")
            case .failed:
                print("导出失败")
            case .cancelled:
                print("取消操作")
            default:
                print("操作异常")
            }
        }
    }
}
