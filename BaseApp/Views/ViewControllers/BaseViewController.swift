//
//  BaseViewController.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/14/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

/// A base class for having subclasses of `UIViewController`. It also defines and sets default attributes for
/// an instance.
class BaseViewController: UIViewController {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
}
