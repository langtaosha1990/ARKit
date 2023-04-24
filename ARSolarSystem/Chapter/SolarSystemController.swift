//
//  SolarSystemController.swift
//  Chapter
//
//  Created by Gpf 郭 on 2022/7/11.
//

import Foundation
import ARKit
import SceneKit


let screenBounds = UIScreen.main.bounds
class SolarSystemController: UIViewController, ARSCNViewDelegate, ARSessionDelegate {
    
    // 是否是vr模式
    var isCardBoard: Bool = false
    
    lazy var arSCNView: ARSCNView = {
        let arScnView = ARSCNView(frame: screenBounds)
        arScnView.session = self.arSession
        arScnView.automaticallyUpdatesLighting = true
        arScnView.delegate = self
        initNodeWithRootView(scnView: arScnView)
        return arScnView
    }()
    
    lazy var arSession: ARSession = {
        let arSession = ARSession()
        arSession.delegate = self
       return arSession
    }()
    lazy var arSessionConfiguration: ARWorldTrackingConfiguration = {
       let arSessionConfiguration = ARWorldTrackingConfiguration()
        // 设置追踪方向
        arSessionConfiguration.planeDetection = .horizontal
        // 自适应灯光
        arSessionConfiguration.isLightEstimationEnabled = true
        return arSessionConfiguration
    }()
    
    // node 对象
    var sunNode: SCNNode?
    var sunNodeL: SCNNode?
    var earthNode: SCNNode?
    var earthNodeL: SCNNode?
    var moonNode: SCNNode?
    var moonNodeL: SCNNode?
    var marsNode: SCNNode?//火星
    var marsNodeL: SCNNode?
    var mercuryNode: SCNNode?//水星
    var mercuryNodeL: SCNNode?
    var venusNode: SCNNode?//金星
    var venusNodeL: SCNNode?
    var jupiterNode: SCNNode?//木星
    var jupiterNodeL: SCNNode?
    var jupiterLoopNode: SCNNode?//木星环
    var jupiterLoopNodeL: SCNNode?
    var jupiterGroupNode: SCNNode?//木星环
    var jupiterGroupNodeL: SCNNode?
    var saturnNode: SCNNode? //土星
    var saturnNodeL: SCNNode?
    var saturnLoopNode: SCNNode?//土星环
    var saturnLoopNodeL: SCNNode?
    var sartunGroupNode: SCNNode?//土星Group
    var sartunGroupNodeL: SCNNode?
    var uranusNode: SCNNode?//天王星
    var uranusNodeL: SCNNode?
    var uranusLoopNode: SCNNode?//天王星环
    var uranusLoopNodeL: SCNNode?
    var uranusGroupNode: SCNNode?//天王星Group
    var uranusGroupNodeL: SCNNode?
    var neptuneNode: SCNNode?//海王星
    var neptuneNodeL: SCNNode?
    var neptuneLoopNode: SCNNode?//海王星环
    var neptuneLoopNodeL: SCNNode?
    var neptuneGroupNode: SCNNode?//海王星Group
    var neptuneGroupNodeL: SCNNode?
    var plutoNode: SCNNode? //冥王星
    var plutoNodeL: SCNNode?
    var earthGroupNode: SCNNode?
    var earthGroupNodeL: SCNNode?
    var sunHaloNode: SCNNode?
    var sunHaloNodeL: SCNNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "太阳系"
    }
    
    override func viewWillAppear( _ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.addSubview(self.arSCNView)
        // 在场景底部启用实时统计面板。
//        arSCNView.showsStatistics = true
//        // 允许您通过简单的手势手动控制活动相机。
//        arSCNView.allowsCameraControl = true
        
        self.arSession.run(self.arSessionConfiguration)
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        sunNode?.position = SCNVector3Make(-3 * frame.camera.transform.columns.3.x, -0.1 - 3 * frame.camera.transform.columns.3.y, -2 - 3 * frame.camera.transform.columns.3.z)
    }
    
}

