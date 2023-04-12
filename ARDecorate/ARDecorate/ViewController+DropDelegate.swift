//
//  ViewController+DropDelegate.swift
//  ARDecorate
//
//  Created by Gpf 郭 on 2022/8/7.
//

import UIKit
import RealityKit
import ARKit
import MobileCoreServices
import Combine

extension ViewController: UIDropInteractionDelegate {
    
    // 拖拽移动的过程中触发
    func dropInteraction(_ interaction: UIDropInteraction,
        sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        raycastResult = nil
        let location = session.location(in: arView)
        guard let result = self.arView.raycast(from: location, allowing: .estimatedPlane, alignment: .horizontal).first else {
            return UIDropProposal(operation: .copy)
        }
        raycastResult = result
        return UIDropProposal(operation: .copy)
    }
    
    // 释放拖拽时触发
    func dropInteraction(_ interaction: UIDropInteraction,
                         performDrop session: UIDropSession) {

        if session.hasItemsConforming(toTypeIdentifiers: [kUTTypePlainText as String]) {
            session.loadObjects(ofClass: NSString.self) {
                guard let entityName = $0.first as? NSString else { return }
                guard let anchor = self.loadEntity(name: entityName as String) else {
                    return
                }
                
                self.arView.session.add(anchor:anchor)
            }
        }
    }
    
    @available(iOS 15.0, *)
    func loadEntity(name: String) -> ARAnchor? {
        guard let raycastResult = self.raycastResult else {
            return nil
        }
        
        // 创建锚点
        let anchor = ARAnchor(name: name, transform: raycastResult.worldTransform)
        let robotAnchor = AnchorEntity(anchor: anchor)
        
        // 同步加载
        do {
            let myModelEntity = try ModelEntity.load(named: name)
            myModelEntity.components[CollisionComponent.self] = CollisionComponent(
                shapes: [.generateBox(size: [1,1,1])],    // 碰撞体形状及尺寸
                mode: .default,     // 碰撞体状态
                filter: CollisionFilter(group: CollisionGroup(rawValue: 1), mask: CollisionGroup(rawValue: 1))
            )
            robotAnchor.addChild(myModelEntity)
            self.arView.scene.addAnchor(robotAnchor)
            activityEntity = myModelEntity
            if let _ = myModelEntity.availableAnimations.first {
                myModelEntity.playAnimation(myModelEntity.availableAnimations[0].repeat())
            }

        } catch {
            return nil
        }
        
        // 异步加载
//        let usdzPath = name
//        var cancellable: AnyCancellable? = nil
//        cancellable = ModelEntity.loadModelAsync(named: usdzPath)
//            .sink(receiveCompletion: { error in
//                print("发生错误: \(error)")
//                cancellable?.cancel()
//            }, receiveValue: { entity in
//                DispatchQueue.main.async {
//                    self.activityEntity = entity
//                    robotAnchor.addChild(entity)
//                    self.arView.scene.addAnchor(robotAnchor)
//                    // 此处需适配iOS 15
//                    if entity.availableAnimations.first != nil {
//                        entity.playAnimation(entity.availableAnimations[0].repeat())
//                    }
//                }
//                cancellable?.cancel()
//            })
        
        
        return anchor
    }
    
    
    
}
