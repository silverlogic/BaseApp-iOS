//
//  UITableView+Extension.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/17/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

// MARK: - ResuableView
extension UITableViewCell: ResuableView {}
extension UITableViewHeaderFooterView: ResuableView {}


// MARK: - UITableViewCell Registration
extension UITableView {
    func register<T: UITableViewCell>(_: T.Type) {
        register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func register<T: UITableViewCell>(_: T.Type) where T: NibLoadableView {
        register(T.nib, forCellReuseIdentifier: T.reuseIdentifier)
    }
}


// MARK: - UITableViewHeaderFooterView Registration
extension UITableView {
    func register<T: UITableViewHeaderFooterView>(_: T.Type) {
        register(T.self, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }
    
    func register<T: UITableViewHeaderFooterView>(_: T.Type) where T: NibLoadableView {
        register(T.nib, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }
}


// MARK: - UITableViewCell Dequeue
extension UITableView {
    func dequeueCell<T: UITableViewCell>() -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier) as? T else {
            fatalError("Could Not Dequeue Cell With Identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
}


// MARK: - UITableViewHeaderFooterView Dequeue
extension UITableView {
    func dequeueHeaderFooter<T: UITableViewHeaderFooterView>() -> T {
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as? T else {
            fatalError("Could Not Dequeue View With Identifier: \(T.reuseIdentifier)")
        }
        return view
    }
}


// MARK: - Class Attributes
extension UITableView {
    static let footerHeight: CGFloat = 0.01
}
