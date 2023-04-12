//
//  ViewController+SwapGesture.swift
//  ARDecorate
//
//  Created by Gpf 郭 on 2022/8/8.
//

import Foundation
import UIKit


extension ViewController {
    
    enum GestureDurection {
        case toUp, toDown, toLeft, toRight
    }
    
    struct GestureModel {
        var durection: GestureDurection
        
    }
    
    func addSwipeGesture() {
        
        let toUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeGestureToup(gesture:)))
        toUpGesture.direction = .up
        arView.addGestureRecognizer(toUpGesture)
        
        let toDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeGestureToDown(gesture:)))
        toDownGesture.direction = .down
        arView.addGestureRecognizer(toDownGesture)
        
        let toLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeGestureToLeft(gesture:)))
        toLeftGesture.direction = .left
        arView.addGestureRecognizer(toLeftGesture)
        
        let toRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeGestureToRight(gesture:)))
        toRightGesture.direction = .right
        arView.addGestureRecognizer(toRightGesture)
    }
    
    @objc func swipeGestureToup(gesture: UISwipeGestureRecognizer) {
        
    }
    
    @objc func swipeGestureToDown(gesture: UISwipeGestureRecognizer) {
        
    }
    @objc func swipeGestureToLeft(gesture: UISwipeGestureRecognizer) {
        
    }
    @objc func swipeGestureToRight(gesture: UISwipeGestureRecognizer) {
        
    }
    
    
}




