//
//  ViewController.swift
//  RealityKit基础demo
//
//  Created by Gpf 郭 on 2023/3/20.
//

import UIKit
import RealityKit
import ARKit
import Combine
import ReplayKit

class ViewController: UIViewController {
    
    var arView: ARView!
    var isRecording: Bool = false
    var previewViewController: UIViewController?
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.arView = ARView(frame: view.frame)
        self.arView.session.delegate = self.arView
        
        // 设置配置模式为WorldTracking
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = .horizontal // 设置识别水平平面
        self.arView.session.run(config)
        self.arView.setupGestures()
        self.arView.createPlane()
        self.view.addSubview(self.arView)
        
        let btn = UIButton(type: .custom)
        btn.frame = CGRectMake(view.bounds.width - 100, 50 , 80, 50)
        btn.setTitle("开始录制", for: .normal)
        btn.backgroundColor = .red
        btn.addTarget(self, action: #selector(recording), for: .touchUpInside)
        self.view.addSubview(btn)
        self.view.bringSubviewToFront(btn)
        
        //        arView.debugOptions = [.showPhysics]  //现实碰撞体
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

var planeEntity:ModelEntity!
extension ARView: ARSessionDelegate {
    
    // 添加水平平面
    func createPlane() {
        let planeMesh = MeshResource.generatePlane(width: 0.15, depth: 0.15)// 创建网格
        var planeMaterial = SimpleMaterial(color:.white,isMetallic: false)  // 创建材质
        //        planeMaterial.baseColor = try .texture(.load(named: "Box_Texture.jpg")) // 设置纹理
        planeMaterial.tintColor = UIColor.green.withAlphaComponent(0.9999) // 设置视图的色彩
        planeEntity = ModelEntity(mesh: planeMesh, materials: [planeMaterial])  // 创建平面实体
        let planeAnchor = AnchorEntity() // 创建锚点
        planeAnchor.addChild(planeEntity)   //
        self.scene.addAnchor(planeAnchor)   // 将锚点添加套scene中
    }
    
    public func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        guard let pAnchor = anchors[0] as? ARPlaneAnchor else {
            return
        }
        DispatchQueue.main.async {
            planeEntity.model?.mesh = MeshResource.generatePlane(
                width: pAnchor.extent.x,
                depth: pAnchor.extent.z
            )
            planeEntity.setTransformMatrix(pAnchor.transform, relativeTo: nil)
        }
    }
    
    public func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        guard let pAnchor = anchors[0] as? ARPlaneAnchor else {
            return
        }
        DispatchQueue.main.async {
            // 调节平面网格的尺寸
            planeEntity.model?.mesh = MeshResource.generatePlane(
                width: pAnchor.extent.x,
                depth: pAnchor.extent.z
            )
            planeEntity.setTransformMatrix(pAnchor.transform, relativeTo: nil)
        }
    }
}

var entityIndex:Int = 0
var arSubscribes: [Cancellable] = []
var gestureStartLocation: SIMD3<Float>?
extension ARView {
    // 添加点击手势
    func setupGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        guard let touchInView = sender?.location(in: self) else {
            return
        }
        
        if let rel = self.entities(at: touchInView).first as? CustomEntity {
            rel.model?.materials = [SimpleMaterial(color: .white, isMetallic: false)]
            return
        }
        
        // 射线检测
        guard let raycastQuery = self.makeRaycastQuery(from: touchInView, allowing: .existingPlaneInfinite,alignment: .any) else {
            return
        }
        guard let result = self.session.raycast(raycastQuery).first else {return}
        let transformation = Transform(matrix: result.worldTransform)
        
        
        let customEntity = CustomEntity(.box, transformation.translation)
        customEntity.name = "boxEntityIndex:\(String(describing: entityIndex))"
        entityIndex+=1
        customEntity.addCollisions(scene: self.scene)
        self.scene.addAnchor(customEntity)
        // 给customEntity添加手势
        self.installGestures(.all, for: customEntity).forEach {
            $0.addTarget(self, action: #selector(handleModelGesture))
        }
        
        
        // 添加观察者并将信号进行缓存防止被释放
        arSubscribes.append(scene.subscribe(to: CollisionEvents.Began.self, on: customEntity) {
            event in
            guard let entityA = event.entityA as? CustomEntity else {
                return
            }
            
            guard let entityB = event.entityB as? CustomEntity else {
                return
            }
            
            entityA.model?.materials = [SimpleMaterial(color: .red, isMetallic: false)]
            entityB.model?.materials = [SimpleMaterial(color: .purple, isMetallic: false)]
            
            print("\(entityA.name)---\(entityB.name)")
        })
        
        // 结束碰撞时的观察
        arSubscribes.append(scene.subscribe(to: CollisionEvents.Ended.self, on: customEntity) {
            event in
            guard let entityA = event.entityA as? CustomEntity else {
                return
            }
            
            guard let entityB = event.entityB as? CustomEntity else {
                return
            }
            entityA.model?.materials = [SimpleMaterial(color: .orange, isMetallic: false)]
            entityB.model?.materials = [SimpleMaterial(color: .orange, isMetallic: false)]
            
        })
        
        
    }
    
