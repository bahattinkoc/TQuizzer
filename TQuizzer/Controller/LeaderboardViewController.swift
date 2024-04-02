//
//  LeaderboardViewController.swift
//  TQuizzer
//
//  Created by BAHATTIN KOC on 25.03.2024.
//

import UIKit
import FirebaseDatabaseInternal

struct Player {
    var name: String
    var score: Int
    var time: Double
}

final class LeaderboardViewController: UIViewController {

    // MARK: - IBOUTLETS

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var tryAgainButtonContainerView: UIView!

    // MARK: - PROPERTIES

    private let ref = Database.database().reference().child("Leaderboard")
    var playerList = [Player]()

    // MARK: - OVERRIDE FUNCTIONS

    override func viewDidLoad() {
        super.viewDidLoad()
        tryAgainButtonContainerView.addShadow(with: 8.0)
        tableView.register(UINib(nibName: "LeaderboardTableViewCell", bundle: nil), forCellReuseIdentifier: "LeaderboardTableViewCell")
        tableView.showsVerticalScrollIndicator = false
        fetchData()
    }

    // MARK: - PRIVATE FUNCTIONS

    private func fetchData() {
        ref.observe(.value, with: { [weak self] snapshot in
            guard let self else { return }
            playerList.removeAll()
            for case let child as DataSnapshot in snapshot.children {
                if let playerData = child.value as? [String: Any] {
                    if let playerName = playerData["Name"] as? String,
                       let playerScore = playerData["Score"] as? Int,
                       let playerDuration = playerData["Time"] as? Double {
                        let player = Player(name: playerName, score: playerScore, time: playerDuration)
                        playerList.append(player)
                    }
                }
            }
            playerList.sort { $0.score == $1.score ? $0.time < $1.time : $0.score > $1.score }
            tableView.reloadData()
        })
    }
}

// MARK: - EXTENSIONS

extension LeaderboardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        playerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderboardTableViewCell", for: indexPath) as? LeaderboardTableViewCell,
              let player = playerList.get(at: indexPath.row) else { return .init() }
        if indexPath.row == 0 {
            cell.set(player: player, color: .tYellow)
        } else if indexPath.row == 1 {
            cell.set(player: player, color: .tPink)
        } else if indexPath.row == 2 {
            cell.set(player: player, color: .tGreen)
        } else {
            cell.set(player: player, color: .white)
        }
        return cell
    }
}

extension LeaderboardViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80.0
    }
}
