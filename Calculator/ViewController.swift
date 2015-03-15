//
//  ViewController.swift
//  Calculator
//
//  Created by JasonChiang on 3/15/15.
//  Copyright (c) 2015年 JasonChiang. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController
{
    @IBOutlet weak var display: UILabel!

    var userIsInTheMiddleOfTypingANumber = false

    var brain = CalculatorBrain()

    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }

    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                // TODO: Homework 2: Let displayValue to be optional so that UI can display error info.
                displayValue = 0
            }
        }
    }

    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        } else {
            // TODO: Homework 2: Let displayValue to be optional so that UI can display error info.
            displayValue = 0
        }
    }

    var displayValue: Double {
        get {
            // TODO: Homework 1: What's this?
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
}

