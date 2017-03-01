//
//  CameraViewController.swift
//  photo math
//
//  Created by hahahahahanananana on 2017/02/15.
//  Copyright © 2017年 片岡. All rights reserved.
//

import UIKit
import ALCameraViewController
class CameraTwoViewController: UIViewController {
    
    //viewが初めて読み込まれたときに実行される
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        let croppingEnabled: Bool = true
        let cameraViewController = CameraViewController(croppingEnabled: croppingEnabled) {(image, asset) in
            //クロージャ「文」ここから
            
            //カメラViewが閉じる時のクロージャ
            
            // Do something with your image here.
            // If cropping is enabled this image will be the cropped version
            
            //UIImage -> NSData
            //PNG形式
            let pngData = UIImagePNGRepresentation(image!)
            UserDefaults.standard.set(pngData, forKey: "image")
            self.dismiss(animated: true, completion: nil)
            
            //クロージャの「文」ここまで
        }
        
        present(cameraViewController, animated: true, completion: nil)
        
        
        
    }
    //ほぼ使わない
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
}
