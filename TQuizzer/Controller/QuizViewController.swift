//
//  QuizViewController.swift
//  TQuizzer
//
//  Created by BAHATTIN KOC on 24.03.2024.
//

import UIKit
import FirebaseDatabaseInternal

final class QuizViewController: UIViewController {

    // MARK: - IBOUTLETS

    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var nextButtonContainerView: UIView!
    @IBOutlet private weak var sequenceContainerView: UIView!
    @IBOutlet private weak var sequenceLabel: UILabel!
    @IBOutlet private weak var timerContainerView: UIView!
    @IBOutlet private weak var timerLabel: UILabel!
    @IBOutlet private weak var pointContainerView: UIView!
    @IBOutlet private weak var pointLabel: UILabel!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var questionsStackView: ScrollableStackView!

    // MARK: - PROPERTIES

    var userModel = UserModel()
    private let ref = Database.database().reference()
    private var timer: Timer?
    private var counter: TimeInterval = 0
    private var currentQuestionIndex = 0
    private var selectedAnswerTag = 0
    private var firstRadioButton: TQRadioButton = TQRadioButton.fromNib()
    private var secondRadioButton: TQRadioButton = TQRadioButton.fromNib()
    private var thirdRadioButton: TQRadioButton = TQRadioButton.fromNib()
    private var fourthRadioButton: TQRadioButton = TQRadioButton.fromNib()

    // MARK: - LIFECYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        nextButtonContainerView.addShadow(with: 8.0)
        prepareQuestionsStackView()
        prepareQuestionViews()
        setQuestion(with: currentQuestionIndex)
        prepareHeader()
        startTimer()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let summaryVC = segue.destination as? SummaryViewController {
            if currentQuestionIndex == QuestionHelper.shared.questionList.last?.id ?? 0 {
                summaryVC.userModel = userModel
            }
        }
    }

    // MARK: - PRIVATE FUNCTIONS

    private func prepareQuestionsStackView() {
        questionsStackView.spacing = 16.0
        questionsStackView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        questionsStackView.margins =  UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }

    private func prepareHeader() {
        sequenceContainerView.addShadow(with: sequenceContainerView.frame.height / 2,
                                        borderWidth: 2.0,
                                        shadowOffset: 2.0)
        timerContainerView.addShadow(with: timerContainerView.frame.height / 2,
                                     borderWidth: 2.0,
                                     shadowOffset: 2.0)
        pointContainerView.addShadow(with: pointContainerView.frame.height / 2,
                                     borderWidth: 2.0,
                                     shadowOffset: 2.0)
    }

    private func resetQuestionsShadow() {
        firstRadioButton.addShadow(with: 8.0, shadowColor: .tDarkBlue)
        secondRadioButton.addShadow(with: 8.0, shadowColor: .tDarkPink)
        thirdRadioButton.addShadow(with: 8.0, shadowColor: .tDarkYellow)
        fourthRadioButton.addShadow(with: 8.0, shadowColor: .tDarkGreen)
    }

    private func prepareQuestionViews() {
        questionsStackView.add(view: firstRadioButton)
        questionsStackView.add(view: secondRadioButton)
        questionsStackView.add(view: thirdRadioButton)
        questionsStackView.add(view: fourthRadioButton)
        firstRadioButton.backgroundColor = .tBlue
        firstRadioButton.delegate = self
        secondRadioButton.backgroundColor = .tPink
        secondRadioButton.delegate = self
        thirdRadioButton.backgroundColor = .tYellow
        thirdRadioButton.delegate = self
        fourthRadioButton.backgroundColor = .tGreen
        fourthRadioButton.delegate = self
        resetQuestionsShadow()
    }

    private func setQuestion(with index: Int) {
        guard let questionModel = QuestionHelper.shared.questionList.first(where: { $0.id == index }) else { return }
        questionLabel.text = questionModel.question
        firstRadioButton.set(answer: questionModel.answerA, isSelected: true)
        secondRadioButton.set(answer: questionModel.answerB)
        thirdRadioButton.set(answer: questionModel.answerC)
        fourthRadioButton.set(answer: questionModel.answerD)
        pointLabel.text = "\(questionModel.score) Point"
        sequenceLabel.text = "\(currentQuestionIndex + 1) / \(QuestionHelper.shared.questionList.count)"
        resetQuestionsShadow()
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }

    @objc private func updateTimer() {
        counter += 0.01
        userModel.time = counter
        let minutes = Int(counter) / 60
        let seconds = Int(counter) % 60
        let centiseconds = Int((counter * 100).truncatingRemainder(dividingBy: 100))
        timerLabel.text = String(format: "%02d:%02d:%02d", minutes, seconds, centiseconds)
        timerContainerView.addShadow(with: timerContainerView.frame.height / 2,
                                     borderWidth: 2.0,
                                     shadowOffset: 2.0)
    }

    private func calculateScore() {
        guard let questionModel = QuestionHelper.shared.questionList.first(where: { $0.id == currentQuestionIndex }) else { return }
        if questionModel.correctAnswerId == selectedAnswerTag {
            userModel.score += questionModel.score
            userModel.correctAnswerCount += 1
        } else {
            userModel.incorrectAnswerCount += 1
        }
    }

    private func addData(name: String, score: Int, duration: Double) {
        let dataRef = ref.child("Leaderboard").childByAutoId()
        let data: [String: Any] = [
            "Name": name,
            "Score": score,
            "Time": duration
        ]
        dataRef.setValue(data)
    }

    // MARK: - ACTIONS

    @IBAction private func pressedNextButton(_ sender: Any) {
        if currentQuestionIndex < QuestionHelper.shared.questionList.count - 1 {
            calculateScore()
            currentQuestionIndex += 1
            setQuestion(with: currentQuestionIndex)
            prepareHeader()
            if currentQuestionIndex == QuestionHelper.shared.questionList.last?.id ?? 0 {
                nextButton.setAttributedTitle(NSAttributedString(string: "FINISH"), for: .normal)
            }
        } else {
            calculateScore()
            addData(name: userModel.name, score: userModel.score, duration: userModel.time.rounded(4))
            performSegue(withIdentifier: "segueFinish", sender: nil)
        }
    }
}

extension QuizViewController: TQRadioButtonDelegate {
    func pressedRadioButton(with tag: Int) {
        firstRadioButton.setState(false)
        secondRadioButton.setState(false)
        thirdRadioButton.setState(false)
        fourthRadioButton.setState(false)
        selectedAnswerTag = tag
    }
}
