//
//  ViewController.swift
//  Calculator
//
//  Created by Navjot Cheema on 1/26/15.
//  Copyright (c) 2015 Navjot Cheema. All rights reserved.
//

//Import the UI
import UIKit
//import Darwin


class ViewController: UIViewController {
    var userIsInTheMiddle = false   //track if user previously typed a #
 //   var operandStack = Array<Double>()  //store the digits
    //outlet conenection to dispaly by using a pointer
    @IBOutlet weak var display: UILabel!
    
    @IBOutlet weak var displayHistory: UILabel!
    
    var brain = CalculatorBrain()
    /*
    arguments name:type
    append the selected digit to display screen
    */
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!    //constant
        if (digit == "." ) {
            if (display.text!.rangeOfString(".") == nil) {
                display.text = display.text! + digit
                userIsInTheMiddle = true;
            }
        }
        
        
        else if (userIsInTheMiddle) {
            display.text = display.text! + digit
            
        }
        else {
            display.text = digit
            userIsInTheMiddle = true;
        }
     //   println("Digit = \(digit)");
    }
   
    
  
 
    @IBAction func operate(sender: UIButton) {
        //check if user pressed operate without hitting enter
        if userIsInTheMiddle {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayvalue = result
            }else {
                displayvalue = 0
            }
        }

    }
    /* clear all items from stack */
     
    
    @IBAction func enter() {
        userIsInTheMiddle = false
        if let result = brain.pushOperand(displayvalue) {
            displayvalue = result //update result
        } else {
            
        }
        
    }
  
    //computed property(variable) to set/get display text
    var displayvalue: Double {
        get {
            //check for pi
            if(display.text! == "π") {
                return M_PI
            }
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue

        }
        set {
            display.text = "\(newValue)"    //convert from double to str
            userIsInTheMiddle = false
            
        }
    }
    
}

