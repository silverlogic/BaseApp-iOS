//
//  UIViewController+Extension.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/9/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Dodo
import Foundation
import ImagePicker
import IQKeyboardManager
import KYNavigationProgress
import MessageUI
import PopupDialog
import SVProgressHUD

// MARK: - Hud Icon Type Enum

/// An enum that specifies the type of icon to display in the progress hud.
enum HudIconType {
    case success
    case error
    case info
}


// MARK: - Dodo Alert Type Enum

/// An enum that specifies the type of `Dodo` alert to display in the window.
enum DodoAlertType {
    case success
    case info
    case warning
    case error
}


// MARK: - UIViewController Extensions


// MARK: - Public Instance Methods For SVProgressHUD
extension UIViewController {

    /// Shows the progress hud.
    func showProgresHud() {
        SVProgressHUD.show()
    }

    /// Dismisses the progress hud.
    func dismissProgressHud() {
        SVProgressHUD.dismiss()
    }
    
    /// Displays a message in the hud and then dismisses it after a certain duration.
    ///
    /// - Parameters:
    ///   - message: A `String` representing the message to display in the hud.
    ///   - iconType: A `HudIconType` representing the type of icon to display in the hud.
    ///   - duration: A `Double` indicating how long the hud should stay in the window for. If `nil` is
    ///               passed, two will be used.
    func dismissProgressHudWithMessage(_ message: String, iconType: HudIconType, duration: Double?) {
        var dismissDuration = 2.0
        if let dismissTime = duration {
            dismissDuration = dismissTime
        }
        switch iconType {
        case .success:
            SVProgressHUD.showSuccess(withStatus: message)
        case .error:
            SVProgressHUD.showError(withStatus: message)
        case .info:
            SVProgressHUD.showInfo(withStatus: message)
        }
        SVProgressHUD.dismiss(withDelay: dismissDuration)
    }
}


// MARK: - Public Instance Methods For IQKeyboardManager
extension UIViewController {
    
    /// Enables or disables keyboard management.
    ///
    /// - Note: When leaving or dismissing a view controller, this method should get called to disable
    ///         keyboard managment.
    ///
    /// - Parameter shouldEnable: A `Bool` indicating if keyboard management should be turned on or off.
    func enableKeyboardManagement(_ shouldEnable: Bool) {
        IQKeyboardManager.shared().isEnabled = shouldEnable
    }
}


// MARK: - Public Instance Methods For Dodo
extension UIViewController {
    
    ///  Displays a `Dodo` alert in the main window of the application.
    ///
    /// - Parameters:
    ///   - message: A `String` representing the message to display to the user.
    ///   - alertType: A `DodoAlertType` representing the type of `Dodo` alert to use.
    func showDodoAlert(message: String, alertType: DodoAlertType) {
        switch alertType {
        case .success:
            view.dodo.success(message)
        case .info:
            view.dodo.info(message)
        case .warning:
            view.dodo.warning(message)
        case .error:
            view.dodo.error(message)
        }
    }
}


// MARK: - Public Instance Methods For KYNavigationProgress
extension UIViewController {
    
    /// Sets the progress bar of the navigation controller with a given progress.
    ///
    /// - Parameter progress: A `Float` representing the current progress of a task.
    func setProgressForNavigationBar(progress: Float) {
        navigationController?.setProgress(progress, animated: true)
    }

    /// Animates the finishing of the progress bar in the navigation controller.
    func finishProgressBar() {
        navigationController?.finishProgress()
    }
    
    /// Animates the canceling of the progress bar in the navigation controller.
    func cancelProgressBar() {
        navigationController?.cancelProgress()
    }
}


// MARK: - Public Instance Methods For SCLAlertView
extension UIViewController {

    /// Shows an error alert that auto dismisses.
    ///
    /// - Parameters:
    ///   - title: A `String` representing the title to show in the alert.
    ///   - subTitle: A `String` representing the subtitle to show in the alert.
    func showErrorAlert(title: String, subTitle: String) {
        let alert = BaseAlertViewController(shouldAutoDismiss: true, shouldShowCloseButton: false)
        alert.showErrorAlert(title: title, subtitle: subTitle)
    }
    
    /// Shows an error alert with buttons.
    ///
    /// - Parameters:
    ///   - title: A `String` representing the title to show in the alert.
    ///   - subtitle: A `String` representing the subtitle to show in the alert.
    ///   - buttonAttributes: An `[AlertButtonAttributes]` representing what each button in the alert has for
    ///                       the title and a handler for when the button is tapped.
    ///   - showCancelButton: A `Bool` representing if cancel button shows.
    func showErrorAlert(title: String,
                        subtitle: String,
                        buttonAttributes: [AlertButtonAttributes],
                        _ showCancelButton: Bool = false) {
        let alert = BaseAlertViewController(shouldAutoDismiss: false, shouldShowCloseButton: false)
        buttonAttributes.forEach {
            let handler = $0.handler
            alert.addActionButton(title: $0.title) {
                alert.hideView()
                handler()
            }
        }
        if showCancelButton {
            let cancelTitle = NSLocalizedString("Miscellaneous.Cancel", comment: "Cancel")
            alert.addActionButton(title: cancelTitle) {
                alert.hideView()
            }
        }
        alert.showErrorAlert(title: title, subtitle: subtitle)
    }
    