extension SolarSystemController {
    func initNodeWithRootView(scnView: SCNView) {
        
        // 生成对应的node节点
        sunNode = SCNNode()
        mercuryNode = SCNNode()
        venusNode = SCNNode()
        earthNode = SCNNode()
        moonNode = SCNNode()
        marsNode = SCNNode()
        earthGroupNode = SCNNode()
        jupiterNode = SCNNode()
        saturnNode = SCNNode()
        saturnLoopNode = SCNNode()
        sartunGroupNode = SCNNode()
        uranusNode = SCNNode()
        neptuneNode = SCNNode()
        plutoNode = SCNNode()
        
        sunNode?.geometry = SCNSphere(radius: 0.25)
        mercuryNode?.geometry = SCNSphere(radius: 0.02)
        venusNode?.geometry = SCNSphere(radius: 0.04)
        marsNode?.geometry = SCNSphere(radius: 0.03)
        earthNode?.geometry = SCNSphere(radius: 0.05)
        moonNode?.geometry = SCNSphere(radius: 0.01)
        jupiterNode?.geometry = SCNSphere(radius: 0.15)
        saturnNode?.geometry = SCNSphere(radius: 0.12)
        uranusNode?.geometry = SCNSphere(radius: 0.09)
        neptuneNode?.geometry = SCNSphere(radius: 0.08)
        plutoNode?.geometry = SCNSphere(radius: 0.04)
        
        moonNode?.position = SCNVector3(0.1, 0, 0)
        earthGroupNode?.addChildNode(earthNode!)
        
        sartunGroupNode?.addChildNode(saturnNode!)
        
        // 添加土星环
        let saturnLoopNode = SCNNode()
        saturnLoopNode.opacity = 0.4
        saturnLoopNode.geometry = SCNBox(width: 0.6, height: 0, length: 0.6, chamferRadius: 0)

        saturnLoopNode.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/earth/saturn_loop.png"
        saturnLoopNode.geometry?.firstMaterial?.diffuse.mipFilter = .linear
        saturnLoopNode.rotation = SCNVector4(-0.5, -1, 0, Double.pi / 2)
        saturnLoopNode.geometry?.firstMaterial?.lightingModel = .constant
        sartunGroupNode?.addChildNode(saturnLoopNode)
        
        mercuryNode?.position = SCNVector3(0.4, 0, 0)
        venusNode?.position = SCNVector3(0.6, 0, 0)
        earthGroupNode?.position = SCNVector3(0.8, 0, 0)
        marsNode?.position = SCNVector3(1.0, 0, 0)
        jupiterNode?.position = SCNVector3(1.4, 0, 0)
        sartunGroupNode?.position = SCNVector3(1.68, 0, 0)
        uranusNode?.position = SCNVector3(1.95, 0, 0)
        neptuneNode?.position = SCNVector3(2.14, 0, 0)
        plutoNode?.position = SCNVector3(2.319, 0, 0)
        sunNode?.position = SCNVector3(0, -0.1, 3)
        
        scnView.scene?.rootNode.addChildNode(sunNode!)
        
        // 贴图
        mercuryNode?.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/earth/mercury.jpg"
        //金星贴图
        venusNode?.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/earth/venus.jpg"
        //火星贴图
        marsNode?.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/earth/mars.jpg"
        
        // 地球贴图
        earthNode?.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/earth/earth-diffuse-mini.jpg";
        earthNode?.geometry?.firstMaterial?.emission.contents = "art.scnassets/earth/earth-emissive-mini.jpg"
        earthNode?.geometry?.firstMaterial?.specular.contents = "art.scnassets/earth/earth-specular-mini.jpg"

        // 月球贴图
        moonNode?.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/earth/moon.jpg"
        
        //木星贴图
        jupiterNode?.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/earth/jupiter.jpg"
        // 土星贴图
        saturnNode?.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/earth/saturn.jpg"
        saturnLoopNode.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/earth/saturnloop.jpg"
        // 天王星
        uranusNode?.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/earth/uranus.jpg"
        // 海王星
        neptuneNode?.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/earth/neptune.jpg"
        // 冥王星
        plutoNode?.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/earth/pluto.jpg"
        
        //太阳贴图
        sunNode?.geometry?.firstMaterial?.multiply.contents = "art.scnassets/earth/sun.jpg";
        sunNode?.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/earth/sun.jpg";
        sunNode?.geometry?.firstMaterial?.multiply.intensity = 0.5;
        sunNode?.geometry?.firstMaterial?.lightingModel = .constant;
        
        sunNode?.geometry?.firstMaterial?.multiply.wrapS = .repeat
        sunNode?.geometry?.firstMaterial?.diffuse.wrapS = .repeat
        sunNode?.geometry?.firstMaterial?.multiply.wrapT = .repeat
        sunNode?.geometry?.firstMaterial?.diffuse.wrapT = .repeat
        
        mercuryNode?.geometry?.firstMaterial?.locksAmbientWithDiffuse = true
        venusNode?.geometry?.firstMaterial?.locksAmbientWithDiffuse = true
        marsNode?.geometry?.firstMaterial?.locksAmbientWithDiffuse = true
        earthNode?.geometry?.firstMaterial?.locksAmbientWithDiffuse = true
        moonNode?.geometry?.firstMaterial?.locksAmbientWithDiffuse  = true
        jupiterNode?.geometry?.firstMaterial?.locksAmbientWithDiffuse  = true
        saturnNode?.geometry?.firstMaterial?.locksAmbientWithDiffuse  = true
        uranusNode?.geometry?.firstMaterial?.locksAmbientWithDiffuse  = true
        neptuneNode?.geometry?.firstMaterial?.locksAmbientWithDiffuse  = true
        plutoNode?.geometry?.firstMaterial?.locksAmbientWithDiffuse  = true
        sunNode?.geometry?.firstMaterial?.locksAmbientWithDiffuse   = true
        
        
        mercuryNode?.geometry?.firstMaterial?.shininess = 0.1
        venusNode?.geometry?.firstMaterial?.shininess = 0.1
        earthNode?.geometry?.firstMaterial?.shininess = 0.1
        moonNode?.geometry?.firstMaterial?.shininess = 0.1
        marsNode?.geometry?.firstMaterial?.shininess = 0.1
        jupiterNode?.geometry?.firstMaterial?.shininess = 0.1
        saturnNode?.geometry?.firstMaterial?.shininess = 0.1
        uranusNode?.geometry?.firstMaterial?.shininess = 0.1
        neptuneNode?.geometry?.firstMaterial?.shininess = 0.1
        plutoNode?.geometry?.firstMaterial?.shininess = 0.1
        
        mercuryNode?.geometry?.firstMaterial?.specular.intensity = 0.5
        venusNode?.geometry?.firstMaterial?.specular.intensity = 0.5
        earthNode?.geometry?.firstMaterial?.specular.intensity = 0.5
        moonNode?.geometry?.firstMaterial?.specular.intensity = 0.5
        marsNode?.geometry?.firstMaterial?.specular.intensity = 0.5
        jupiterNode?.geometry?.firstMaterial?.specular.intensity = 0.5
        saturnNode?.geometry?.firstMaterial?.specular.intensity = 0.5
        uranusNode?.geometry?.firstMaterial?.specular.intensity = 0.5
        neptuneNode?.geometry?.firstMaterial?.specular.intensity = 0.5
        plutoNode?.geometry?.firstMaterial?.specular.intensity = 0.5
        marsNode?.geometry?.firstMaterial?.specular.intensity = 0.5
        
        moonNode?.geometry?.firstMaterial?.specular.contents = UIColor.gray
        
        addOtherNode()
        roationNode()
        addLight()
        
    }
    
