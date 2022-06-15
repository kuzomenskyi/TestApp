//
//  BaseTableViewCell.swift
//  Challenges
//
//  Created by Sergey Kovalchyk on 1/20/17.
//  Copyright © 2017 Tubik Studio. All rights reserved.
//

import UIKit

protocol CellInterface {
    static var id: String { get }
    static var cellNib: UINib { get }
    static func loadFromNib() -> UIView?
}

extension CellInterface {
    
    static var id: String {
        return String(describing: self).components(separatedBy: "<").first ?? ""
    }
    
    static var cellNib: UINib {
        return UINib(nibName: id, bundle: Bundle.main)
    }

    static func loadFromNib() -> UIView? {
        return cellNib.instantiate(withOwner: nil, options: nil).first as? UIView
    }
}

