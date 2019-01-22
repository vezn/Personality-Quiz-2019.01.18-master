//
//  QuestionViewController.swift
//  Personality Quiz
//
//  Created by Denis Bystruev on 15/01/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController {
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var singleStackView: UIStackView!
    @IBOutlet var singleButtons: [UIButton]!
    
    @IBOutlet weak var multipleStackView: UIStackView!
    @IBOutlet var multiLabels: [UILabel]!
    @IBOutlet var multiSwitches: [UISwitch]!
    
    @IBOutlet weak var rangedStackView: UIStackView!
    @IBOutlet weak var rangedSlider: UISlider!
    @IBOutlet var rangedLabels: [UILabel]!
    
    @IBOutlet weak var progressView: UIProgressView!
    
    var questionIndex = 0
    
    var questions: [Question] = [
        
        Question(
            text: "Какую еду вы предпочитаете?",
            type: .single,
            answers: [
                Answer(text: "Стейк", type: .dog),
                Answer(text: "Рыба", type: .cat),
                Answer(text: "Морковка", type: .rabbit),
                Answer(text: "Капуста", type: .turtle),
            ]
        ),

        Question(
            text: "Что вам нравится делать?",
            type: .multiple,
            answers: [
                Answer(text: "Плавать", type: .turtle),
                Answer(text: "Спать", type: .cat),
                Answer(text: "Бегать", type: .rabbit),
                Answer(text: "Кушать", type: .dog),
                ]
        ),

        Question(
            text: "Насколько вы любите ездить на машине?",
            type: .ranged,
            answers: [
                Answer(text: "Ненавижу", type: .cat),
                Answer(text: "Нервничаю", type: .rabbit),
                Answer(text: "Не замечаю", type: .turtle),
                Answer(text: "Обожаю", type: .dog),
                ]
        ),

    ]
    
    var answersChosen = [Answer]()

    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
    }
    
    func updateUI() {
        singleStackView.isHidden = true
        multipleStackView.isHidden = true
        rangedStackView.isHidden = true
        
        let question = questions[questionIndex]
        let answers = question.answers
        let progress = Float(questionIndex) / Float(questions.count)
        
        navigationItem.title = "Вопрос № \(questionIndex + 1)"
        questionLabel.text = question.text
        questionLabel.numberOfLines = 0
        progressView.setProgress(progress, animated: true)
        
        switch question.type {
        case .single:
            updateSingleStack(with: answers)
        case .multiple:
            updateMultipleStack(with: answers)
        case .ranged:
            updateRangedStack(with: answers)
        }
    }
    
    func updateSingleStack(with answers: [Answer]) {
        singleStackView.isHidden = false
        
        //            for i in 0..<singleButtons.count {
        //                singleButtons[i].setTitle(answers[i].text, for: .normal)
        //            }
        guard singleButtons.count <= answers.count else { return }
        singleButtons.enumerated().forEach {
            $0.element.setTitle(answers[$0.offset].text, for: .normal)
        }
    }
    
    func updateMultipleStack(with answers: [Answer]) {
        multipleStackView.isHidden = false
        guard multiLabels.count <= answers.count else { return }
        multiLabels.enumerated().forEach { $0.element.text = answers[$0.offset].text }
    }
    
    func updateRangedStack(with answers: [Answer]) {
        rangedStackView.isHidden = false
        rangedLabels.first?.text = answers.first?.text
        rangedLabels.last?.text = answers.last?.text
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func singleButtonPressed(_ sender: UIButton) {
        let answers = questions[questionIndex].answers
        
        guard let index = singleButtons.index(of: sender) else { return }
        
        let answer = answers[index]
        
        answersChosen.append(answer)
        print(#function, answer)
        print()
        
        nextQuestion()
    }
    
    @IBAction func multipleButtonPressed() {
        let answers = questions[questionIndex].answers
        
        multiSwitches.enumerated().forEach {
            if $0.element.isOn {
                let answer = answers[$0.offset]
                answersChosen.append(answer)
                print(#function, answer)
            }
        }
        
        print()
        
        nextQuestion()
    }
    
    @IBAction func rangedButtonPressed() {
        let answers = questions[questionIndex].answers
        
        let index = Int(round(rangedSlider.value * Float(answers.count - 1)))
        
        let answer = answers[index]
        answersChosen.append(answer)
        
        print(answer)
        print()
        
        nextQuestion()
    }
    
    func nextQuestion() {
        questionIndex += 1
        
        if questionIndex < questions.count {
            updateUI()
        } else {
            performSegue(withIdentifier: "ResultsSegue", sender: nil)
        }
        
    }
    
}
