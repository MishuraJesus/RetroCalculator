//
//  ViewController.swift
//  RetroCalculator
//
//  Created by MikhailB on 09/05/2017.
//  Copyright © 2017 Mikhail. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var outputLabel: UILabel!
    
    var userIsInTheMiddleOfTyping = false
    var buttonSound: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = Bundle.main.path(forResource: "btn", ofType: "wav")
        let soundURL = URL(fileURLWithPath: path!)
        
        do {
            try buttonSound = AVAudioPlayer(contentsOf: soundURL)
            buttonSound.prepareToPlay()
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    @IBAction func numberPressed(sender: UIButton) {
        playSound()
        if userIsInTheMiddleOfTyping {
            let number = "\(sender.tag)"
            outputLabel.text = outputLabel.text! + number
        } else {
            outputLabel.text = "\(sender.tag)"
            userIsInTheMiddleOfTyping = true
        }
    }
    
    func playSound() {
        if buttonSound.isPlaying {
            buttonSound.stop()
        }
        
        buttonSound.play()
    }
    
    @IBAction func addButtonPressed(sender: UIButton) {
        performOperation("+")
        playSound()
    }
    @IBAction func subtractButtonPressed(sender: UIButton) {
        performOperation("-")
        playSound()
    }
    @IBAction func multiplyButtonPressed(sender: UIButton) {
        performOperation("*")
        playSound()
    }
    @IBAction func divideButtonPressed(sender: UIButton) {
        performOperation("/")
        playSound()
    }
    @IBAction func resultButtonPressed(sender: UIButton) {
        performOperation("=")
        playSound()
    }
    @IBAction func clearButtonPressed(_ sender: UIButton) {
        playSound()
        outputLabel.text = "0"
        userIsInTheMiddleOfTyping = false
    }
    
    
    var displayValue: Double {
        get {
            return Double(outputLabel.text!)!
        }
        set {
            outputLabel.text! = String(newValue)
        }
    }
    
    private var brain = CalculatorBrain()
    
    func performOperation(_ operation: String) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        brain.performOperation(operation)
        if let result = brain.result {
            displayValue = result
        }
    }
}

