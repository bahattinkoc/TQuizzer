//
//  UIView+Extension.swift
//  TQuizzer
//
//  Created by BAHATTIN KOC on 23.03.2024.
//

import UIKit

extension UIView {
    func addShadow(with cornerRadius: CGFloat, borderWidth: CGFloat = 4.0, shadowOffset: CGFloat = 4.0, shadowColor: UIColor = .black) {
        layoutIfNeeded()
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        layer.shadowPath = UIBezierPath(roundedRect: bounds,
                                        cornerRadius: cornerRadius).cgPath
        layer.shadowColor = shadowColor.cgColor
        layer.borderWidth = borderWidth
        layer.borderColor = shadowColor.cgColor
        layer.shadowOpacity = 1.0
        layer.shadowOffset = CGSize(width: shadowOffset, height: shadowOffset)
        layer.shadowRadius = 0.0
        layer.masksToBounds = false
    }
}
