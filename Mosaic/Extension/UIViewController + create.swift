//
//  UIViewController + create.swift
//  Mosaic
//
//  Created by 이광용 on 2018. 8. 20..
//  Copyright © 2018년 Zedd. All rights reserved.
//

import Foundation
import UIKit
extension UIViewController {
    static func create(storyboard: String) -> UIViewController {
        return UIStoryboard(name: storyboard, bundle: nil).instantiateViewController(withIdentifier: classNameToString)
    }
}
