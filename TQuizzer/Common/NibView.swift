//
//  NibView.swift
//  TQuizzer
//
//  Created by BAHATTIN KOC on 23.03.2024.
//

import UIKit

class NibView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureNibView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureNibView()
    }

    func loadViewFromNib() -> UIView? {
        let nibName = String(describing: Self.self)
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self).first as? UIView
    }

    func configureNibView() {
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        addSubview(view)
    }
}
