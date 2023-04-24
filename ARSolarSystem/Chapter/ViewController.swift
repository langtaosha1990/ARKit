//
//  ViewController.swift
//  Chapter
//
//  Created by Gpf 郭 on 2022/6/15.
//

import UIKit
import SceneKit
import ReplayKit

class ViewController: UIViewController {
    
    var isRecording: Bool = false
    var previewViewController: UIViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let vc = SolarSystemController()
        self.navigationController?.pushViewController(vc, animated: true)
        recording()
        DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
            self.recording()
        }
    }
    
    func recording() {
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

