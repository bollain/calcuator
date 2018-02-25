//
//  CalculatorBrain.swift
//  calculator
//
//  Created by Armando Dorantes Bollain y Goytia on 2017-06-19.
//  Copyright © 2017 Armando Dorantes Bollain y Goytia. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    private var accumulator: (Double?, String?)
    private var resultIsPending: Bool = false
    private var appendLastOperand = false
    private var variables = [String: Double]()
    
    private enum Operation{
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
        case clear
    }
    
    private var operations: Dictionary<String, Operation> =
        [
            "π": Operation.constant(Double.pi),
            "e": Operation.constant(M_E),
            "√": Operation.unaryOperation(sqrt),
            "cos": Operation.unaryOperation(cos),
            "sin": Operation.unaryOperation(sin),
            "٪": Operation.unaryOperation({$0 / 100}),
            "±": Operation.unaryOperation({-$0}),
            "×": Operation.binaryOperation({$0 * $1}),
            "÷": Operation.binaryOperation({$0 / $1}),
            "+": Operation.binaryOperation({$0 + $1}),
            "−": Operation.binaryOperation({$0 - $1}),
            "=": Operation.equals,
            "AC": Operation.clear
    ]
    
    mutating func performOperation(_ symbol: String){
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator.0 = value
                if resultIsPending {
                    accumulator.1 = accumulator.1! + " " + symbol
                } else {
                    accumulator.1 = symbol
                }
                appendLastOperand = false
            case .unaryOperation(let function):
                if accumulator.0 != nil && accumulator.1 != nil {
                    accumulator.1 = resultIsPending ? accumulator.1! + " " + symbol + "(\(accumulator.0!))" : symbol + "(\(accumulator.1!))"
                    accumulator.0 = function(accumulator.0!)
                    appendLastOperand = false
                }
            case .binaryOperation(let function):
                if accumulator.0 != nil && accumulator.1 != nil {
                    if resultIsPending{
                        accumulator.1 = appendLastOperand ? accumulator.1! + " " + String(accumulator.0!) : accumulator.1!
                        performPendingBinaryOperation()
                    }
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator.0!)
                    accumulator.1 = accumulator.1! + " " + symbol
                    resultIsPending = true
                    appendLastOperand = true
                    accumulator.0 = nil
                    
                }
            case .equals:
                if appendLastOperand && accumulator.0 != nil && accumulator.1 != nil {
                    accumulator.1 = accumulator.1! + " " + String(accumulator.0!)
                }
                performPendingBinaryOperation()
            case .clear:
                pendingBinaryOperation = nil
                resultIsPending = false
                accumulator = (0, nil)
            }
        }
        
    }
    
    private mutating func performPendingBinaryOperation(){
        if pendingBinaryOperation != nil && accumulator.0 != nil{
            accumulator.0 = pendingBinaryOperation!.perform(with: accumulator.0!)
            pendingBinaryOperation = nil
            resultIsPending = false
            appendLastOperand = false
        }
        
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private struct PendingBinaryOperation{
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand:Double) -> Double{
            return function(firstOperand, secondOperand)
        }
    }
    
    mutating func setOperand(_ operand: Double){
        accumulator.0 = operand
        if !resultIsPending {
            accumulator.1 = String(operand)
        }
    }
    
    mutating func setOperand(variable named: String){
        variables[named] = 0
        let answer = evaluate(using: variables)
        accumulator.0 = answer.result
        accumulator.1 = answer.description
        resultIsPending = answer.isPending
        
    }
    
    func evaluate(using variables: Dictionary<String, Double>? = nil) -> (result: Double?, isPending: Bool, description: String){
        //TODO: I have no idea
        return (0, true, "penis")
    }
    
    var result: Double? {
        get{
            return accumulator.0
        }
    }
    
    var record: String? {
        get {
            let suffix = resultIsPending ? " ..." : " ="
            if accumulator.1 != nil {
                return accumulator.1! + suffix
            } else {
                return " "
            }
            
        }
    }
}
