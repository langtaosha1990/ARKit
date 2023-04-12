//
//  VideoPlayController.swift
//  Chapter
//
//  Created by Gpf 郭 on 2022/6/30.
//

import Foundation
import AVFoundation
import RealityKit
import UIKit

public class VideoPlayController {
    
    private var playing = false
    private var avPlayer: AVPlayer?
    private var avPlayerItem: AVPlayerItem?
    private var avPlayerLooper: AVPlayerLooper?
    private var videoMaterial: VideoMaterial?
    public var material: Material? { videoMaterial }
    
    private func createAVPlayer(_ named: String, withExtension ext: String) -> AVPlayer? {
        guard let url = Bundle.main.url(forResource: named, withExtension: ext) else {
            return nil
        }
        
        /**
         * 苹果拉流地址：http://devimages.apple.com.edgekey.net/streaming/examples/bipbop_4x3/bipbop_4x3_variant.m3u8
         *  MP4地址：http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4       //网络mp4
         */
//        URL(string: "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")!
        let avPlayer = AVPlayer(url: url)
        return avPlayer
    }
    
    private func createVideoPlayerItem(_ named: String, withExtension ext: String) -> AVPlayerItem? {
        guard let url = Bundle.main.url(forResource: named, withExtension: ext) else {
            return nil
        }
        
        let avPlayerItem = AVPlayerItem(asset: AVAsset(url: url))
        return avPlayerItem
    }
    
    init?(_ named: String, withExtension ext: String, useLooper: Bool = false) {
        playing = false
        let player: AVPlayer?
        
        if useLooper {
            let playerItem = createVideoPlayerItem(named, withExtension: ext)
            guard let avPlayerItem = playerItem else { return nil }
            let queuePlayer = AVQueuePlayer()
            avPlayerLooper = AVPlayerLooper(player: queuePlayer, templateItem: avPlayerItem)
            self.avPlayerItem = avPlayerItem
            player = queuePlayer
        } else {
            player = createAVPlayer(named, withExtension: ext)
        }
        avPlayer = player
        guard let avPlayer = player else { return nil }
        avPlayer.actionAtItemEnd = .pause
        avPlayer.pause()
        
        videoMaterial = VideoMaterial(avPlayer: avPlayer)
        videoMaterial?.controller.audioInputMode = .spatial
        
        NotificationCenter.default.addObserver(self, selector: #selector(VideoDidReachEndNotificationHandler(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: avPlayer.currentItem)
        
    }
    
    public func reset() {
        guard let avPlayer = self.avPlayer else { return }
        avPlayer.pause()
        avPlayer.seek(to: .zero)
        playing = false
    }
    
    public func sceneUpdate() {
        guard playing, let avPlayer = avPlayer else { return }
        if avPlayer.timeControlStatus == .paused {
            avPlayer.seek(to: .zero)
            avPlayer.play()
        }
    }
    
    public func enablePlayPause(_ enable: Bool) {
        playing = enable
        guard let avPlayer = self.avPlayer else { return }
        if playing, avPlayer.timeControlStatus == .paused {
            avPlayer.play()
        } else if !playing, avPlayer.timeControlStatus != .paused {
            avPlayer.pause()
        }
    }
    
    @objc func VideoDidReachEndNotificationHandler(_ notification:NSNotification){
        print("播放完了")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
    
    



