//
//  BaseView.swift
//  TQuizzer
//
//  Created by BAHATTIN KOC on 24.03.2024.
//

import UIKit

class BaseView: UIView {

    // MARK: - OVERRIDE FUNCTIONS

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
}

// MARK: - EXTENSIONS

extension BaseView {
    public class func fromNib<T: UIView>() -> T {
        let name = String(describing: Self.self)
        guard let nib = Bundle(for: Self.self).loadNibNamed(name, owner: nil, options: nil)
        else {
            fatalError("Missing nib-file named: \(name)")
        }
        return nib.first as! T
    }
}
