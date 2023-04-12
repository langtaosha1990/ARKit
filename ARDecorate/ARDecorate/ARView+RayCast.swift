//
//  ARView+RayCast.swift
//  ARDecorate
//
//  Created by Gpf 郭 on 2023/3/19.
//

import ARKit
import RealityKit
extension ViewController {
    
    func setupGestures() {
      let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.arView.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        
        guard let touchInView = sender?.location(in: self.arView) else {
            return
        }

        // Raycast 射线   Query 查询   在arview中查找点击点的位置
        guard let raycastQuery = self.arView.makeRaycastQuery(from: touchInView, allowing: .existingPlaneInfinite,alignment: .any) else {
            return
        }
//
//        guard let result = self.arView.session.raycast(raycastQuery).first else {return}
//        let transformation = Transform(matrix: result.worldTransform)
//
        guard let entity = self.arView.entity(at: touchInView) else {
            return
        }
        print("点击的entity：\(entity.name)")
        self.activityEntity = entity
        
        
//        guard let rel = self.arView.raycast(from: touchInView, allowing: .existingPlaneInfinite, alignment: .horizontal).first else {
//            return
//        }
        
    }
    
}
