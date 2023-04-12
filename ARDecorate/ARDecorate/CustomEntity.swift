//
//  CustomEntity.swift
//  ARDecorate
//
//  Created by Gpf 郭 on 2023/3/20.
//

import RealityKit
import ARKit
//import Combine
class CustomEntity: Entity, HasCollision, HasAnchoring{
//    var subscribes: [Cancellable] = []
    
    convenience init(name: String) {
//        super.init()
//        let myModelEntity = try ModelEntity.load(named: name)
        self.init()
        
    }
    
    func loadModel(name: String) {
        
    }
    
    
    
}