    /// Shows an info alert that auto dismisses.
    ///
    /// - Parameters:
    ///   - title: A `String` representing the title to show in the alert.
    ///   - subTitle: A `String` representing the subtitle to show in the alert.
    func showInfoAlert(title: String, subTitle: String) {
        let alert = BaseAlertViewController(shouldAutoDismiss: true, shouldShowCloseButton: false)
        alert.showInfoAlert(title: title, subtitle: subTitle)
    }
    
    /// Shows an info alert with optional button.
    ///
    /// - Parameters:
    ///   - title: A `String` representing the title to show in the alert.
    ///   - subTitle: A `String` representing the subtitle to show in the alert.
    ///   - buttonName: A `String` representing the button title.
    ///   - showCancelButton: A `Bool` representing if cancel button shows.
    ///   - handler: A handler, which fires, when button was tapped.
    func showInfoAlert(title: String,
                       subTitle: String,
                       buttonName: String,
                       _ showCancelButton: Bool = false,
                       handler: @escaping () -> Void) {
        let alert = BaseAlertViewController(
            shouldAutoDismiss: false,
            shouldShowCloseButton: false
        )
        alert.addActionButton(title: buttonName) {
            handler()
            alert.hideView()
        }
        if showCancelButton {
            let cancelTitle = NSLocalizedString("Miscellaneous.Cancel", comment: "Cancel")
            alert.addActionButton(title: cancelTitle) {
                alert.hideView()
            }
        }
        alert.showInfoAlert(title: title, subtitle: subTitle)
    }
    
    /// Shows an edit alert.
    ///
    /// - Note: When the user taps on the submit button, validation occurs to ensure each textfield has a
    ///         value before `submitButtonTapped` is invoked. If a textfield is empty, a shake animation will
    ///         occur on the textfield and the alert stays in the view allowing the user to fill all missing
    ///         textfields and then trying again.
    ///
    /// - Warning: If `textFieldAttributes.count` is not greater than zero, the alert will not show.
    ///
    /// - Precondition: `textFieldAttributes.count` should be greater than zero.
    ///
    /// - Parameters:
    ///   - title: A `String` representing the title to show in the alert.
    ///   - subtitle:  A `String` representing the subtitle to show in the alert.
    ///   - textFieldAttributes: An `[AlertTextFieldAttributes]` representing the attributes of each textfield
    ///                          in the alert. The size of the array determines the number of textfields to
    ///                          show in the alert.
    ///   - submitButtonTapped: A closure that gets invoked when the user taps the submit button. A
    ///                         `[String: String]` gets passed that contains the values entered from the
    ///                         textfields. The keys for each value are the `placeholder` property from
    ///                         `AlertTextFieldAttributes` provided in `textFieldAttributes`.
    func showEditAlert(title: String,
                       subtitle: String,
                       textFieldAttributes: [AlertTextFieldAttributes],
                       submitButtonTapped: @escaping (_ enteredValues: [String: String]) -> Void) {
        let alert = BaseAlertViewController(shouldAutoDismiss: false, shouldShowCloseButton: false)
        if textFieldAttributes.isEmpty { return }
        var textFields = [UITextField]()
        textFieldAttributes.forEach { textFields.append(alert.addTextField(textfieldAttributes: $0)) }
        alert.addActionButton(title: NSLocalizedString("Miscellaneous.Submit", comment: "button title")) {
            textFields.forEach { $0.resignFirstResponder() }
            let emptyTextFields = textFields.filter { ($0.text?.isEmpty)! }
            if emptyTextFields.isEmpty {
                emptyTextFields.forEach { $0.shake() }
                return
            }
            var enteredValues = [String: String]()
            textFields.forEach { enteredValues[$0.placeholder!] = $0.text }
            submitButtonTapped(enteredValues)
            alert.hideView()
        }
        alert.addActionButton(title: NSLocalizedString("Miscellaneous.Cancel", comment: "alert title")) {
            textFields.forEach { $0.resignFirstResponder() }
            alert.hideView()
        }
        alert.showEditAlert(title: title, subtitle: subtitle)
    }
}


// MARK: - Public Instance Methods For ImagePicker
extension UIViewController {
    
    /// Internal helper for getting the selected images from the delegate.
    fileprivate static var userSelectedImages: ((_ images: [UIImage]) -> Void)!

