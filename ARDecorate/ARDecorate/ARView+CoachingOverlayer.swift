//
//  ARView+CoachingOverlayer.swift
//  ARDecorate
//
//  Created by Gpf 郭 on 2022/8/8.
//

import Foundation
import ARKit
import RealityKit

extension ARView: ARCoachingOverlayViewDelegate {
    
    func addCoaching() {
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(coachingOverlay)
        coachingOverlay.goal = .horizontalPlane
        coachingOverlay.session = self.session
        coachingOverlay.delegate = self
    }
    
    // 完成定位
    public func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
      
    }
    
}
