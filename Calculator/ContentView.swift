//
//  ContentView.swift
//  Calculator
//
//  Created by Tiku on 3/3/23.
//

import SwiftUI

enum CalculatorButton: String {
    case zero, one, two, three, four, fife, six, seven, eight, nine
    case equals, plus, minus, multiply, divide
    case ac, plusMinus, percent, decimal
    
    var title: String {
        switch self {
        case .zero: return "0"
        case .one: return "1"
        case .two: return "2"
        case .three: return "3"
        case .four: return "4"
        case .fife: return "5"
        case .six: return "6"
        case .seven: return "7"
        case .eight: return "8"
        case .nine: return "9"
        case .plus: return "+"
        case .minus: return "-"
        case .multiply: return "x"
        case .divide: return "÷"
        case .plusMinus: return "+/-"
        case .percent: return "%"
        case .equals: return "="
        case .decimal: return "."
        default: return "AC"
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .zero, .one, .two, .three, .four, .fife, .six, .seven, .eight, .nine:
            return Color(.darkGray)
        case .ac, .plusMinus, .percent:
            return Color(.lightGray)
        default:
            return Color.orange
        }
    }
}

class GlobalEnvironment: ObservableObject {
    @Published var display = ""
    var firstOperand: Double?
    var secondOperand: Double?
    var currentOperator: CalculatorButton?
    
    func receiveInput(calculatorButton: CalculatorButton) {
        switch calculatorButton {
        case .zero, .one, .two, .three, .four, .fife, .six, .seven, .eight, .nine:
            if currentOperator == nil {
                display += calculatorButton.title
                firstOperand = Double(display)
            } else {
                display += calculatorButton.title
                secondOperand = Double(display)
            }
        case .plus, .minus, .multiply, .divide:
            currentOperator = calculatorButton
            display = ""
        case .equals:
            if let firstOperand = firstOperand, let secondOperand = secondOperand, let currentOperator = currentOperator {
                let result = calculate(firstOperand: firstOperand, secondOperand: secondOperand, operator: currentOperator)
                display = String(result)
                self.firstOperand = result
                self.secondOperand = nil
                self.currentOperator = nil
            }
        case .ac:
            display = ""
            firstOperand = nil
            secondOperand = nil
            currentOperator = nil
        case .plusMinus:
            if let value = Double(display) {
                display = String(value * -1)
            }
        case .percent:
            if let value = Double(display) {
                display = String(value / 100)
            }
        case .decimal:
            if !display.contains(".") {
                display += "."
            }
        }
    }
    
    func calculate(firstOperand: Double, secondOperand: Double, operator: CalculatorButton) -> Double {
        switch `operator` {
        case .plus:
            return firstOperand + secondOperand
        case .minus:
            return firstOperand - secondOperand
        case .multiply:
            return firstOperand * secondOperand
        case .divide:
            return firstOperand / secondOperand
        default:
            return 0
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var env: GlobalEnvironment
    
    let buttons: [[CalculatorButton]] = [
        [.ac, .plusMinus, .percent, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .fife, .six, .minus],
        [.one, .two, .three, .plus],
        [.zero, .decimal, .equals]
    ]
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack(spacing: 12) {
                HStack {
                    Spacer()
                    Text(env.display)
                        .foregroundColor(.white)
                        .font(.system(size: 64))
                }.padding()
                
                ForEach(buttons, id: \.self) { row in
                    HStack(spacing: 12) {
                        ForEach(row, id: \.self) { button in
                            CalculatorButtonView(button: button)
                        }
                    }
                }
            }.padding(.bottom)
        }
    }
}

struct CalculatorButtonView: View {
    var button: CalculatorButton
    @EnvironmentObject var env: GlobalEnvironment
    var body: some View {
        Button {
            self.env.receiveInput(calculatorButton: button)
        } label: {
            Text(button.title)
                .font(.system(size: 32))
                .frame(width: self.buttonWidth(button: button),
                       height: (UIScreen.main.bounds.width - 5 * 12) / 4)
                .foregroundColor(.white)
                .background(button.backgroundColor)
                .cornerRadius(self.buttonWidth(button: button))
        }
    }
    
    private func buttonWidth(button: CalculatorButton) -> CGFloat {
        if button == .zero {
            return (UIScreen.main.bounds.width - 4 * 12) / 4 * 2
        }
        return (UIScreen.main.bounds.width - 5 * 12) / 4
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(GlobalEnvironment())
    }
}


/*
 need finish logik -> calculating
 */
