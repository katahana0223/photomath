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
    
    // Networks we have
    var neuralNetwork: MNIST_Full_LayerNN? = nil
    var neuralNetworkDeep: MNIST_Deep_ConvNN? = nil
    var runningNet: MNIST_Full_LayerNN? = nil
    var shiki : String = ""
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
        predictionLabel.isHidden = true
        
    }
    @IBAction func tappedreset(){
        shiki = ""
        predictionLabel.text = String(shiki)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
