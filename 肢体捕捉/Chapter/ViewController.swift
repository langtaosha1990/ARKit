//
//  ViewController.swift
//  Chapter
//
//  Created by Gpf 郭 on 2022/6/15.
//

import UIKit
import ARKit
import RealityKit
import Combine
import ReplayKit

class ViewController: UIViewController {
    var arView: ARView!
    
    var isRecording: Bool = false
    var previewViewController: UIViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        guard ARBodyTrackingConfiguration.isSupported else {
            fatalError("当前设备不支持人体肢体捕捉")
        }
        arView = ARView()
        let config = ARBodyTrackingConfiguration()
        arView.session.delegate = arView
        arView.CreateSphere()
        arView.session.run(config)
        self.view.addSubview(arView)
        
        let btn = UIButton(type: .custom)
        btn.frame = CGRectMake(view.bounds.width - 100, 50 , 80, 50)
        btn.setTitle("开始录制", for: .normal)
        btn.backgroundColor = .red
        btn.addTarget(self, action: #selector(recording), for: .touchUpInside)
        self.view.addSubview(btn)
        self.view.bringSubviewToFront(btn)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.arView.frame = self.view.frame
    }
    
    @objc func recording(sender:UIButton) {
        if isRecording {
            isRecording = false
            RPScreenRecorder.shared().stopRecording { (previewViewController, error) in
                if let error = error {
                    print("Error finishing recording: \(error)")
                    return
                }
                
                if let previewViewController = previewViewController {
                    if UIDevice.current.userInterfaceIdiom == .pad {
                        previewViewController.modalPresentationStyle = .popover
                        previewViewController.popoverPresentationController?.sourceRect = .zero
                        previewViewController.popoverPresentationController?.sourceView = self.view
                    }
                    
                    self.previewViewController = previewViewController
                    previewViewController.previewControllerDelegate = self
                    
                    // Present the view controller.
                    self.present(previewViewController, animated: true, completion: nil)
                }
            }
        } else {
            isRecording = true
            RPScreenRecorder.shared().startRecording { (error) in
                if let error = error {
                    print("Error starting recording\(error)")
                } else {
                    print("Recording started successfully")
                }
            }
        }
    }
}

extension ViewController : RPPreviewViewControllerDelegate {
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}

var leftEye: ModelEntity!
var rightEye: ModelEntity!
var eyeAnchor = AnchorEntity()

extension ARView: ARSessionDelegate {
    func CreateSphere(){
        let eyeMat = SimpleMaterial(color: .green, isMetallic: true)
        leftEye = ModelEntity(mesh: .generateSphere(radius: 0.02), materials: [eyeMat])
        rightEye = ModelEntity(mesh: .generateSphere(radius: 0.02), materials: [eyeMat])
        eyeAnchor.addChild(leftEye)
        eyeAnchor.addChild(rightEye)
        self.scene.addAnchor(eyeAnchor)
    }
    
    public func session(_ session: ARSession, didUpdate anchors: [ARAnchor]){
        for anchor in anchors {
            guard let bodyAnchor = anchor as? ARBodyAnchor else { continue }
            let bodyPosition = simd_make_float3(bodyAnchor.transform.columns.3)
            // 获取左右眼的位置矩阵
            guard let leftEyeMatrix = bodyAnchor.skeleton.modelTransform(for: ARSkeleton.JointName(rawValue: "left_eye_joint")),let rightEyeMatrix = bodyAnchor.skeleton.modelTransform(for: ARSkeleton.JointName(rawValue: "right_eye_joint")) else{ return}
            let posLeftEye = simd_make_float3(leftEyeMatrix.columns.3)
            leftEye.position =  posLeftEye
            let posRightEye = simd_make_float3(rightEyeMatrix.columns.3)
            rightEye.position = posRightEye
            eyeAnchor.position = bodyPosition
            eyeAnchor.orientation = Transform(matrix: bodyAnchor.transform).rotation
        }
    }
}

