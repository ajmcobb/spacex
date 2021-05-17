//
//  UITableViewExtensions.swift
//  SpaceX
//
//  Created by Aurelien Cobb on 15/05/2021.
//

import UIKit

protocol Reusable: AnyObject {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}

extension UITableViewCell: Reusable {}

extension UITableView {
    
    @discardableResult
    final func register<T: UITableViewCell>(withClass cellClass: T.Type) -> UITableView {
        register(cellClass, forCellReuseIdentifier: cellClass.reuseIdentifier)
        return self
    }
    
    final func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath,
                                                       configure: ((T) -> Void)? = nil) -> T {
        let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T ??
            T(style: .default, reuseIdentifier: T.reuseIdentifier)
        configure?(cell)
        return cell
    }
}
