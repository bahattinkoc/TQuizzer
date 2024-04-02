//
//  TQRadioButton.swift
//  TQuizzer
//
//  Created by BAHATTIN KOC on 24.03.2024.
//

import UIKit

protocol TQRadioButtonDelegate: AnyObject {
    func pressedRadioButton(with tag: Int)
}

final class TQRadioButton: BaseView {

    // MARK: - IBOUTLETS

    @IBOutlet private weak var outerView: UIView!
    @IBOutlet private weak var innerView: UIView!
    @IBOutlet private weak var questionLabel: UILabel!

    // MARK: - PROPERTIES

    var isSelected = false
    weak var delegate: TQRadioButtonDelegate?

    // MARK: - OVERRIDE FUNCTIONS

    override func awakeFromNib() {
        super.awakeFromNib()
        outerView.layer.borderWidth = 2.0
        outerView.layer.borderColor = UIColor.black.cgColor
        outerView.layer.cornerRadius = outerView.frame.height / 2
        innerView.layer.cornerRadius = innerView.frame.height / 2
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pressedView)))
    }

    // MARK: - INTERNAL FUNCTIONS

    func setState(_ state: Bool) {
        isSelected = state
        innerView.backgroundColor = state ? .black : .clear
    }

    func set(answer: Answer, isSelected: Bool = false) {
        setState(isSelected)
        questionLabel.text = answer.answer
        tag = answer.id
    }

    // MARK: - PRIVATE FUNCTIONS

    @objc private func pressedView() {
        delegate?.pressedRadioButton(with: tag)
        setState(true)
    }
}
