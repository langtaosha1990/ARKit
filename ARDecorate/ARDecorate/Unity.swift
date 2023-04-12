//
//  Unity.swift
//  ARDecorate
//
//  Created by Gpf 郭 on 2022/8/8.
//

import Foundation
import UIKit

extension UIColor {
    func randomColor() -> UIColor{
        return UIColor(red:CGFloat(arc4random()%256)/255.0,green:CGFloat(arc4random()%256)/255.0,blue: CGFloat(arc4random()%256)/255.0,alpha: 1.0 )
    }
}
