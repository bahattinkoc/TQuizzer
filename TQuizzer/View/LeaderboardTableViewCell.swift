//
//  LeaderboardTableViewCell.swift
//  TQuizzer
//
//  Created by BAHATTIN KOC on 25.03.2024.
//

import UIKit

final class LeaderboardTableViewCell: UITableViewCell {

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!

    func set(player: Player, color: UIColor) {
        containerView.backgroundColor = color
        containerView.addShadow(with: 8.0)
        nameLabel.text = player.name
        scoreLabel.text = "\(player.score)"
        timeLabel.text = "\(player.time)"
    }
}
