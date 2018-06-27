//
//  BasePopupViewController.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 4/17/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

/// A base class for having subclasses of `UIViewController`. It also defines and sets default attributes for
/// an instance. These would be used when wanting to display a custom popup without much configutation of the
/// popup's lifecycle.
class BasePopupViewController: UIViewController {
    
    // MARK: - Public Instance Attributes
    var userTappedOnDismissButton: (() -> Void)?
    
    
    // MARK: - IBActions
    @IBAction private func dismissButtonTapped(_ sender: BaseButton) {
        dismiss(animated: true) { [weak self] in
            guard let strongSelf = self,
                  let closure = strongSelf.userTappedOnDismissButton else { return }
            closure()
        }
    }
}
