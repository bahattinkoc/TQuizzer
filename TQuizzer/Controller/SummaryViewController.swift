//
//  SummaryViewController.swift
//  TQuizzer
//
//  Created by BAHATTIN KOC on 24.03.2024.
//

import UIKit

final class SummaryViewController: UIViewController {

    // MARK: - IBOUTLETS

    @IBOutlet private weak var correctContainerView: UIView!
    @IBOutlet private weak var incorrectContainerView: UIView!
    @IBOutlet private weak var timeContainerView: UIView!
    @IBOutlet private weak var totalScoreContainerView: UIView!
    @IBOutlet private weak var leaderboardContainerView: UIView!
    @IBOutlet private weak var correctLabel: UILabel!
    @IBOutlet private weak var incorrectLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var totalLabel: UILabel!

    // MARK: - PROPERTIES

    var userModel = UserModel()

    // MARK: - LIFECYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareShadows()
        correctLabel.text = "\(userModel.correctAnswerCount)"
        incorrectLabel.text = "\(userModel.incorrectAnswerCount)"
        timeLabel.text = "\(userModel.time.rounded(4))"
        totalLabel.text = "\(userModel.score)"
    }

    // MARK: - PRIVATE FUNCTIONS

    private func prepareShadows() {
        correctContainerView.addShadow(with: 8.0, shadowColor: .tDarkBlue)
        incorrectContainerView.addShadow(with: 8.0, shadowColor: .tDarkPink)
        timeContainerView.addShadow(with: 8.0, shadowColor: .tDarkGreen)
        totalScoreContainerView.addShadow(with: 8.0, shadowColor: .tDarkYellow)
        leaderboardContainerView.addShadow(with: 8.0)
    }
}
