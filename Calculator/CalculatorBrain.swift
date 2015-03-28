//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Navjot Cheema on 3/22/15.
//  Copyright (c) 2015 Navjot Cheema. All rights reserved.
//
/*Model*/
import Foundation
class CalculatorBrain {
   //implements printable protocol
    private enum Op: Printable {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
    
    //read only computed property
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let opSymbol, _):
                    return opSymbol
                case .BinaryOperation(let opSymbol, _):
                    return opSymbol
                }
                
            }
        }
    }
   private var opStack = [Op]()    //array of type op
   private var knownOps = [String : Op]()    //dictornory of <String,Op>
    private let clr = "C"
    init() {    //intializer
        func learnOp(op: Op){
            knownOps[op.description] = op
        }
        learnOp(Op.BinaryOperation("/") {$1 * $0})
        learnOp(Op.BinaryOperation("−") {$1 - $0})
        learnOp(Op.BinaryOperation("x", *))
        learnOp(Op.BinaryOperation("+",+))
        learnOp(Op.UnaryOperation("√",sqrt))
        learnOp(Op.UnaryOperation("sin",sin))
        learnOp(Op.UnaryOperation("cos",cos))
        learnOp(Op.UnaryOperation("tan",tan))
        
   //     knownOps["c"] = Op.UnaryOperation("c", clrStack)
        
    }
    // reset to default stage
    
    func clrStack() -> Double{
        opStack.removeAll()
        return 0.0;
    }
    /*
     * parameter: Array<Op>
     * return: tuple (double, Op)
     */
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops; //imutuable type
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand) :
                return(operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluate = evaluate(remainingOps)
                if let operand = operandEvaluate.result {
                   return (operation(operand),operandEvaluate.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Eval = evaluate(remainingOps)
                if let op1 = op1Eval.result {
                   let op2Eval = evaluate(op1Eval.remainingOps)
                    if let op2 = op2Eval.result {
                        return (operation(op1, op2), op2Eval.remainingOps  )
                    }
                }
                
            }
        }
        return (nil, ops)
    }
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        println("\(opStack) = \(result) with \(remainder)")
        return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if symbol == clr {
            return clrStack()
        }
        if  let operation = knownOps[symbol] {    //operation : type > Op? because it might return nil
            opStack.append(operation)
        }
        return evaluate()
    }
}