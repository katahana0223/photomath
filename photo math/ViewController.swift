//
//  ViewController.swift
//  photo math
//
//  Created by hahahahahanananana on 2017/01/18.
//  Copyright © 2017年 片岡. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var shikiTextField: UITextField!
    override func viewDidLoad() {
        let shikiTextField  =  UILabel()
         shikiTextField.text = "876"

    
        //【STEP.0】入力される文字列
        var str = "554+322"
        

        super.viewDidLoad()
        self.shikiTextField.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        keisan(textField.text!)
        textField.resignFirstResponder()
        return true
    }
    func keisan(_ str: String){
        var number = 0      //1項目（上の式の場合、「3」）
        var number2 = 0     //2項目（上の式の場合、「2」）
        var number3 = 0     //3項目（上の式の場合、「1」がはいる）
        //【STEP.1】何文字目に記号があるか調べる
        /* --- ここで何文字目で記号「-」があるか調べている --- */
        var kigou = ""      //文字列で記号がはいる変数（上の式の場合、「-」）
        var index = 0       //何文字目に記号があるか（上の式の場合、「2」文字目）
        //for文の書き方は新しくなったぞ！
        for c in str.characters {
            index = index + 1
            print(c)
            
            if c=="+" || c=="-" || c=="*" || c=="/" {
                kigou = String(c)
                break
                //↑「break」は、強制的にこのfor文を抜け出すという意味。
            }
        }
        
        //【STEP.2】文字を取り出してそれぞれの変数に代入
        //numberとnumber2にそれぞれInt型で代入している。
        number = Int(str.substring(to: str.index(str.startIndex, offsetBy: index-1)))!
        number2 = Int(str.substring(from: str.index(str.endIndex, offsetBy: index-str.utf16.count)))!
        
        /* ここまででnumberとnumber2がわかった*/
        //【STEP.3】計算実行
        switch kigou {
        case "+":
            number3 = number + number2
        case "-":
            number3 = number - number2
        case "*":
            number3 = number * number2
        case "/":
            number3 = number / number2
        default:
            break
        }
        
        //FINAL ANSWER(最後の答え)
        print(number3)


        
        
    }
    
    var number1: Int = 0
    var number2: Int = 0
    var number3: Int = 0
    
    var ope: Int = 0
    
    
    
    
    @IBAction func plus(){
        number2 = number1
        number1 = 0
    }
}

