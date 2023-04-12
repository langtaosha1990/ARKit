//
//  ARView+ARData.swift
//  ARDecorate
//
//  Created by Gpf 郭 on 2022/8/9.
//

import Foundation
import RealityKit
import ARKit

var mapSaveURL: URL = {
    do {
        return try FileManager.default
            .url(for: .documentDirectory,
                 in: .userDomainMask,
                 appropriateFor: nil,
                 create: true)
            .appendingPathComponent("arworldmap.arexperience")
    } catch {
        fatalError("获取路径出错: \(error.localizedDescription)")
    }
}()

extension ARView: ARSessionDelegate {
    
    // 视频录制及推流
    public func session(_ session: ARSession, didUpdate frame: ARFrame) {
        let pixelBuffer = session.currentFrame?.capturedImage
        
    }
    
    
    
    func saveARWorldMap() {
        
        self.session.getCurrentWorldMap { worldMap, error in
            guard let map = worldMap
                else { print("当前无法获取ARWorldMap:\(error!.localizedDescription)") ; return }
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: map, requiringSecureCoding: true)
                try data.write(to: mapSaveURL, options: [.atomic])
                print("ARWorldMap保存成功")
            } catch {
                fatalError("无法保存ARWorldMap: \(error.localizedDescription)")
            }
        }
    }
    
    var mapDataFromFile: Data? {
        return try? Data(contentsOf: mapSaveURL)
    }
    
    func loadARWorldMap() -> Bool{
        let worldMap: ARWorldMap = {
            guard let data = mapDataFromFile
                else { fatalError("ARWorldMap文件不存在") }
            do {
                guard let worldMap = try NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: data)
                    else { fatalError("ARWorldMap文件格式不正确") }
                return worldMap
            } catch {
                fatalError("无法解压ARWorldMap: \(error)")
            }
        }()
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = .horizontal
        config.initialWorldMap = worldMap
        self.session.run(config)
        print("ARWorldMap加载成功")
        return true
    }
    
    
}
