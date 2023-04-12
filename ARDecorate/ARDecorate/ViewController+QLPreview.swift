//
//  ViewController+QLPreview.swift
//  ARDecorate
//
//  Created by Gpf 郭 on 2022/8/8.
//

import UIKit
import QuickLook
import ARKit

extension ViewController: QLPreviewControllerDataSource {
    

    func numberOfPreviewItems(in controller: QLPreviewController) -> Int { return 1 }

    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        let name = dataArray[selestedIndex]
        guard let filePath = Bundle.main.url(forResource: name, withExtension: "usdz") else {fatalError("无法加载模型")}
        let item = ARQuickLookPreviewItem(fileAt: filePath)
        item.allowsContentScaling = true
        item.canonicalWebPageURL = URL(string: "https://www.example.com/example.usdz")
        return item
    }
    
}
