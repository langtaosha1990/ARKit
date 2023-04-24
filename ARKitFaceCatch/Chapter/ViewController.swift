//
//  ViewController.swift
//  Chapter
//
//  Created by Gpf 郭 on 2022/6/15.
//

import UIKit
import ARKit
import RealityKit


class ViewController: UIViewController {
    var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView = ARSCNView(frame: .zero)
        self.view.addSubview(sceneView)
        
        guard ARFaceTrackingConfiguration.isSupported else {
            fatalError("当前设备不支持人脸检测！")
        }
        sceneView.delegate = self
        
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        configuration.providesAudioData = false
        configuration.isWorldTrackingEnabled = false
        configuration.maximumNumberOfTrackedFaces = 1
        sceneView.session.run(configuration)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sceneView.frame = self.view.frame
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
}

extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let device = sceneView.device else {return nil }
        let faceGeometry = ARSCNFaceGeometry(device: device)
        let node = SCNNode(geometry: faceGeometry)
        let material = node.geometry?.firstMaterial!
        material?.diffuse.contents = "face.scnassets/face.png"
        node.geometry?.firstMaterial?.fillMode = .fill
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode,for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor,
              let faceGeometry = node.geometry as? ARSCNFaceGeometry else {
            return
        }
        faceGeometry.update(from: faceAnchor.geometry)
    }
}

