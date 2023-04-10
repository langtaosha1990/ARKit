//
//  ViewController.swift
//  Shader材质
//
//  Created by Gpf 郭 on 2023/4/8.
//

import UIKit
import ARKit
import ReplayKit


class ViewController: UIViewController {
    @IBOutlet weak var segment: UISegmentedControl!
    var scnView: ARSCNView!
    var planMaterial:SCNMaterial!
    
    var isRecording: Bool = false
    var previewViewController: UIViewController?
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.scnView = ARSCNView(frame: view.frame)

        // 设置配置模式为WorldTracking
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = .horizontal // 设置识别水平平面
        self.scnView.session.run(config)
        self.view.addSubview(self.scnView)
        
        let orthographicCameraNode = SCNNode()
        orthographicCameraNode.camera = SCNCamera()
        orthographicCameraNode.camera?.usesOrthographicProjection = true
        orthographicCameraNode.position = SCNVector3(0, 0, 1)
        
        makePlane()
        
        let titles = ["rainbowSwirlFragment", "warpLineFragment", "morphGridFragment", "waterColorFragmet", "polarCoordinatesFragment", "textureFragment", "scanImageFragment"]
        for i in 0..<7 {
            segment.setTitle(titles[i], forSegmentAt: i)
        }
        
        self.view.bringSubviewToFront(segment)
        
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

    // 创建展示材质的平面
    func makePlane() {
        let plane = SCNPlane(width: 0.5, height: 0.5)
        
        let planeNode = SCNNode(geometry: plane)
        planMaterial = planeNode.geometry!.firstMaterial
        planeNode.position = SCNVector3(0, -0.5, -1)
        setDefaultShader()
        self.scnView.scene.rootNode.addChildNode(planeNode)
    }
    
    func setDefaultShader() {
        let mapFragment = try! String(contentsOf: Bundle.main.url(forResource: "rainbowSwirlFragment", withExtension: "shader")!, encoding: String.Encoding.utf8)
        let shaderModifiers = [SCNShaderModifierEntryPoint.fragment:mapFragment];
        planMaterial?.shaderModifiers = shaderModifiers
    }
    
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        // 根据segment加载对应的shader
        switch sender.selectedSegmentIndex {
        case 0:
            // 加载相应的shader并设置到平面材质上
            let mapFragment = try! String(contentsOf: Bundle.main.url(forResource: "rainbowSwirlFragment", withExtension: "shader")!, encoding: String.Encoding.utf8)
            let shaderModifiers = [SCNShaderModifierEntryPoint.fragment:mapFragment];
            planMaterial?.shaderModifiers = shaderModifiers
        case 1:
            let mapFragment = try! String(contentsOf: Bundle.main.url(forResource: "warpLineFragment", withExtension: "shader")!, encoding: String.Encoding.utf8)
            let shaderModifiers = [SCNShaderModifierEntryPoint.fragment:mapFragment];
            planMaterial?.shaderModifiers = shaderModifiers
        case 2:
            let mapFragment = try! String(contentsOf: Bundle.main.url(forResource: "morphGridFragment", withExtension: "shader")!, encoding: String.Encoding.utf8)
            let shaderModifiers = [SCNShaderModifierEntryPoint.fragment:mapFragment];
            planMaterial?.shaderModifiers = shaderModifiers
        case 3:
            let mapFragment = try! String(contentsOf: Bundle.main.url(forResource: "waterColorFragmet", withExtension: "shader")!, encoding: String.Encoding.utf8)
            let shaderModifiers = [SCNShaderModifierEntryPoint.fragment:mapFragment];
            planMaterial?.shaderModifiers = shaderModifiers
        case 4:
            let mapFragment = try! String(contentsOf: Bundle.main.url(forResource: "polarCoordinatesFragment", withExtension: "shader")!, encoding: String.Encoding.utf8)
            let shaderModifiers = [SCNShaderModifierEntryPoint.fragment:mapFragment];
            planMaterial?.shaderModifiers = shaderModifiers
        case 5:
            let mapFragment = try! String(contentsOf: Bundle.main.url(forResource: "textureFragment", withExtension: "shader")!, encoding: String.Encoding.utf8)
            let shaderModifiers = [SCNShaderModifierEntryPoint.fragment:mapFragment];

            let img1 = UIImage(named: "uv_grid.jpg")
            let img2 = UIImage(named: "ChristmasTreeOrnament02_col.jpg")
            planMaterial?.shaderModifiers = shaderModifiers
            // 根据shader中的id传入相应的图片
            planMaterial?.setValue(SCNMaterialProperty(contents: img1!), forKey: "texture1")
            planMaterial?.setValue(SCNMaterialProperty(contents: img2!), forKey: "texture2")
        case 6:
            let mapFragment = try! String(contentsOf: Bundle.main.url(forResource: "scanImageFragment", withExtension: "shader")!, encoding: String.Encoding.utf8)
            let shaderModifiers = [SCNShaderModifierEntryPoint.fragment:mapFragment];
            let img = UIImage(named: "ChristmasTreeOrnament02_col.jpg")
            planMaterial?.shaderModifiers = shaderModifiers
            planMaterial?.setValue(SCNMaterialProperty(contents: img!), forKey: "texture")
        default:
            return
        }
        
    }
    
    private func image(named imageName: String) -> UIImage {
        return UIImage(named: imageName, in: Bundle.main, compatibleWith: nil)!
    }
    
    private func shaderModifier(named shaderModifierName: String) -> String {
        return try! String(contentsOfFile: Bundle.main.path(forResource: shaderModifierName, ofType: "shader")!, encoding: String.Encoding.utf8)
    }
}

extension ViewController : RPPreviewViewControllerDelegate {
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}

