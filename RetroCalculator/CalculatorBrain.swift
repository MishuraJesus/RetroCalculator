//
//  CalculatorBrain.swift
//  RetroCalculator
//
//  Created by MikhailB on 09/05/2017.
//  Copyright © 2017 Mikhail. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    private var accumulator: Double?
    
    var result: Double? {
        get {
            return accumulator
        }
    }
    
    private enum Operation {
        case binaryOperation((Double,Double) -> Double)
        case result
    }
    
    private let operations: Dictionary<String, Operation> = [
        "+" : Operation.binaryOperation({$0 + $1}),
        "-" : Operation.binaryOperation({$0 - $1}),
        "*" : Operation.binaryOperation({$0 * $1}),
        "/" : Operation.binaryOperation({$0 / $1}),
        "=" : Operation.result
    ]
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .binaryOperation(let function):
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
                }
            case .result: performPendingBinaryOperation()
            }
        }
    }
    
    mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    var pendingBinaryOperation: PendingBinaryOperation?
    
    struct  PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    }
}
