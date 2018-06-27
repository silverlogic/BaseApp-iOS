//
//  SettingsViewController.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/10/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

/// A `BaseViewController` responsible for managing the settings of the application
final class SettingsViewController: BaseViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    
    
    // MARK: - Private Instance Attributes
    private var settingViewModel = ViewModelsManager.settingViewModel()
    private enum Settings: Int, CaseCount {
        case inviteCode
        case versionNumber
        case termsOfUse
        case privacyPolicy
        case sendFeedback
        case changePassword
        case changeEmail
        case logout
        static let caseCount = Settings.numberOfCases()
    }
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}


// MARK: - Navigation
extension SettingsViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let changePasswordViewController = segue.destination as? ChangePasswordViewController else {
            return
        }
        changePasswordViewController.changePasswordViewModel = ViewModelsManager.changePasswordViewModel()
    }
}


// MARK: - UITableViewDataSource
extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Settings.caseCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Settings(rawValue: indexPath.section) else { return UITableViewCell() }
        let settingCell: SettingsTableViewCell = tableView.dequeueCell()
        let image: UIImage
        let settingName: String
        let optionalInfo: DynamicBinderInterface<String>
        switch section {
        case .inviteCode:
            image = #imageLiteral(resourceName: "icon-invitecode")
            settingName = NSLocalizedString("SettingsViewController.InviteCode", comment: "Setting Label")
            optionalInfo = settingViewModel.inviteCode
        case .versionNumber:
            image = #imageLiteral(resourceName: "icon-version")
            settingName = NSLocalizedString("SettingsViewController.Version", comment: "Setting Label")
            optionalInfo = settingViewModel.applicationVersion
        case .termsOfUse:
            image = #imageLiteral(resourceName: "icon-termsofuse")
            settingName = NSLocalizedString("SettingsViewController.TermsOfUse", comment: "Setting Label")
            optionalInfo = DynamicBinder("").interface
        case .privacyPolicy:
            image = #imageLiteral(resourceName: "icon-privacypolicy")
            settingName = NSLocalizedString("SettingsViewController.PrivacyPolicy", comment: "Setting Label")
            optionalInfo = DynamicBinder("").interface
        case .sendFeedback:
            image = #imageLiteral(resourceName: "icon-sendfeedback")
            settingName = NSLocalizedString("SettingsViewController.SendFeedback", comment: "Setting Label")
            optionalInfo = DynamicBinder("").interface
        case .changePassword:
            image = #imageLiteral(resourceName: "icon-changepassword")
            settingName = NSLocalizedString("SettingsViewController.ChangePassword", comment: "Setting Label")
            optionalInfo = DynamicBinder("").interface
        case .changeEmail:
            image = #imageLiteral(resourceName: "icon-sendfeedback")
            settingName = NSLocalizedString("SettingsViewController.ChangeEmail", comment: "Setting Label")
            optionalInfo = DynamicBinder("").interface
        case .logout:
            image = #imageLiteral(resourceName: "icon-logout")
            settingName = NSLocalizedString("SettingsViewController.Logout", comment: "Setting Label")
            optionalInfo = DynamicBinder("").interface
        }
        settingCell.configure(settingImage: image, settingName: settingName, optionalInfo: optionalInfo)
        return settingCell
    }
}


// MARK: - UITableViewDelegate
extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        guard let section = Settings(rawValue: indexPath.section),
              section == .versionNumber || section == .inviteCode else {
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let section = Settings(rawValue: indexPath.section),
              section == .versionNumber || section == .inviteCode else {
            return indexPath
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let section = Settings(rawValue: indexPath.section) else { return }
        switch section {
        case .inviteCode, .versionNumber: break
        case .termsOfUse:
            // @TODO: Call method on view model for terms of use
            break
        case .privacyPolicy:
            // @TODO: Call method on view model for privacy policy
            break
        case .sendFeedback:
            showMailComposeView(emails: settingViewModel.sendFeedbackEmailAddresses,
                                subject: settingViewModel.sendFeedbackEmailSubject,
                                message: settingViewModel.sendFeedbackEmailMessageBody,
                                isHTML: true,
                                failure: { [weak self] in
                guard let strongSelf = self else { return }
                let title = NSLocalizedString("Mail.Error.Title", comment: "error title")
                let subtitle = NSLocalizedString("Mail.Error.Message", comment: "error title")
                strongSelf.showErrorAlert(title: title,
                                          subTitle: subtitle)
            })
        case .changePassword:
            performSegue(withIdentifier: UIStoryboardSegue.goToChangePasswordSegue, sender: nil)
        case .changeEmail:
            let title = NSLocalizedString("SettingsViewController.ChangeEmail", comment: "subtitle")
            let subtitle = NSLocalizedString(
                "SettingsViewController.ChangeEmailAlert.Message",
                comment: "subtitle"
            )
            let placeholder = NSLocalizedString("Miscellaneous.NewEmail", comment: "placeholder")
            let textFieldAttribute = AlertTextFieldAttributes(
                placeholder: placeholder,
                isSecureTextEntry: false,
                keyboardType: .emailAddress,
                autocorrectionType: .no,
                autocapitalizationType: .none,
                spellCheckingType: .no,
                returnKeyType: .done
            )
            showEditAlert(title: title,
                          subtitle: subtitle,
                          textFieldAttributes: [textFieldAttribute],
                          submitButtonTapped: { [weak self] (enterdValues) in
                let key = NSLocalizedString("Miscellaneous.NewEmail", comment: "placeholder")
                guard let strongSelf = self,
                      let newEmail = enterdValues[key] else { return }
                strongSelf.showProgresHud()
                strongSelf.settingViewModel.changeEmailRequest(newEmail: newEmail)
            })
        case .logout:
            settingViewModel.logout()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SettingsTableViewCell.height()
    }
}


// MARK: - Private Instance Methods
private extension SettingsViewController {
    
    /// Sets up the default logic for the view.
    func setup() {
        settingViewModel.changeEmailRequestError.bind { [weak self] (error: BaseError?) in
            guard let strongSelf = self,
                  let emailRequestError = error else { return }
            strongSelf.dismissProgressHudWithMessage(
                emailRequestError.errorDescription,
                iconType: .error,
                duration: nil
            )
        }
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.reloadData()
    }
}
