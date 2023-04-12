//
//  ViewController.swift
//  ARDecorate
//
//  Created by Gpf 郭 on 2022/8/5.
//

import UIKit
import RealityKit
import ARKit
import MobileCoreServices
import Combine
import ReplayKit

let bounds = UIScreen.main.bounds
class ViewController: UIViewController {

    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var turnSlider: UISlider!
    @IBOutlet weak var entitySelectView: UIView!
    @IBOutlet weak var entityCollectionView: UICollectionView!
    var previewViewController: UIViewController?
    var arView: ARView!
    var raycastResult : ARRaycastResult?
    var locationAnchor: AnchorEntity!
    let dataArray: [String] = ["Bee", "cup", "eagle", "dance_girl", "Mountain_King", "Peacock-04", "watermelon", "toy_biplane", "toy_drummer"]
    var selestedIndex: Int = 0
    var activityEntity: Entity? {
        didSet {
            slider.value = 1
        }
    }
    
    var isRecording: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    
    @IBAction func recordingBtnAction(_ sender: Any) {
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
    
    @IBAction func saveSceneBtnAction(_ sender: Any) {
        self.arView.saveARWorldMap()
    }
    
    @IBAction func readSceneBtnAction(_ sender: Any) {
        if(self.arView.loadARWorldMap()) {
            print("load world success")
        } else {
            print("load world failed")
        }
    }
    
}

extension ViewController : RPPreviewViewControllerDelegate {
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}

var planeMesh = MeshResource.generatePlane(width: 0.15, depth: 0.15)
var planeMaterial = SimpleMaterial(color:.white,isMetallic: false)
var planeEntity  = ModelEntity(mesh:planeMesh,materials:[planeMaterial])
var planeAnchor = AnchorEntity()

extension ViewController {
    func setupView() {
        self.arView = ARView()
        arView.session.delegate = arView
        arView.addCoaching()
        arView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)

        self.view.insertSubview(arView, belowSubview: entitySelectView)
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = .horizontal
        self.arView.session.run(config)
        self.setupGestures()
//        self.arView.debugOptions = [.showPhysics]
        
        entityCollectionView.dataSource = self
        entityCollectionView.dragDelegate = self
        entityCollectionView.delegate = self
        
        arView.isUserInteractionEnabled = true
        arView.addInteraction(UIDropInteraction(delegate: self))
        
        slider.addTarget(self, action: #selector(scaleSliderAction(slider:)), for: .valueChanged)
        turnSlider.addTarget(self, action: #selector(trunSliderAction(slider:)), for: .valueChanged)
        
        
    }
    
    func addAchor() {
        let planeMesh = MeshResource.generatePlane(width: 0.01, height: 0.01, cornerRadius: 0.01)
        let planeEntity = ModelEntity(mesh: planeMesh, materials: [planeMaterial])
        planeEntity.generateCollisionShapes(recursive: false)
        planeAnchor = AnchorEntity()
        planeAnchor.addChild(planeEntity)
        self.arView.scene.addAnchor(planeAnchor)
    }
    
    func createPlane() {
        do {
            planeMaterial.baseColor = try .texture(.load(named: "Box_Texture.jpg"))
            planeMaterial.tintColor = UIColor.green.withAlphaComponent(0.9999)
            planeAnchor.addChild(planeEntity)
            self.arView.scene.addAnchor(planeAnchor)
        } catch {
            print("找不到文件")
        }
    }
    
    @objc func scaleSliderAction(slider: UISlider) {
        activityEntity?.scale = [0.1, 0.1, 0.1] * slider.value
    }
    
    @objc func trunSliderAction(slider: UISlider) {
        activityEntity?.transform.rotation = simd_quatf(angle: .pi * 2 * slider.value, axis: [0, 1, 0])
    }
}






