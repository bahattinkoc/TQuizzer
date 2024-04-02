//
//  QuestionModel.swift
//  TQuizzer
//
//  Created by BAHATTIN KOC on 24.03.2024.
//

struct QuestionModel {
    let id: Int
    let question: String
    let correctAnswerId: Int
    let answerA: Answer
    let answerB: Answer
    let answerC: Answer
    let answerD: Answer
    let score: Int
}

struct Answer {
    let id: Int
    let answer: String
}
