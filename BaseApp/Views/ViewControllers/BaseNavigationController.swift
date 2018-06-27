//
//  BaseNavigationController.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/14/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation
import KYNavigationProgress

/// A base class for having subclasses of `UINavigationController`. It also defines and sets default
/// attributes for an instance.
class BaseNavigationController: UINavigationController {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // @TODO: - Uncomment when wanting a image as the background.
//        let navigationBarBackgroundImage = #imageLiteral(resourceName: "background-baseapp")
//        navigationBar.setBackgroundImage(navigationBarBackgroundImage, for: .default)
        navigationBar.barTintColor = .main
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        imageView.image = #imageLiteral(resourceName: "icon-baseappnavigationbar")
        imageView.contentMode = .scaleAspectFit
        navigationBar.topItem?.titleView = imageView
        progressTintColor = .white
    }
}
