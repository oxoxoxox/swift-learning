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

    @IBOutlet weak var historyDisplay: UILabel!

    var userIsInTheMiddleOfTypingANumber = false
    var haveADotInANumber = false
    var historyArray = [String]()

    var brain = CalculatorBrain()

    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            if digit == "." {
                if !haveADotInANumber {
                    display.text = display.text! + digit
                    haveADotInANumber = true
                }
            } else {
                display.text = display.text! + digit
            }
        } else {
            if digit == "." {
                // In case user input number like this: .24 (Which should be 0.24)
                display.text = "0" + digit
                haveADotInANumber = true
            } else {
                display.text = digit
            }
            userIsInTheMiddleOfTypingANumber = true
        }
    }

    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle {
            let result = brain.performOperation(operation)

            if nil != result {
                historyArray.append(brain.outputMemory() + " = \(result!)")
                if (historyArray.count >= historyDisplay.numberOfLines) {
                    historyArray.removeAtIndex(0)
                }

                displayValue = result!
                brain.replaceMemoryWithResult(result!)

                setDisplayHistoryValue()
            } else {
                // TODO: Homework 2: Let displayValue to be optional so that UI can display error info.
                displayValue = 0
                brain.replaceMemoryWithResult(0)
            }
        }
    }

    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        haveADotInANumber = false
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        } else {
            // TODO: Homework 2: Let displayValue to be optional so that UI can display error info.
            displayValue = 0
        }
    }

    @IBAction func displayClear(sender: UIButton) {
        userIsInTheMiddleOfTypingANumber = false
        haveADotInANumber = false
        displayValue = 0
        clearDisplayHistoryValue()
        historyArray.removeAll(keepCapacity: false)
        brain.clearMemory()
    }

    var displayValue: Double {
        get {
            // TODO: Homework 1: What's this?
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            var rest = newValue % 1.0
            if rest == 0 {
                display.text = "\(Int64(newValue))"
            } else {
                display.text = "\(newValue)"
            }
            userIsInTheMiddleOfTypingANumber = false
        }
    }

    func setDisplayHistoryValue() {
        var value = "History"
        for var index = 0; index < historyArray.count; index++ {
            value += "\n" + historyArray[index]
        }
        historyDisplay.text = value
    }

    func clearDisplayHistoryValue() {
        historyDisplay.text = "History"
    }
}

