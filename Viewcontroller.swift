//
//  ViewController.swift
//  Calculator
//
//  Created by Manuel Spaan on 22-06-15.
//  Copyright (c) 2015 Manuel Spaan. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var historyDisplay: UILabel!
    
    var UserIsInTheMiddleOfTypingANumber = false

    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if UserIsInTheMiddleOfTypingANumber {
            if (digit == ".")
                && (display.text!.rangeOfString(".") != nil) {
                return
            } else {
                display.text = display.text! + digit
            }
        } else {
            display.text = digit
            UserIsInTheMiddleOfTypingANumber = true
        }
        
        appendToHistoryLabel(digit)
        
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if UserIsInTheMiddleOfTypingANumber {
            enter()
        }
        switch operation {
            case "×": performOperation { $0 * $1 }
            case "÷": performOperation { $1 / $0 }
            case "+": performOperation { $0 + $1 }
            case "−": performOperation { $1 - $0 }
            case "√": performOperation { sqrt($0) }
            case "sin": performOperation { sin($0) }
            case "cos": performOperation { cos($0) }
            default: break
        }
        
        appendToHistoryLabel(" " + operation + " ")
        
    }
    
    func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }

    private func performOperation(operation: Double -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    var operandStack = Array<Double>()
    
    @IBAction func enter() {
        UserIsInTheMiddleOfTypingANumber = false
        operandStack.append(displayValue)
        println("operandStack = \(operandStack)")
        
        appendToHistoryLabel(" ")
    }
    
    let x = M_PI

    @IBAction func pi() {
        UserIsInTheMiddleOfTypingANumber = true
        if display.text != "0" {
            enter()
            display.text = "\(x)"
            enter()
        } else {
            display.text = "\(x)"
            enter()
        }
        appendToHistoryLabel(" π ")
    }
    
    func appendToHistoryLabel (text: String) {
        historyDisplay.text = historyDisplay.text! + text
    }
    
    
    @IBAction func clearOperandStack(sender: UIButton) {
        display.text = " "
        historyDisplay.text = " "
        removeAll(&operandStack)
        UserIsInTheMiddleOfTypingANumber = false
    }
    
    var displayValue: Double{
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            UserIsInTheMiddleOfTypingANumber = false
        }
    }
}
