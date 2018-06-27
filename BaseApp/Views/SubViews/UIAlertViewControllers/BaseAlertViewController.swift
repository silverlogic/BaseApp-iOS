//
//  BaseAlertViewController.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/14/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation
import SCLAlertView

// MARK: - BaseAlertViewController

/// A base class for having subclasses of `SCLAlertView`. It also defines and sets default attributes for an
/// instance.
class BaseAlertViewController: SCLAlertView {
    
    // MARK: - Attributes
    private let titleFont: UIFont = .mainRegularMedium
    private let defaultFont: UIFont = .mainRegularSmall
    private let cornerRadius: CGFloat = 3.0
    private let borderColor = UIColor.lightGray.cgColor
    private let borderWidth: CGFloat = 1.0
    private let placeHolderAndTintTextColor = UIColor.darkGray
    private let noDurationInterval: TimeInterval = 0.0
    private var defaultDurationInterval: TimeInterval = 2.0
    private var shouldAutoDismiss = false
    
    
    // MARK: Getters & Setters
    var durationInterval: TimeInterval {
        get {
            return defaultDurationInterval
        }
        set {
            defaultDurationInterval = newValue
        }
    }
    
    
    // MARK: - Initializers
    
    /// Initializes an instance of `BaseAlertViewController`.
    ///
    /// - Parameters:
    ///   - shouldAutoDismiss: A `Bool` that determines if the instance will dismiss on its own.
    ///   - shouldShowCloseButton: A `Bool` that determines if  the instance will show a dismiss button on
    ///                            its own.
    init(shouldAutoDismiss: Bool, shouldShowCloseButton: Bool) {
        let appearance = SCLAppearance(
            kTitleFont: titleFont,
            kTextFont: defaultFont,
            kButtonFont: defaultFont,
            showCloseButton: shouldShowCloseButton,
            shouldAutoDismiss: shouldAutoDismiss,
            titleColor: UIColor.black
        )
        self.shouldAutoDismiss = shouldAutoDismiss
        super.init(appearance: appearance)
    }
    
    /// Required initializer.
    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /// Required initializer.
    @available(*, unavailable) required init() {
        super.init()
    }
}


// MARK: - Public Instance Methods
extension BaseAlertViewController {
    
    /// Adds a textfield to an instance.
    ///
    /// - Parameter textfieldAttributes: An `AlertTextFieldAttributes` containing the attributes that the
    ///                                  textfield will have.
    /// - Returns: An `UITextField` representing the textfield added.
    func addTextField(textfieldAttributes: AlertTextFieldAttributes) -> UITextField {
        let textField = super.addTextField(title)
        textField.layer.cornerRadius = cornerRadius
        textField.layer.borderColor = borderColor
        textField.layer.borderWidth = borderWidth
        textField.textColor = UIColor.black
        textField.tintColor = UIColor.black
        textField.autocorrectionType = textfieldAttributes.autocorrectionType
        textField.autocapitalizationType = textfieldAttributes.autocapitalizationType
        textField.isSecureTextEntry = textfieldAttributes.isSecureTextEntry
        textField.keyboardType = textfieldAttributes.keyboardType
        textField.spellCheckingType = textfieldAttributes.spellCheckingType
        textField.returnKeyType = textfieldAttributes.returnKeyType
        textField.keyboardAppearance = StyleConstants.keyboardStyle
        let placeholderText = textfieldAttributes.placeholder
        let attributes: [NSAttributedStringKey: Any] = [.foregroundColor: placeHolderAndTintTextColor]
        textField.attributedPlaceholder = NSAttributedString(string: placeholderText,
                                                             attributes: attributes)
        return textField
    }
    
    /// Adds a button to an instance.
    ///
    /// - Parameters:
    ///   - title: A `String` representing the text that will be displayed in the alert.
    ///   - buttonTapped: A `() -> Void` that gets invoked when the user taps on the button.
    func addActionButton(title: String, buttonTapped: @escaping () -> Void) {
        _ = addButton(
            title,
            backgroundColor: .main,
            textColor: .white,
            showDurationStatus: false,
            action: buttonTapped
        )
    }
    
