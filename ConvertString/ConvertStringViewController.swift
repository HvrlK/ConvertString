//
//  ConvertStringViewController.swift
//  ConvertString
//
//  Created by Vitalii Havryliuk on 6/7/18.
//  Copyright © 2018 Vitalii Havryliuk. All rights reserved.
//

import UIKit

class ConvertStringViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var string1TextField: UITextField!
    @IBOutlet weak var string2TextField: UITextField!
    @IBOutlet weak var resultStringLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var convertButton: UIButton!

    //MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        string1TextField.delegate = self
        string2TextField.delegate = self
        convertButton.layer.cornerRadius = 8
        resultLabel.alpha = 0
        resultStringLabel.alpha = 0
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func convert(_ string1: String, _ string2: String) -> String {
        if string1.count == 0 {
            return String(repeating: "i", count: string2.count)
        }
        if string2.count == 0 {
            return String(repeating: "d", count: string1.count)
        }
        var m = string1.count
        var n = string2.count
        var matrix = [[Int]](repeating: [Int](repeating: 0, count: n+1), count: m+1)
        for i in 1...m {
            matrix[i][0] = i
        }
        for i in 1...n {
            matrix[0][i] = i
        }
        for i in 1...m {
            for j in 1...n {
                matrix[i][j] = string1[i-1] == string2[j-1] ? matrix[i-1][j-1] : min(matrix[i-1][j-1], min(matrix[i][j-1], matrix[i-1][j])) + 1
            }
        }
        var resultString = String()
        while m != 0 || n != 0 {
            if m == 0 {
                resultString.insert("i", at: resultString.startIndex)
                n -= 1
                continue
            }
            if n == 0 {
                 resultString.insert("d", at: resultString.startIndex)
                m -= 1
                continue
            }
            let minWeight = min(matrix[m-1][n-1], matrix[m][n-1], matrix[m-1][n])
            if minWeight != matrix[m][n] {
                if minWeight == matrix[m-1][n-1] {
                    resultString.insert("s", at: resultString.startIndex)
                    m -= 1
                    n -= 1
                } else {
                    if minWeight == matrix[m][n-1] {
                        resultString.insert("i", at: resultString.startIndex)
                        n -= 1
                    } else {
                        resultString.insert("d", at: resultString.startIndex)
                        m -= 1
                    }
                }
            } else {
                m -= 1
                n -= 1
            }
        }
        return resultString
    }
    
    //MARK: - Actions

    @IBAction func convertButtonTapped() {
        UIView.animate(
            withDuration: 0.5,
            animations: {
                self.resultStringLabel.alpha = 0
        },
            completion: { _ in
                if let string1 = self.string1TextField.text, let string2 = self.string2TextField.text {
                    self.resultStringLabel.text = self.convert(string1, string2)
                }
                UIView.animate(withDuration: 0.5, animations: {
                    self.resultStringLabel.alpha = 1
                    if self.resultLabel.alpha == 0 {
                        self.resultLabel.alpha = 1
                    }
                })
        })
    }
    
}

//MARK: - Extensions

extension String {
    
    subscript (i: Int) -> String {
        let idx = index(startIndex, offsetBy: i)
        return String(self[idx])
    }
    
}

extension ConvertStringViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = view.viewWithTag(textField.tag + 1) {
            nextTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            convertButtonTapped()
        }
        return true
    }
    
}
