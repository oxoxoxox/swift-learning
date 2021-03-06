//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by JasonChiang on 3/15/15.
//  Copyright (c) 2015年 JasonChiang. All rights reserved.
//

import Foundation

class CalculatorBrain
{
    private enum Op: Printable {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)

        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }

//    var opStack = Array<Op>()
    private var opStack = [Op]()

//    var knownOps = Dictionary<String, Op>()
    private var knownOps = [String:Op]()

    init() {
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        learnOp(Op.BinaryOperation("×", *))
        learnOp(Op.BinaryOperation("÷") { $1 / $0 })
        learnOp(Op.BinaryOperation("+", +))
        learnOp(Op.BinaryOperation("−") { $1 - $0 })
        learnOp(Op.UnaryOperation("sin", sin))
        learnOp(Op.UnaryOperation("cos", cos))
        learnOp(Op.UnaryOperation("π", { 3.14159 * $0}))
        learnOp(Op.UnaryOperation("√", sqrt))

////        knownOps["×"] = Op.BinaryOperation("×", { $0 * $1 })
////        knownOps["×"] = Op.BinaryOperation("×") { $0 * $1 }
//        knownOps["×"] = Op.BinaryOperation("×", *)
//        knownOps["÷"] = Op.BinaryOperation("÷") { $1 / $0 }
//        knownOps["+"] = Op.BinaryOperation("+", +)
//        knownOps["−"] = Op.BinaryOperation("−") { $1 - $0 }
//        knownOps["√"] = Op.UnaryOperation("√", sqrt)
    }

    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
//            default: break // Don't need default case if you have gone through all cases.
            }
        }
        return (nil, ops)
    }

    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        println("\(opStack) = \(result) with \(remainder) left over")
        return result
    }

    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }

    func performOperation(symblol: String) -> Double? {
        if let operation = knownOps[symblol] {
            switch operation {
            case .BinaryOperation(_, _):
                if opStack.count > 2 {
                    opStack.removeRange(Range<Int>(start: 0, end: opStack.count - 2))
                }
            case .UnaryOperation(_, _):
                if opStack.count > 1 {
                    opStack.removeRange(Range<Int>(start: 0, end: opStack.count - 1))
                }
            default:
                break;
            }
            opStack.append(operation)
        }

        var result: Double!
        result = evaluate()
//        opStack.append(Op.Operand(result))

        return result
    }

    func replaceMemoryWithResult(result: Double) {
        println("Replace memory with result")
        opStack.removeAll(keepCapacity: false)
        opStack.append(Op.Operand(result))
    }

    func clearMemory() {
        opStack.removeAll(keepCapacity: false)
        println("Memory is cleared")
    }

    func outputMemory() -> String {
        var memoryString = ""
        var index: Int
        let count = opStack.count
        for index = 0; index < count; ++index {
            if index > 0 {
                memoryString += " "
            }
            memoryString += "\(self.opStack[index])"
        }
        return memoryString
    }
}

