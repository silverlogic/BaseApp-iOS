//
//  UserFeedViewController.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/30/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

/// A `BaseViewController` responsible for managing the user feed of the application.
final class UserFeedViewController: BaseViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var collectionView: UICollectionView!
    
    
    // MARK: - Pirvate Instance Attributes
    private var userFeedViewModel = ViewModelsManager.userFeedViewModel()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}


// MARK: - IBActions
private extension UserFeedViewController {
    @IBAction func infoButtonTapped(_ sender: UIBarButtonItem) {
        let popup = ExamplePopupViewController(
            nibName: ExamplePopupViewController.storyboardIdentifier,
            bundle: nil
        )
        showCustomPopup(popup)
    }
}


// MARK: - UICollectionViewDataSource
extension UserFeedViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userFeedViewModel.numberOfUsers.value
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let user = userFeedViewModel.userWithIndex(indexPath.item) else {
            return UICollectionViewCell ()
        }
        let cell: UserCollectionViewCell = collectionView.dequeueCell(forIndexPath: indexPath)
        cell.configure(name: user.fullName)
        return cell
    }
}


// MARK: - UICollectionViewDelegate
extension UserFeedViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        guard let userCell = cell as? UserCollectionViewCell,
              let user = userFeedViewModel.userWithIndex(indexPath.item),
              let url = user.avatarUrl else { return }
        userCell.setImageWithUrl(url)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didEndDisplaying cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        guard let userCell = cell as? UserCollectionViewCell else { return }
        userCell.cancelImageDownload()
    }
}


// MARK: - Private Instance Methods
private extension UserFeedViewController {
    
    /// Sets up the default logic for the view.
    func setup() {
        userFeedViewModel.fetchUsersError.bind { [weak self] (error: BaseError?) in
            guard let strongSelf = self,
                  let userFeedError = error else { return }
            strongSelf.dismissActivityIndicator()
            strongSelf.showDodoAlert(message: userFeedError.errorDescription, alertType: .error)
            strongSelf.collectionView.bottomRefreshControl?.endRefreshing()
        }
        userFeedViewModel.endOfUsers.bind { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.collectionView.bottomRefreshControl?.endRefreshing()
        }
        userFeedViewModel.insertionPositions.bind { [weak self] (indexPaths: [IndexPath]?) in
            guard let strongSelf = self else { return }
            guard let newIndexPaths = indexPaths else {
                strongSelf.collectionView.reloadData()
                strongSelf.dismissActivityIndicator()
                strongSelf.collectionView.animateShow()
                return
            }
            strongSelf.collectionView.insertItems(at: newIndexPaths)
            strongSelf.collectionView.bottomRefreshControl?.endRefreshing()
        }
        collectionView.dataSource = self
        collectionView.delegate = self
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .main
        refreshControl.addTarget(self, action: #selector(fetchNextPageOfUsers), for: .valueChanged)
        refreshControl.triggerVerticalOffset = 50
        collectionView.bottomRefreshControl = refreshControl
        collectionView.animateHide()
        showActivityIndicator()
        userFeedViewModel.fetchUsers(clean: true)
    }
    
    /// Fetches next page of users.
    @objc func fetchNextPageOfUsers() {
        userFeedViewModel.fetchUsers(clean: false)
    }
}