    // 处理平移手势的逻辑
    @objc func handleModelGesture(_ sender: Any) {
        switch sender {
        case let translation as EntityTranslationGestureRecognizer:
            if translation.state == .ended || translation.state == .cancelled {
                gestureStartLocation = nil
                return
            }
            guard let gestureCurrentLocation = translation.entity?.transform.translation else { return }
            guard let _ = gestureStartLocation else {
                gestureStartLocation = gestureCurrentLocation
                return
            }
        default:
            break
        }
    }
}


class CustomEntity:Entity, HasModel, HasAnchoring, HasCollision {
    enum MeshType {
        case box,sphere,capsule,plane
    }
    
    var subscribes: [Cancellable] = []
    convenience init(_ type: MeshType, _ position: SIMD3<Float>) {
        self.init(type: type)
        self.position = position
    }
    
    required init() {
        fatalError("init()没有执行，初始化不成功")
    }
    
    required init(type: MeshType) {
        super.init()
        switch type {
        case .box: do {
            // 设置碰撞体形状
            self.components[CollisionComponent.self] = CollisionComponent(
                shapes: [.generateBox(size: [0.1,0.1,0.1])],
                mode: .default,
                filter: CollisionFilter(group: CollisionGroup(rawValue: 1), mask: CollisionGroup(rawValue: 1))
            )
            // 设置外形
            self.components[ModelComponent.self] = ModelComponent(
                mesh: .generateBox(size: [0.1,0.1,0.1]), materials: [SimpleMaterial(color: .orange,isMetallic: false)]
            )
        }
        case .sphere: do {
            self.components[CollisionComponent.self] = CollisionComponent(
                shapes: [.generateSphere(radius: 0.1)],
                mode: .default,
                filter: CollisionFilter(group: CollisionGroup(rawValue: 1), mask: CollisionGroup(rawValue: 1))
            )
            self.components[ModelComponent.self] = ModelComponent(
                mesh: .generateSphere(radius: 0.1), materials: []
            )
        }
            
        case .capsule: do {
            self.components[CollisionComponent.self] = CollisionComponent(
                shapes: [.generateCapsule(height: 0.5, radius: 0.1)],
                mode: .default,
                filter: CollisionFilter(group: CollisionGroup(rawValue: 1), mask: CollisionGroup(rawValue: 1))
            )
            self.components[ModelComponent.self] = ModelComponent(
                mesh: .generateBox(size: [0.1,0.5,0.1]), materials: []
            )
        }
        case .plane: do {
            self.components[CollisionComponent.self] = CollisionComponent(
                shapes: [.generateBox(width: 0.15, height: 0.01, depth: 0.15)],
                mode: .default,
                filter: CollisionFilter(group: CollisionGroup(rawValue: 1), mask: CollisionGroup(rawValue: 1))
            )
            self.components[ModelComponent.self] = ModelComponent(
                mesh: .generatePlane(width: 0.15, depth: 0.15), materials: []
            )
        }
        }
    }
    
    // 也可以在这里进行碰撞检测
    func addCollisions(scene: Scene) {
        subscribes.append(scene.subscribe(to: CollisionEvents.Began.self, on:self) { event in
            guard let entityA = event.entityA as? CustomEntity else {
                return
            }
            guard let entityB = event.entityB as? CustomEntity else {
                return
            }
            //            entityA.model?.materials = [SimpleMaterial(color: .red, isMetallic: false)]
            //            entityB.model?.materials = [SimpleMaterial(color: .purple, isMetallic: false)]
            //            print("\(entityA.name)---\(entityB.name)")
        })
        
        subscribes.append(scene.subscribe(to: CollisionEvents.Ended.self, { event in
            guard let entity = event.entityA as? CustomEntity else {
                return
            }
            
            //            entity.model?.materials = [SimpleMaterial(color: .yellow, isMetallic: false)]
        }))
    }
    
}







