//
//  MFMailComposeViewController+Extension.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/27/18.
//  Copyright © 2018 SilverLogic. All rights reserved.
//

import Foundation
import MessageUI

// MARK: - Lifecycle
extension MFMailComposeViewController {
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        AppLogger.shared.logMessage("Reverting back to original appearance", for: .warning, debugOnly: true)
        appDelegate.updateAppearance()
    }
}
