//
//  ViewController.swift
//  calculator
//
//  Created by Armando Dorantes Bollain y Goytia on 2017-06-14.
//  Copyright © 2017 Armando Dorantes Bollain y Goytia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var history: UILabel!
    @IBOutlet weak var display: UILabel!
    var userIsInMiddleOfTyping = false
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userIsInMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            if digit != "." || !textCurrentlyInDisplay.contains("."){
                display.text = textCurrentlyInDisplay + digit
            }
            
        } else {
            display.text = digit == "." ? "0." : digit
            userIsInMiddleOfTyping = true
        }
    }
    
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInMiddleOfTyping = false
        }
        
        if let mathematicalOperation = sender.currentTitle {
            brain.performOperation(mathematicalOperation)
        }
        if let result = brain.result{
            displayValue = result
        }
        
        if let soFar = brain.record{
            history.text = soFar
        }
    }
    
}

