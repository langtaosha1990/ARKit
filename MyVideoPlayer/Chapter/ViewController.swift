//
//  ViewController.swift
//  Chapter
//
//  Created by Gpf 郭 on 2022/6/15.
//

import UIKit
import RealityKit
import ARKit
import Combine
import AVFoundation
import ReplayKit

class ViewController: UIViewController, ARSessionDelegate {
    
    
    @IBOutlet weak var arView: ARView!
    var videoPlayController : VideoPlayController!
    var players: [VideoPlayController] = []
    var play = false;
    
    var recorder: RPScreenRecorder!
    var isRecording: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = .vertical
        arView.session.run(config, options:[ ])
        
        arView.session.delegate = self
        recorder = RPScreenRecorder.shared()
        
    }

    @IBAction func playBtn(_ sender: Any) {
        playOrPause()
    }
    
    @IBAction func replayBtn(_ sender: Any) {
        reset()
    }
    
    @IBAction func transcribeBtn(_ sender: Any) {
        if isRecording {
            isRecording = false
            recorder.stopRecording { (viewController, error) in
                if let error = error {
                    print("Error finishing recording: \(error)")
                } else if let viewController = viewController {
                    viewController.previewControllerDelegate = self
                    self.present(viewController, animated: true, completion: nil)
                } else {
                    fatalError("Didn't get an error or a view controller?")
                }
            }
        } else {
            isRecording = true
            recorder.startRecording { (error) in
                if let error = error {
                    print("Error starting recording\(error)")
                } else {
                    print("Recording started successfully")
                }
            }
        }
    }
    
    @IBAction func addScreen(_ sender: Any) {
        let translation = self.arView.cameraTransform.translation
        guard let player = createPlane(videoName: "output") else {
            return
        }
        
        let planeMaterial = player.material!
        let planeAnchor = AnchorEntity(plane: .vertical)
        let planeMesh = MeshResource.generatePlane(width: 0.5, depth: 0.2)
        let planeEntity = ModelEntity(mesh: planeMesh, materials: [planeMaterial])
        planeEntity.generateCollisionShapes(recursive: false)
        planeEntity.transform.translation = translation
        planeAnchor.addChild(planeEntity)
        self.arView.scene.addAnchor(planeAnchor)
        self.arView.installGestures(.all, for: planeEntity)
        players.append(player)
    }
    
    
    
    func createPlane(isLoop: Bool = false, videoName: String) -> VideoPlayController? {
        guard let player = VideoPlayController(videoName, withExtension: "mp4", useLooper: false) else {
            return nil
        }
        
        return player
    }
    
    func playOrPause() {
        play = !play
        guard let currentPlayer = players.first else {
            return
        }
        currentPlayer.enablePlayPause(play)
    }
    
    func reset() {
        for player in players {
            player.reset()
            player.enablePlayPause(true)
        }
        
    }
    

    
    
}

extension ViewController : RPPreviewViewControllerDelegate {
    
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

