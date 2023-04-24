//
//  ViewController.swift
//  AudioVisualization
//
//  Created by Gpf 郭 on 2023/4/14.
//

import UIKit
import AVFoundation
import ARKit

class ViewController: UIViewController, AVAudioPlayerDelegate {

    var player:AVAudioPlayer!
    var scnView: ARSCNView!
    var planMaterial:SCNMaterial!
    var arr:NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = Bundle.main.url(forResource: "2", withExtension: "mp3")
        do {
            self.player = try AVAudioPlayer.init(contentsOf: url!)
        } catch {
            fatalError("player init failed")
        }
        self.player.prepareToPlay()
        self.player.delegate = self
        self.player.play()
        self.player.numberOfLoops = 1000;
        print("音轨数：\(self.player.numberOfChannels)")
        
        let asset = AVURLAsset(url: url!)
        SampleDataProvider.loadAudioSamples(from: asset) { data in
            let filter = SampleDataFilter.init(data: data!)
            self.arr = filter.filteredSamples(for: CGSize(width: 1000, height: 1)) as NSArray
        }
        
        let displayLink = CADisplayLink(target: self, selector: #selector(refershFunction))
        displayLink.add(to: .current, forMode: .common)
    }
     
    @objc func refershFunction() {
        guard let arr = self.arr else {
            return
        }
        let v = arr[Int(floor((self.player.currentTime / self.player.duration) * 1000))]
        print((v as AnyObject).floatValue as Any)
        planMaterial.setValue((v as AnyObject).floatValue / 10.0, forKey: "audioValue")
    }
    
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
        let mapFragment = try! String(contentsOf: Bundle.main.url(forResource: "AudioVisualizationFragment", withExtension: "shader")!, encoding: String.Encoding.utf8)
        let shaderModifiers = [SCNShaderModifierEntryPoint.fragment:mapFragment];
        planMaterial?.shaderModifiers = shaderModifiers
        
    }
}

