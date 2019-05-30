//
//  ViewController.swift
//  Phidgetsgameshowtwo
//
//  Created by Moyo Ososami on 2019-05-07.
//  Copyright © 2019 Phidgets. All rights reserved.
//

import UIKit
import Phidget22Swift

class ViewController: UIViewController {
    
    let button = DigitalInput()
    let button1 = DigitalInput()
    
    let led1 = DigitalOutput()
    let led2 = DigitalOutput()
    
    let allQuestions = QuestionBank()
    var pickedAnswer: Bool = false
    var questionNumber: Int = 0
    var ready1: String = "ready 1"
    var score : Int = 0
    var buttonpressed = "none"
    var readyForPlayer: Bool = true
    var locked : Int = 1
    
    
    
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var Score1: UILabel!
    @IBOutlet weak var Score2: UILabel!
    
    

    func attach_handler(sender: Phidget){
        do{
            
            let hubPort = try sender.getHubPort()
            
            if(hubPort == 1){
                print("LED 0 Attached")
            }
            else if (hubPort == 3){
                print("LED 1 Attached")
            }
            
        } catch let err as PhidgetError {
            
            print("Phidget Error" + err.description)
            
        } catch {
            //catch other errors here
        }
    }
    
    
    func state_change(sender: DigitalInput, state:Bool){
        do{
            
            if(state == true && buttonpressed == "none"){
                
                
                
                //Turn on the green LED
                try led1.setState(true)
                
                //Record that user green pressed in
                buttonpressed = "green"
                
            }
                
            else if (state == true && buttonpressed == "green"){
                pickedAnswer = false
                try led2.setState(false)
                buttonpressed = "askQuestionGreen"
                asked()
                
            }
                
            else if (state == true && (buttonpressed == "askQuestionGreen" || buttonpressed == "askQuestionRed")){
                pickedAnswer = false
                finishThis()
                
            }
                
            else {
                print("Button Not Pressed")
                
            }
            
            
        } catch let err as PhidgetError {
            print("PhidgetError" + err.description)
        } catch {
            //other errors here
        }
    }
        //RED state change for red button
    func red_change(sender: DigitalInput, state:Bool){
        do{
                
                if(state == true && buttonpressed == "none"){
                    
                    
                    //Turn on the red LED
                    try led2.setState(true)
                    
                    //Record that user red pressed in
                    buttonpressed = "red"
                    
                    //Change label to tell Player 1 to get ready
                    readyPlayer1()
                    
                    if buttonpressed == "askQuestionRed"{
                        pickedAnswer = true
                        asked()
                    }
                }
                else if (state == true && buttonpressed == "red"){
                    pickedAnswer = true
                    try led2.setState(false)
                    buttonpressed = "askQuestionRed"
                    asked()
                }
                else if (state == true && (buttonpressed == "askQuestionRed" || buttonpressed == "askQuestionGreen")){
                    pickedAnswer = true
                    finishThis()
                }
                else {
                    print("Button Not Pressed")
                    
                }
                
                
            } catch let err as PhidgetError {
                print("PhidgetError" + err.description)
            } catch {
                //other errors here
            }
            
        }
    

        
       override func viewDidLoad() {
            super.viewDidLoad()
            do{
                //enable server discovery
                try Net.enableServerDiscovery(serverType:  .deviceRemote)
                
                //adress digital input
                try button.setDeviceSerialNumber(528005)
                try button.setHubPort(2)
                try button.setIsHubPortDevice(true)
                
                try button1.setDeviceSerialNumber(528005)
                try button1.setHubPort(0)
                try button1.setIsHubPortDevice(true)
                
                
                //add event handler
                let _ = button.stateChange.addHandler(state_change)
                let _ = button1.stateChange.addHandler(red_change)
                
                //add attach handler
                let _ = button.attach.addHandler(attach_handler)
                let _ = button1.attach.addHandler(attach_handler)
                
                //open
                try button.open()
                try button1.open()
                
                //adress, add attach handler, and opendigital outputs
                try led1.setDeviceSerialNumber(528005)
                try led1.setHubPort(1)
                try led1.setIsHubPortDevice(true)
                
                try led2.setDeviceSerialNumber(528005)
                try led2.setHubPort(3)
                try led2.setIsHubPortDevice(true)
                
                let _ = led1.attach.addHandler(attach_handler)
                let _ = led2.attach.addHandler(attach_handler)
                
                try led1.open()
                try led2.open()
                updateUI()
            } catch let err as PhidgetError {
                print("Phidget Error" + err.description)
            } catch {
                //catch other errors here
            }
        }
        func updateUI() {
            
            DispatchQueue.main.async {
                self.Score1.text = "Score:\(self.score)"
                self.Score2.text = "Score:\(self.score)"
            }
        }
        
        func readyPlayer1(){
            if buttonpressed == "green"{
                print("ready")
                DispatchQueue.main.async{
                    self.question.text = "Are you ready player 1"
                }
            } else if buttonpressed == "red"{
                DispatchQueue.main.async {
                    self.question.text = "Are you ready player 2"
                }
            }
        }
        
        func lamp() {
            if buttonpressed == "green"{
                asked()
            }
            
        }
        func asked() {
            nextQuestion()
            checkAnswer()
            questionNumber = questionNumber + 1
            
        }
        func readyAgain() {
            startOver()
        }
        func nextQuestion() {
            
            if questionNumber <= 12{
                DispatchQueue.main.async{
                    self.question.text =
                        self.allQuestions.list[self.questionNumber].questionText
                    
                }
                updateUI()
            }
            else {
                
                let alert = UIAlertController(title: "Awesome", message: "You've finished all the questions, do you want to start over?", preferredStyle: .alert)
                
                let restartAction = UIAlertAction(title: "restart", style: .default, handler: { (UIAlertAction) in
                    self.startOver()
                })
                
                alert.addAction(restartAction)
                
                present(alert, animated: true, completion: nil)
            }
        }
        
        
        func checkAnswer() {
            let correctAnswer = allQuestions.list[questionNumber].answer
            
            if correctAnswer == pickedAnswer{
                
                
                score = score + 1
            }
            else {
                
            }
        }
        
        
        func startOver() {
            
            score = 0
            questionNumber = 0
            nextQuestion()
    }
    func finishThis(){
        if (buttonpressed == "askQuestionRed" || buttonpressed == "askQuestionGreen"){
            DispatchQueue.main.async {
                self.question.text = "Ready?"
                
            }
        }
        buttonpressed = "none"
    }
    
}

