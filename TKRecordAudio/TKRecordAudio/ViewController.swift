//
//  ViewController.swift
//  TKRecordAudio
//
//  Created by quanjunt on 2018/9/14.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    // 开始录音
    @IBAction func beginRecord(_ sender: Any) {
        TKAudioTool.shared.beginRecord(recPath: "/Users/quanjunt/Desktop/Framework/test.m4a")
    }
    
    // 结束录音
    @IBAction func endRecord(_ sender: Any) {
        TKAudioTool.shared.endRecord()
    }
    
    // 删除录音
    @IBAction func deleteRecord(_ sender: Any) {
        TKAudioTool.shared.removeRecord()
    }
    
    // 播放录音
    @IBAction func playRecord(_ sender: Any) {
        TKPlayAudio.shared.playAudio(path: "/Users/quanjunt/Desktop/Framework/test.m4a")
    }
    
    // 编辑音频
    @IBAction func editAduio(_ sender: Any) {
        
    }
}

