//
//  ViewController.swift
//  WatherApp
//
//  Created by Gpf 郭 on 2023/4/4.
//

import UIKit
import ARKit
import RealityKit
import ReplayKit

class ViewController: UIViewController, ARSessionDelegate {
    
    var arView: ARView!
    var isRecording: Bool = false
    var previewViewController: UIViewController?
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.arView = ARView(frame: view.frame)
        self.arView.session.delegate = self
        
        // 设置配置模式为WorldTracking
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = .horizontal // 设置识别水平平面
        self.arView.session.run(config)
//        self.arView.setupGestures()
//        self.arView.createPlane()
        self.view.addSubview(self.arView)
        
        let btn = UIButton(type: .custom)
        btn.frame = CGRectMake(view.bounds.width - 100, 50 , 80, 50)
        btn.setTitle("开始录制", for: .normal)
        btn.backgroundColor = .red
        btn.addTarget(self, action: #selector(recording), for: .touchUpInside)
        self.view.addSubview(btn)
        self.view.bringSubviewToFront(btn)
        
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

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let point = touch.location(in: self.arView)
        
        guard let raycastQuery = self.arView.makeRaycastQuery(from: point, allowing: .existingPlaneInfinite, alignment: .any) else {
            return
        }
        
        guard let result = self.arView.session.raycast(raycastQuery).first else {
            return
        }
        
//        let transformation = Transform(matrix: result.worldTransform);
        
        let videoItem = createVideoItem(with: "output")
        let videoMaterial = createVideoMaterial(with: videoItem!)
        
        let ballMesh = MeshResource.generateBox(size: 0.1)
        let ballEntity = ModelEntity(mesh: ballMesh, materials: [videoMaterial])
        let planeAnchor = AnchorEntity(plane:.horizontal)
        planeAnchor.addChild(ballEntity)
        self.arView.scene.addAnchor(planeAnchor)
        
        let textMesh = MeshResource.generateText("38.5℃",
                                                 extrusionDepth: 0.01,
                                                 font: .systemFont(ofSize: 0.05),
                                                containerFrame: CGRect(),
                                                 alignment: .center,
                                                 lineBreakMode: .byWordWrapping)
        let textMaterial = SimpleMaterial(color: .red, isMetallic: true)
        let textEntity = ModelEntity(mesh: textMesh, materials: [textMaterial])
        textEntity.transform.translation = SIMD3(x: -0.09, y: 0.05, z: 0)
        textEntity.transform.rotation = simd_quatf(angle: -0.5, axis: [1, 0, 0])
        planeAnchor.addChild(textEntity)
    }
    
    
    
    func createVideoItem(with fileName:String) -> AVPlayerItem? {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "mp4") else {
            return nil
        }
        
        let asset = AVURLAsset(url: url)
        let videoItem = AVPlayerItem(asset: asset)
        return videoItem
    }
    
    func createVideoMaterial(with videoItem: AVPlayerItem) -> VideoMaterial {
        let player = AVPlayer()
        let videoMaterial = VideoMaterial(avPlayer: player)
        
        player.replaceCurrentItem(with: videoItem)
        
        player.play()
        return videoMaterial
    }

}

extension ViewController : RPPreviewViewControllerDelegate {
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}