    /// Displays an instance in an edit style.
    ///
    /// - Parameters:
    ///   - title: A `String` representing the title to show.
    ///   - subtitle:  A `String` representing the subtitle to show.
    func showEditAlert(title: String, subtitle: String) {
        _ = showEdit(
            title,
            subTitle: subtitle,
            closeButtonTitle: nil,
            duration: noDurationInterval,
            colorStyle: UIColor.mainHexValue,
            colorTextButton: 0xFFFFFF,
            circleIconImage: nil,
            animationStyle: .topToBottom
        )
    }
    
    /// Displays an instance in an error style.
    ///
    /// - Parameters:
    ///   - title: A `String` representing the title to show.
    ///   - subtitle: A `String` representing the subtitle to show.
    func showErrorAlert(title: String, subtitle: String) {
        let duration = shouldAutoDismiss ? defaultDurationInterval : noDurationInterval
        _ = showError(
            title,
            subTitle: subtitle,
            closeButtonTitle: NSLocalizedString("Alert.Close", comment: "close"),
            duration: duration,
            colorStyle: UIColor.mainHexValue,
            colorTextButton: 0xFFFFFF,
            circleIconImage: nil,
            animationStyle: .topToBottom
        )
    }
    
    /// Displays an instance in an info style.
    ///
    /// - Parameters:
    ///   - title: A `String` representing the title to show.
    ///   - subtitle:  A `String` representing the subtitle to show.
    func showInfoAlert(title: String, subtitle: String) {
        let duration = shouldAutoDismiss ? defaultDurationInterval : noDurationInterval
        _ = showInfo(
            title,
            subTitle: subtitle,
            closeButtonTitle: NSLocalizedString("Alert.Close", comment: "close"),
            duration: duration,
            colorStyle: UIColor.mainHexValue,
            colorTextButton: 0xFFFFFF,
            circleIconImage: nil,
            animationStyle: .topToBottom
        )
    }
}


// MARK: - AlertTextFieldAttributes

/// A struct that encapsulates info needed for creating a textfield in an `SCLAlertView` alert.
struct AlertTextFieldAttributes {
    
    // MARK: - Public Attributes
    let placeholder: String
    let isSecureTextEntry: Bool
    let keyboardType: UIKeyboardType
    let autocorrectionType: UITextAutocorrectionType
    let autocapitalizationType: UITextAutocapitalizationType
    let spellCheckingType: UITextSpellCheckingType
    let returnKeyType: UIReturnKeyType
    
    
    // MARK: - Initializers
    
    /// Initializes an instance of `AlertTextFieldAttributes`.
    ///
    /// - Parameters:
    ///   - placeholder: A `String` representing the placeholder text in the textfield.
    ///   - isSecureTextEntry: A `Bool` indicating if the text should be shown or not.
    ///   - keyboardType: An `UIKeyboardType` representing the type of keyboard to use.
    ///   - autocorrectionType: An `UITextAutocorrectionType` that determines the type of auto correction the
    ///                          textfield will have.
    ///   - autocapitalizationType: An `UITextAutocapitalizationType` that determines the type of auto
    ///                             capitalization the textfield will have.
    ///   - spellCheckingType: An `UITextSpellCheckingType` representing the type of spell check the textfield
    ///                        will use.
    ///   - returnKeyType: An `UIReturnKeyType` representing the type of return key to use for the textfield.
    init(placeholder: String,
         isSecureTextEntry: Bool,
         keyboardType: UIKeyboardType,
         autocorrectionType: UITextAutocorrectionType,
         autocapitalizationType: UITextAutocapitalizationType,
         spellCheckingType: UITextSpellCheckingType,
         returnKeyType: UIReturnKeyType) {
        self.placeholder = placeholder
        self.isSecureTextEntry = isSecureTextEntry
        self.keyboardType = keyboardType
        self.autocorrectionType = autocorrectionType
        self.autocapitalizationType = autocapitalizationType
        self.spellCheckingType = spellCheckingType
        self.returnKeyType = returnKeyType
    }
}


// MARK: - AlertButtonAttributes

/// A struct that encapsulates info needed for creating a button in an `SCLAlertView` alert.
struct AlertButtonAttributes {
    
    // MARK: - Public Attributes
    let title: String
    let handler: () -> Void
    
    
    // MARK: - Initializers
    
    /// Initializes an instance of `AlertButtonAtributes`.
    ///
    /// - Parameters:
    ///   - title: A `String` representing the text to put in the button.
    ///   - handler: A closure that gets fired when the button was tapped.
    init(title: String, handler: @escaping () -> Void) {
        self.title = title
        self.handler = handler
    }
}
