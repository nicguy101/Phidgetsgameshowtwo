//
//  question.swift
//  Phidgetsgameshowtwo
//
//  Created by Moyo Ososami on 2019-05-29.
//  Copyright © 2019 Phidgets. All rights reserved.
//

import Foundation
class Question {
    
    let questionText : String
    let answer: Bool
    
    init(text: String, correctAnswer: Bool) {
        questionText = text
        answer = correctAnswer
    }
    
}