    /// Shows the image picker to the user.
    ///
    /// - Parameters:
    ///   - numberOfImages: An `Int` representing the amount of images the user is allowed to select.
    ///   - imagesSelected: A closure that gets invoked when images have been selected. Passes an `[UIImage]`
    ///                     containing the selected images.
    func showImagePicker(numberOfImages: Int, imagesSelected: @escaping (_ images: [UIImage]) -> Void) {
        var imagePickerConfiguration = Configuration()
        imagePickerConfiguration.backgroundColor = .white
        imagePickerConfiguration.gallerySeparatorColor = .main
        imagePickerConfiguration.mainColor = .white
        imagePickerConfiguration.settingsColor = .main
        imagePickerConfiguration.bottomContainerColor = .main
        let doneButtonText = NSLocalizedString("Miscellaneous.Finish", comment: "button title")
        imagePickerConfiguration.doneButtonTitle = doneButtonText
        let noImagesTitle = NSLocalizedString("ImagePicker.NoImages", comment: "no images title")
        imagePickerConfiguration.noImagesTitle = noImagesTitle
        let requestPermissionTitle = NSLocalizedString("ImagePicker.RequestPermission.Title",
                                                       comment: "Request title")
        imagePickerConfiguration.requestPermissionTitle = requestPermissionTitle
        let requestPermissionMessage = NSLocalizedString("ImagePicker.RequestPermission.Message",
                                                         comment: "Request message")
        imagePickerConfiguration.requestPermissionMessage = requestPermissionMessage
        imagePickerConfiguration.recordLocation = false
        imagePickerConfiguration.allowMultiplePhotoSelection = false
        let imagePicker = ImagePickerController(configuration: imagePickerConfiguration)
        imagePicker.delegate = self
        imagePicker.imageLimit = numberOfImages
        present(imagePicker, animated: true, completion: nil)
        UIViewController.userSelectedImages = { (images: [UIImage]) in
            imagesSelected(images)
        }
    }
}


// MARK: - ImagePickerDelegate
extension UIViewController: ImagePickerDelegate {
    public func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    public func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        // No implementation
    }
    
    public func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        UIViewController.userSelectedImages(images)
        imagePicker.dismiss(animated: true, completion: nil)
    }
}


// MARK: - Public Instance Methods For UIActivityIndicatorView
extension UIViewController {

    /// Shows a native activity indicator in the center of the view. This would be used when loading content
    /// for an `UITableView` or `UICollectionView`.
    func showActivityIndicator() {
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicatorView.color = .main
        activityIndicatorView.tag = 99
        activityIndicatorView.center = view.center
        activityIndicatorView.alpha = 0
        activityIndicatorView.startAnimating()
        view.addSubview(activityIndicatorView)
        activityIndicatorView.animateShow()
    }
    
    /// Dismisses the native activity indicator from the center of the view.
    func dismissActivityIndicator() {
        guard let activityIndicatorView = view.subviews.first(where: { $0.tag == 99 }) else { return }
        activityIndicatorView.animateHide()
        activityIndicatorView.removeFromSuperview()
    }
}


// MARK: - Public Instance Methods For PopupDialog
extension UIViewController {
    
    /// Displays a custom popup in the main window of the application.
    ///
    /// - Parameter popup:  A `BasePopupViewController` representing the popup to display.
    func showCustomPopup(_ popup: BasePopupViewController) {
        let popupViewController = PopupDialog(viewController: popup,
                                              transitionStyle: .bounceUp,
                                              gestureDismissal: true,
                                              completion: nil)
        present(popupViewController, animated: true, completion: nil)
    }
}


// MARK: - Public Instance Methods For MFMailComposeViewController
extension UIViewController {

    /// Displays a `MFMailComposeViewController` for sending an email.
    ///
    /// - Parameters:
    ///   - emails: A `[String]` representing the email address to send the message to.
    ///   - subject: A `String` representing the subject of the email.
    ///   - message: A `String` representing the message to place in the email.
    ///   - isHTML: A `Bool` indicating if `message` contains HTML content.
    ///   - failure: A failure that gets invoked when email can't be sent.
    func showMailComposeView(emails: [String],
                             subject: String,
                             message: String,
                             isHTML: Bool,
                             failure: @escaping () -> Void) {
        if MFMailComposeViewController.canSendMail() {
            AppLogger.shared.logMessage(
                "Reverting appearance for MFMailComposeViewController",
                for: .warning,
                debugOnly: true
            )
            UIBarButtonItem.appearance().setTitleTextAttributes(nil, for: .normal)
            UINavigationBar.appearance().titleTextAttributes = nil
            UINavigationBar.appearance().tintColor = nil
            let mailComposeController = MFMailComposeViewController()
            mailComposeController.setToRecipients(emails)
            mailComposeController.setSubject(subject)
            mailComposeController.setMessageBody(message, isHTML: isHTML)
            mailComposeController.mailComposeDelegate = self
            present(mailComposeController, animated: true, completion: nil)
        } else {
            failure()
        }
    }
}


// MARK: - MFMailComposeViewControllerDelegate
extension UIViewController: MFMailComposeViewControllerDelegate {
    public func mailComposeController(_ controller: MFMailComposeViewController,
                                      didFinishWith result: MFMailComposeResult,
                                      error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}


// MARK: - Public Class Methods
extension UIViewController {
    
    /// The storyboard identifier used.
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}
