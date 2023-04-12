//
//  ViewController.swift
//  Chapter
//
//  Created by Gpf 郭 on 2022/6/15.
//

import UIKit
import RealityKit
import ARKit

class ViewController: UIViewController {

    var arView: ARView!
    override func viewDidLoad() {
        super.viewDidLoad()
        arView = ARView(frame: .zero)
        self.view.addSubview(arView)
        if ARFaceTrackingConfiguration.isSupported {
            let faceConfig = ARFaceTrackingConfiguration()
            faceConfig.maximumNumberOfTrackedFaces = 1
            //arView.session.delegate = arView
            let faceAnchor = try! FaceMask.loadGlass1()
            arView.addGuesture()
            arView.scene.addAnchor(faceAnchor)
            arView.session.run(faceConfig, options: [])
        } else {
            fatalError("the phone not support face tracking")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        arView.frame = self.view.frame
    }
}

var faceMaskCount = 0
let numberOfMasks = 5

extension ARView: ARSessionDelegate {
    func addGuesture() {
        let gesture = UISwipeGestureRecognizer()
        gesture.addTarget(self, action: #selector(changeGlass(gesture:)))
        self.addGestureRecognizer(gesture)
    }
    @objc func changeGlass(gesture: UISwipeGestureRecognizer){
        faceMaskCount += 1
        faceMaskCount %= numberOfMasks
        switch faceMaskCount {
        case 0:
            let g = try! FaceMask.loadGlass2()
            self.scene.anchors.removeAll()
            self.scene.addAnchor(g)
        case 1:
            let g = try! FaceMask.loadIndian()
            self.scene.anchors.removeAll()
            self.scene.addAnchor(g)
        case 2:
            let g = try! FaceMask.loadRabbit()
            self.scene.anchors.removeAll()
            self.scene.addAnchor(g)
        case 3:
            let g = try! FaceMask.loadHelicopterPilot()
            self.scene.anchors.removeAll()
            self.scene.addAnchor(g)
        case 4:
            let g = try! FaceMask.loadGlass1()
            self.scene.anchors.removeAll()
            self.scene.addAnchor(g)
        default:
            break
        }
    }
}

