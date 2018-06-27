//
//  ProfileViewController.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/24/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

/// A `BaseViewController` responsible for handling interaction from the profile view of a user.
final class ProfileViewController: BaseViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    
    
    // MARK: - Public Instance Attributes
    var hideEditButton = false
    var profileViewModel: ProfileViewModelProtocol? {
        didSet {
            setup()
        }
    }
    
    
    // MARK: - Private Instance Attributes
    private enum Profile: Int, CaseCount {
        case image
        case info
        static let caseCount = Profile.numberOfCases()
    }
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}


// MARK: - Navigation
extension ProfileViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let updateProfileViewController = segue.destination as? UpdateProfileViewController else {
            return
        }
        updateProfileViewController.profileViewModel = profileViewModel
    }
}


// MARK: - IBActions
private extension ProfileViewController {
    @IBAction func editProfileButtonTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: UIStoryboardSegue.goToUpdateProfileSegue, sender: nil)
    }
}


// MARK: - UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Profile.caseCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Profile(rawValue: indexPath.section) else { return UITableViewCell() }
        switch section {
        case .image:
            let profileImageCell: ProfileImageTableViewCell = tableView.dequeueCell()
            return profileImageCell
        case .info:
            let profileInfoCell: ProfileInfoTableViewCell = tableView.dequeueCell()
            profileInfoCell.configure(
                fullName: (profileViewModel?.fullName)!,
                email: (profileViewModel?.email)!
            )
            return profileInfoCell
        }
    }
}


// MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        guard let section = Profile(rawValue: indexPath.section), section == .image,
              let url = profileViewModel?.avatar.value,
              let profileImageCell = cell as? ProfileImageTableViewCell else { return }
        profileImageCell.setImageWithUrl(url)
    }
    
    func tableView(_ tableView: UITableView,
                   didEndDisplaying cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        guard let section = Profile(rawValue: indexPath.section), section == .image,
              let profileImageCell = cell as? ProfileImageTableViewCell else { return }
        profileImageCell.cancelImageDownload()
    }
}


// MARK: - Private Instance Methods
private extension ProfileViewController {
    
    /// Sets up the default logic for the view.
    func setup() {
        if !isViewLoaded { return }
        guard let viewModel = profileViewModel else { return }
        viewModel.avatar.bindAndFire { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.tableView.beginUpdates()
            let indexPath = IndexPath(row: 0, section: Profile.image.rawValue)
            strongSelf.tableView.reloadRows(at: [indexPath], with: .none)
            strongSelf.tableView.endUpdates()
        }
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
        if hideEditButton {
            navigationItem.rightBarButtonItem = nil
        }
    }
}
