//
//  ViewController.swift
//  Chapter
//
//  Created by Gpf 郭 on 2022/6/15.
//

import UIKit
import RealityKit
import ARKit
import ReplayKit


class ViewController: UIViewController {

    var arView: ARView!
    var isRecording: Bool = false
    var previewViewController: UIViewController?
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
        arView.frame = self.view.frame
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

