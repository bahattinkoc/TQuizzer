//
//  EnterViewController.swift
//  TQuizzer
//
//  Created by BAHATTIN KOC on 23.03.2024.
//

import UIKit
import FirebaseDatabaseInternal

final class EnterViewController: UIViewController {

    // MARK: - IBOUTLETS

    @IBOutlet private weak var buttonContainerView: UIView!
    @IBOutlet private weak var errorContainerView: UIView!
    @IBOutlet private weak var errorLabel: UITextField!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var scrollableStackView: ScrollableStackView!

    // MARK: - PROPERTIES

    private var isActive = false
    private var isQuestionsFetched = false
    private var nameTextFieldContainerView = UIView()
    private var nameTextField = UITextField()
    private var rulesLabel = UILabel()
    private var ruleContainerView = UIView()

    // MARK: - LIFECYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        prepareFirebase()
        fetchQuestions()
        buttonContainerView.addShadow(with: 8.0)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        scrollableStackView.spacing = 16.0
        scrollableStackView.margins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        prepareNameTextFieldView()
        prepareRuleView()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let quizVC = segue.destination as? QuizViewController {
            quizVC.userModel = UserModel(name: nameTextField.text ?? "")
        }
    }

    // MARK: - PRIVATE FUNCTIONS

    private func prepareNameTextFieldView() {
        scrollableStackView.add(view: nameTextFieldContainerView)
        nameTextFieldContainerView.addSubview(nameTextField)
        nameTextField.placeholder = "Enter Your Name"
        nameTextField.delegate = self
        nameTextField.font = UIFont(name: "Menlo-Bold", size: 17)
        nameTextFieldContainerView.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        addConstraints([
            nameTextFieldContainerView.heightAnchor.constraint(equalToConstant: 56.0),
            nameTextField.topAnchor.constraint(equalTo: nameTextFieldContainerView.topAnchor, constant: 8.0),
            nameTextField.bottomAnchor.constraint(equalTo: nameTextFieldContainerView.bottomAnchor, constant: -8.0),
            nameTextField.leadingAnchor.constraint(equalTo: nameTextFieldContainerView.leadingAnchor, constant: 16.0),
            nameTextField.trailingAnchor.constraint(equalTo: nameTextFieldContainerView.trailingAnchor, constant: -16.0)
        ])
        nameTextFieldContainerView.backgroundColor = .white
        nameTextFieldContainerView.layoutIfNeeded()
        nameTextFieldContainerView.addShadow(with: 8.0)
    }

    private func prepareRuleView() {
        scrollableStackView.add(view: ruleContainerView)
        rulesLabel.numberOfLines = 0
        rulesLabel.text = "‣ Each question carries its own score.\n\n‣ Your time begins as soon as you start the quiz.\n\n‣ Your ranking will be determined by the number of correct answers and the time taken.\n\n‣ Once you move to the next question, you cannot go back to previous questions."
        rulesLabel.font = UIFont(name: "Menlo-Italic", size: 11)
        ruleContainerView.addSubview(rulesLabel)
        rulesLabel.translatesAutoresizingMaskIntoConstraints = false
        ruleContainerView.translatesAutoresizingMaskIntoConstraints = false
        addConstraints([
            rulesLabel.topAnchor.constraint(equalTo: ruleContainerView.topAnchor, constant: 16.0),
            rulesLabel.leadingAnchor.constraint(equalTo: ruleContainerView.leadingAnchor, constant: 16.0),
            rulesLabel.trailingAnchor.constraint(equalTo: ruleContainerView.trailingAnchor, constant: -16.0),
            rulesLabel.bottomAnchor.constraint(equalTo: ruleContainerView.bottomAnchor, constant: -16.0),
            ruleContainerView.heightAnchor.constraint(equalTo: rulesLabel.heightAnchor, constant: 30.0)
        ])
        ruleContainerView.backgroundColor = .systemOrange
        ruleContainerView.layoutIfNeeded()
        ruleContainerView.addShadow(with: 4.0)
        errorContainerView.addShadow(with: 8.0)
    }

    private func prepareFirebase() {
        let ref = Database.database().reference().child("/isActive")
        ref.observe(.value, with: { [weak self] snapshot in
            if let self, let isActive = snapshot.value as? Bool {
                self.isActive = isActive
                self.buttonContainerView.backgroundColor = isActive ? .tSecondary : .gray400
            }
        })
    }

    private func fetchQuestions() {
        let ref = Database.database().reference().child("Questions")
        ref.observeSingleEvent(of: .value, with: { [weak self] snapshot in
            guard let self else { return }
            var questionList = [QuestionModel]()
            for case let child as DataSnapshot in snapshot.children {
                if let questionData = child.value as? [String: Any],
                   let model = self.createQuestionModel(questionData: questionData) {
                    questionList.append(model)
                }
            }
            if !questionList.isEmpty {
                QuestionHelper.shared.questionList = questionList
            }
            self.isQuestionsFetched = true
        })
    }

    private func createQuestionModel(questionData: [String: Any]) -> QuestionModel? {
        if let id = questionData["id"] as? Int,
           let question = questionData["question"] as? String,
           let correctAnswerId = questionData["correctAnswerId"] as? Int,
           let answerAData = questionData["answerA"] as? [String: Any],
           let answerAId = answerAData["id"] as? Int,
           let answerA = answerAData["answer"] as? String,
           let answerBData = questionData["answerB"] as? [String: Any],
           let answerBId = answerBData["id"] as? Int,
           let answerB = answerBData["answer"] as? String,
           let answerCData = questionData["answerC"] as? [String: Any],
           let answerCId = answerCData["id"] as? Int,
           let answerC = answerCData["answer"] as? String,
           let answerDData = questionData["answerD"] as? [String: Any],
           let answerDId = answerDData["id"] as? Int,
           let answerD = answerDData["answer"] as? String,
           let score = questionData["score"] as? Int {
            let answerA = Answer(id: answerAId, answer: answerA)
            let answerB = Answer(id: answerBId, answer: answerB)
            let answerC = Answer(id: answerCId, answer: answerC)
            let answerD = Answer(id: answerDId, answer: answerD)
            let questionModel = QuestionModel(id: id,
                                              question: question,
                                              correctAnswerId: correctAnswerId,
                                              answerA: answerA,
                                              answerB: answerB,
                                              answerC: answerC,
                                              answerD: answerD,
                                              score: score)
            return questionModel
        }
        return nil
    }

    private func setErrorContainerView(text: String = "", isHidden: Bool) {
        if isHidden {
            UIView.animate(withDuration: 0.3, animations: {
                self.errorContainerView.alpha = 0.0
            }) { _ in
                self.errorContainerView.isHidden = true
                self.errorLabel.text = ""
            }
        } else {
            errorContainerView.isHidden = isHidden
            errorLabel.text = text
            UIView.animate(withDuration: 0.3, animations: {
                self.errorContainerView.alpha = 1.0
            })
        }
    }

    // MARK: - ACTIONS

    @objc private func hideKeyboard() {
        view.endEditing(true)
    }

    @IBAction private func pressedCloseErrorButton(_ sender: Any) {
        setErrorContainerView(isHidden: true)
    }

    @IBAction private func pressedStartButton(_ sender: Any) {
        guard let name = nameTextField.text, !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            setErrorContainerView(text: "Please enter a valid name!", isHidden: false)
            return
        }
        guard isQuestionsFetched else {
            setErrorContainerView(text: "Please hold on momentarily as we prepare the questions for you.", isHidden: false)
            return
        }
        if isActive {
            let alert = UIAlertController(title: "Information", message: "The quiz is about to start. Are you ready?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Start", style: .default) { [weak self] _ in
                self?.performSegue(withIdentifier: "segueStartQuiz", sender: nil)
            })
            alert.addAction(UIAlertAction(title: "CANCEL", style: .cancel))
            present(alert, animated: true)
        } else {
            setErrorContainerView(text: "The quiz is not ready. Please wait!", isHidden: false)
        }
    }
}

extension EnterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
