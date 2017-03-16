//
//  DigitDetectorViewController.swift
//  photo math
//
//  Created by hahahahahanananana on 2017/03/08.
//  Copyright © 2017年 片岡. All rights reserved.
//

import UIKit
import MetalPerformanceShaders
class DigitDetectorViewController: UIViewController {
    var deep = false
    var commandQueue: MTLCommandQueue!
    var device: MTLDevice!
    var shiki : String = ""
    @IBOutlet var label: UILabel!
    @IBOutlet var shikiTextField: UITextField!
    
    
    // Networks we have
    var neuralNetwork: MNIST_Full_LayerNN? = nil
    var neuralNetworkDeep: MNIST_Deep_ConvNN? = nil
    var runningNet: MNIST_Full_LayerNN? = nil
    // loading MNIST Test Set here
    let MNISTdata = GetMNISTData()
    
    // MNIST dataset image parameters
    let mnistInputWidth  = 28
    let mnistInputHeight = 28
    let mnistInputNumPixels = 784
    
    // Outlets to labels and view
    @IBOutlet weak var digitView: DrawView!
    @IBOutlet weak var predictionLabel: UILabel!
    @IBOutlet weak var accuracyLabel: UILabel!
    
    
    override func viewDidLoad() {
        let shikiTextField  =  UILabel()
        shikiTextField.text = "876"
        
        
        //【STEP.0】入力される文字列
        var str = "554+322"
        
        super.viewDidLoad()
        // Load default device.
        device = MTLCreateSystemDefaultDevice()
        
        // Make sure the current device supports MetalPerformanceShaders.
        guard MPSSupportsMTLDevice(device) else {
            print("Metal Performance Shaders not Supported on current Device")
            return
        }
        
        // Create new command queue.
        commandQueue = device!.makeCommandQueue()
        
        // initialize the networks we shall use to detect digits
        neuralNetwork = MNIST_Full_LayerNN(withCommandQueue: commandQueue)
        neuralNetworkDeep  = MNIST_Deep_ConvNN(withCommandQueue: commandQueue)
        runningNet = neuralNetwork
    }
    //押したら数字が表示されるボタンだヨッ！
    // Do any additional setup after loading the view.
    
    @IBAction func plus(){
        shiki = shiki + "+"
        predictionLabel.text = String(shiki)
    }
    @IBAction func minus(){
        shiki = shiki + "-"
        predictionLabel.text = String(shiki)
    }
    @IBAction func kakeru(){
        shiki = shiki + "*"
        predictionLabel.text = String(shiki)
    }
    @IBAction func waru(){
        shiki = shiki + "/"
        predictionLabel.text = String(shiki)
        
    }
    @IBAction func equal(){
        predictionLabel.text = String(keisan(shiki))
    }
    @IBAction func tappedDetectDigit(_ sender: UIButton) {
        // get the digitView context so we can get the pixel values from it to intput to network
        let context = digitView.getViewContext()
        // validate NeuralNetwork was initialized properly
        assert(runningNet != nil)
        
        // putting input into MTLTexture in the MPSImage
        runningNet?.srcImage.texture.replace(region: MTLRegion( origin: MTLOrigin(x: 0, y: 0, z: 0),
                                                                size: MTLSize(width: mnistInputWidth, height: mnistInputHeight, depth: 1)),
                                             mipmapLevel: 0,
                                             slice: 0,
                                             withBytes: context!.data!,
                                             bytesPerRow: mnistInputWidth,
                                             bytesPerImage: 0)
        // run the network forward pass
        let label = (runningNet?.forward())!
        
        // show the prediction
        predictionLabel.text = "\(label)"
        predictionLabel.isHidden = false
        shiki = shiki + "\(label)"
        predictionLabel.text = String(shiki)
    }
    
    @IBAction func tappedClear(_ sender: UIButton) {
        // clear the digitview
        digitView.lines = []
        digitView.setNeedsDisplay()
    
        
    }
    @IBAction func tappedreset(){
        shiki = ""
        predictionLabel.text = String(shiki)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    
    func keisan(_ str: String) -> Int {
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
        return number3
        
    }
    
    var number1: Int = 0
    var number2: Int = 0
    var number3: Int = 0
    
    var ope: Int = 0
    
    
    
}
/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */


