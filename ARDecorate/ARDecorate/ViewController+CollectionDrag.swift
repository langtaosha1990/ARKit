//
//  ViewController+CollectionDrag.swift
//  ARDecorate
//
//  Created by Gpf 郭 on 2022/8/7.
//

import Foundation
import UIKit
import MobileCoreServices
import Combine

extension ViewController: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let string = dataArray[indexPath.row]
        guard let data = string.data(using: .utf8) else { return [] }
        let itemProvider = NSItemProvider(item: data as NSData, typeIdentifier: kUTTypePlainText as String)
        return [UIDragItem(itemProvider: itemProvider)]
    }
}