    func roationNode() {
        earthNode?.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))    // 地球自转
        
        var animation = CABasicAnimation(keyPath: "rotation") //月球自转
        animation.duration = 1.5
        animation.toValue = NSValue(scnVector4: SCNVector4(0, 1, 0, Double.pi * 2))
        animation.repeatCount = Float.greatestFiniteMagnitude
        moonNode?.addAnimation(animation, forKey: "moon rotation")
        
        let moonRotationNode = SCNNode()
        moonRotationNode.addChildNode(moonNode!)
        
        let moonRotationAnimation = CABasicAnimation(keyPath: "rotation")
        moonRotationAnimation.duration = 15.0
        moonRotationAnimation.toValue = NSValue(scnVector4: SCNVector4(0, 1, 0, Double.pi * 2))
        moonRotationAnimation.repeatCount = Float.greatestFiniteMagnitude
        moonRotationNode.addAnimation(animation, forKey: "moon rotation around earth")
        
        earthGroupNode?.addChildNode(moonRotationNode)
        
        let earthRotationNode = SCNNode()
        sunNode?.addChildNode(earthRotationNode)
        
        // Earth-group (will contain the Earth, and the Moon)
        earthRotationNode.addChildNode(earthGroupNode!)
        
        animation = CABasicAnimation(keyPath: "rotation")
        animation.duration = 30.0
        animation.toValue = NSValue(scnVector4: SCNVector4(0, 1, 0, Double.pi * 2))
        animation.repeatCount = Float.greatestFiniteMagnitude
        earthRotationNode.addAnimation(animation, forKey: "earth rotation around sun")
        
        // 添加自转
        mercuryNode?.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
        venusNode?.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
        marsNode?.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
        jupiterNode?.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
        saturnNode?.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
        uranusNode?.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
        neptuneNode?.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
        plutoNode?.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
        
        sartunGroupNode?.addChildNode(saturnNode!)
        
        // 生成node将星球加入到该node中，并设置该node围绕sunNode旋转
        let mercRotationNode = SCNNode()
        mercRotationNode.addChildNode(mercuryNode!)
        sunNode?.addChildNode(mercRotationNode)
        
        let venusRotationNode = SCNNode()
        venusRotationNode.addChildNode(venusNode!)
        sunNode?.addChildNode(venusRotationNode)
        
        let marsRotationNode = SCNNode()
        marsRotationNode.addChildNode(marsNode!)
        sunNode?.addChildNode(marsRotationNode)
        
        let jupiterRotationNode = SCNNode()
        jupiterRotationNode.addChildNode(jupiterNode!)
        sunNode?.addChildNode(jupiterRotationNode)
        
        let saturnRotationNode = SCNNode()
        saturnRotationNode.addChildNode(saturnNode!)
        sunNode?.addChildNode(saturnRotationNode)
        
        let uranusRotationNode = SCNNode()
        uranusRotationNode.addChildNode(uranusNode!)
        sunNode?.addChildNode(uranusRotationNode)
        
        let neptuneRotationNode = SCNNode()
        neptuneRotationNode.addChildNode(neptuneNode!)
        sunNode?.addChildNode(neptuneRotationNode)
        
        let plutoRotationNode = SCNNode()
        plutoRotationNode.addChildNode(plutoNode!)
        sunNode?.addChildNode(plutoRotationNode)
        
        // rotate the mercury around the sun
        // 添加围绕太阳运动的动效
        animation = CABasicAnimation(keyPath: "rotation")
        animation.duration = 25.0
        animation.toValue = NSValue(scnVector4: SCNVector4Make(0, 1, 0, Float(Double.pi) * 2))
        animation.repeatCount = Float.greatestFiniteMagnitude
        mercRotationNode.addAnimation(animation, forKey: "mercury rotation around sun")
        sunNode?.addChildNode(mercRotationNode)
        
        // rotate the venus around the sun
        animation = CABasicAnimation(keyPath: "rotation")
        animation.duration = 25.0
        animation.toValue = NSValue(scnVector4: SCNVector4Make(0, 1, 0, Float(Double.pi) * 2))
        animation.repeatCount = Float.greatestFiniteMagnitude
        venusRotationNode.addAnimation(animation, forKey: "venus rotation around sun")
        sunNode?.addChildNode(venusRotationNode)
        
        // rotate the mars around the sun
        animation = CABasicAnimation(keyPath: "rotation")
        animation.duration = 25.0
        animation.toValue = NSValue(scnVector4: SCNVector4Make(0, 1, 0, Float(Double.pi) * 2))
        animation.repeatCount = Float.greatestFiniteMagnitude
        marsRotationNode.addAnimation(animation, forKey: "mars rotation around sun")
        sunNode?.addChildNode(marsRotationNode)
        
        // rotate the Jupiter around the sun
        animation = CABasicAnimation(keyPath: "rotation")
        animation.duration = 25.0
        animation.toValue = NSValue(scnVector4: SCNVector4Make(0, 1, 0, Float(Double.pi) * 2))
        animation.repeatCount = Float.greatestFiniteMagnitude
        jupiterRotationNode.addAnimation(animation, forKey: "jupiter rotation around sun")
        sunNode?.addChildNode(jupiterRotationNode)
        
        // rotate the saturn around the sun
        animation = CABasicAnimation(keyPath: "rotation")
        animation.duration = 25.0
        animation.toValue = NSValue(scnVector4: SCNVector4Make(0, 1, 0, Float(Double.pi) * 2))
        animation.repeatCount = Float.greatestFiniteMagnitude
        saturnRotationNode.addAnimation(animation, forKey: "saturn rotation around sun")
        sunNode?.addChildNode(saturnRotationNode)
        
        // rotate the uranus around the sun
        animation = CABasicAnimation(keyPath: "rotation")
        animation.duration = 25.0
        animation.toValue = NSValue(scnVector4: SCNVector4Make(0, 1, 0, Float(Double.pi) * 2))
        animation.repeatCount = Float.greatestFiniteMagnitude
        uranusRotationNode.addAnimation(animation, forKey: "saturn rotation around sun")
        sunNode?.addChildNode(uranusRotationNode)
        
        // rotate the Neptune around the sun
        animation = CABasicAnimation(keyPath: "rotation")
        animation.duration = 25.0
        animation.toValue = NSValue(scnVector4: SCNVector4Make(0, 1, 0, Float(Double.pi) * 2))
        animation.repeatCount = Float.greatestFiniteMagnitude
        neptuneRotationNode.addAnimation(animation, forKey: "neptune rotation around sun")
        sunNode?.addChildNode(neptuneRotationNode)
        
        // rotate the Pluto around the sun
        animation = CABasicAnimation(keyPath: "rotation")
        animation.duration = 25.0
        animation.toValue = NSValue(scnVector4: SCNVector4Make(0, 1, 0, Float(Double.pi) * 2))
        animation.repeatCount = Float.greatestFiniteMagnitude
        plutoRotationNode.addAnimation(animation, forKey: "pluto rotation around sun")
        sunNode?.addChildNode(plutoRotationNode)
        
        addAnimationToSun()
    }
    
    // 给太阳添加运动效果
    func addAnimationToSun() {
        var animation = CABasicAnimation(keyPath: "contentsTransform")
        animation.duration = 10.0
        animation.fromValue = NSValue(caTransform3D: CATransform3DMakeTranslation(0, 0, 0))
        animation.toValue = NSValue(caTransform3D: CATransform3DConcat(CATransform3DMakeTranslation(1, 0, 0), CATransform3DMakeScale(3, 3, 3)))
        animation.repeatCount = Float.greatestFiniteMagnitude
        sunNode?.geometry?.firstMaterial?.diffuse.addAnimation(animation, forKey: "sun-texture")
        
        animation = CABasicAnimation(keyPath: "contentsTransform")
        animation.duration = 30.0
        animation.fromValue = NSValue(caTransform3D: CATransform3DConcat(CATransform3DMakeTranslation(0, 0, 0), CATransform3DMakeScale(5, 5, 5)))
        animation.toValue = NSValue(caTransform3D: CATransform3DConcat(CATransform3DMakeTranslation(1, 0, 0), CATransform3DMakeScale(5, 5, 5)))
        animation.repeatCount = Float.greatestFiniteMagnitude
        sunNode?.geometry?.firstMaterial?.multiply.addAnimation(animation, forKey: "sun-texture2")
        
    }
    
    func addOtherNode() {
        let cloudsNode = SCNNode()
        cloudsNode.geometry = SCNSphere(radius: 0.06)
        earthNode?.addChildNode(cloudsNode)
        
        cloudsNode.opacity = 0.5
        
        // this effect can also be achieved with an image with some transparency set as the "diffuse" property
        cloudsNode.geometry?.firstMaterial?.transparent.contents = "art.scnassets/earth/cloudsTransparency.png"
        cloudsNode.geometry?.firstMaterial?.transparencyMode = .rgbZero
        
        // add a halo to the sun(a simple textured plane that does not write to depth)
        sunHaloNode = SCNNode()
        sunHaloNode?.geometry = SCNPlane(width: 2.5, height: 2.5)
        sunHaloNode?.rotation = SCNVector4Make(1, 0, 0, Float(0 * Double.pi) / 180)
        sunHaloNode?.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/earth/sun-halo.png"
        sunHaloNode?.geometry?.firstMaterial?.lightingModel = .constant
        sunHaloNode?.geometry?.firstMaterial?.writesToDepthBuffer = false
        sunHaloNode?.opacity = 0.2
        sunNode?.addChildNode(sunHaloNode!)
        
        let mercuryOrbit = SCNNode()
        mercuryOrbit.opacity = 0.4
        mercuryOrbit.geometry = SCNBox(width: 0.86, height: 0, length: 0.86, chamferRadius: 0)
        mercuryOrbit.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/earth/orbit.png"
        mercuryOrbit.geometry?.firstMaterial?.diffuse.mipFilter = .linear
        mercuryOrbit.rotation = SCNVector4Make(0, 1, 0, Float(Double.pi)/2)
        mercuryOrbit.geometry?.firstMaterial?.lightingModel = .constant
        sunNode?.addChildNode(mercuryOrbit)
        
        let venusOrbit = SCNNode()
        venusOrbit.opacity = 0.4
        venusOrbit.geometry = SCNBox(width: 1.29, height: 0, length: 1.29, chamferRadius: 0)
        venusOrbit.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/earth/orbit.png"
        venusOrbit.geometry?.firstMaterial?.diffuse.mipFilter = .linear
        venusOrbit.rotation = SCNVector4Make(0, 1, 0, Float(Double.pi)/2)
        venusOrbit.geometry?.firstMaterial?.lightingModel = .constant
        sunNode?.addChildNode(venusOrbit)
        
        let earthOrbit = SCNNode()
        earthOrbit.opacity = 0.4
        earthOrbit.geometry = SCNBox(width: 1.72, height: 0, length: 1.72, chamferRadius: 0)
        earthOrbit.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/earth/orbit.png"
        earthOrbit.geometry?.firstMaterial?.diffuse.mipFilter = .linear
        earthOrbit.rotation = SCNVector4Make(0, 1, 0, Float(Double.pi)/2)
        earthOrbit.geometry?.firstMaterial?.lightingModel = .constant
        sunNode?.addChildNode(earthOrbit)
        
        let marsOrbit = SCNNode()
        marsOrbit.opacity = 0.4
        marsOrbit.geometry = SCNBox(width: 2.14, height: 0, length: 2.14, chamferRadius: 0)
        marsOrbit.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/earth/orbit.png"
        marsOrbit.geometry?.firstMaterial?.diffuse.mipFilter = .linear
        marsOrbit.rotation = SCNVector4Make(0, 1, 0, Float(Double.pi)/2)
        marsOrbit.geometry?.firstMaterial?.lightingModel = .constant
        sunNode?.addChildNode(marsOrbit)
        
        let jupiterOrbit = SCNNode()
        jupiterOrbit.opacity = 0.4
        jupiterOrbit.geometry = SCNBox(width: 2.95, height: 0, length: 2.95, chamferRadius: 0)
        jupiterOrbit.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/earth/orbit.png"
        jupiterOrbit.geometry?.firstMaterial?.diffuse.mipFilter = .linear
        jupiterOrbit.rotation = SCNVector4Make(0, 1, 0, Float(Double.pi)/2)
        jupiterOrbit.geometry?.firstMaterial?.lightingModel = .constant
        sunNode?.addChildNode(jupiterOrbit)
        
        let saturnOrbit = SCNNode()
        saturnOrbit.opacity = 0.4
        saturnOrbit.geometry = SCNBox(width: 2.95, height: 0, length: 2.95, chamferRadius: 0)
        saturnOrbit.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/earth/orbit.png"
        saturnOrbit.geometry?.firstMaterial?.diffuse.mipFilter = .linear
        saturnOrbit.rotation = SCNVector4Make(0, 1, 0, Float(Double.pi)/2)
        saturnOrbit.geometry?.firstMaterial?.lightingModel = .constant
        sunNode?.addChildNode(saturnOrbit)
        
        let uranusOrbit = SCNNode()
        uranusOrbit.opacity = 0.4
        uranusOrbit.geometry = SCNBox(width: 4.19, height: 0, length: 4.19, chamferRadius: 0)
        uranusOrbit.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/earth/orbit.png"
        uranusOrbit.geometry?.firstMaterial?.diffuse.mipFilter = .linear
        uranusOrbit.rotation = SCNVector4Make(0, 1, 0, Float(Double.pi)/2)
        uranusOrbit.geometry?.firstMaterial?.lightingModel = .constant
        sunNode?.addChildNode(uranusOrbit)
        
        let neptuneOrbit = SCNNode()
        neptuneOrbit.opacity = 0.4
        neptuneOrbit.geometry = SCNBox(width: 4.54, height: 0, length: 4.54, chamferRadius: 0)
        neptuneOrbit.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/earth/orbit.png"
        neptuneOrbit.geometry?.firstMaterial?.diffuse.mipFilter = .linear
        neptuneOrbit.rotation = SCNVector4Make(0, 1, 0, Float(Double.pi)/2)
        neptuneOrbit.geometry?.firstMaterial?.lightingModel = .constant
        sunNode?.addChildNode(neptuneOrbit)
        
        let pluteOrbit = SCNNode()
        pluteOrbit.opacity = 0.4
        pluteOrbit.geometry = SCNBox(width: 4.98, height: 0, length: 4.98, chamferRadius: 0)
        pluteOrbit.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/earth/orbit.png"
        pluteOrbit.geometry?.firstMaterial?.diffuse.mipFilter = .linear
        pluteOrbit.rotation = SCNVector4Make(0, 1, 0, Float(Double.pi)/2)
        pluteOrbit.geometry?.firstMaterial?.lightingModel = .constant
        sunNode?.addChildNode(pluteOrbit)
        
    }
    
    func addLight() {
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.color = UIColor.black
        lightNode.light?.type = SCNLight.LightType.omni
        sunNode?.addChildNode(lightNode)
        
        lightNode.light?.attenuationEndDistance = 19
        lightNode.light?.attenuationStartDistance = 21
        
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 1
        
        lightNode.light?.color = UIColor.white
        sunHaloNode?.opacity = 0.5
        
        SCNTransaction.commit()
    }
}





