//
//  CameraViewController.swift
//  photo math
//
//  Created by hahahahahanananana on 2017/02/15.
//  Copyright © 2017年 片岡. All rights reserved.
//

import UIKit
import  AVFoundation
class CameraViewController: UIViewController {
    
    var captureSession: AVCaptureSession!
    //デバイス
    var cameraDevices: AVCaptureDevice!
    //画像のアウトプット
    var imageOutput: AVCaptureStillImageOutput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        captureSession = AVCaptureSession()
        let devices = AVCaptureDevice.devices()
        
        //バックカメラをcameraDevicesに格納
        for device in devices! {
            if (device as AnyObject).position == AVCaptureDevicePosition.back {
                cameraDevices = device as! AVCaptureDevice
            }
        }
        
        //バックカメラからVideoInputを取得
        let videoInput: AVCaptureInput!
        do {
            videoInput = try AVCaptureDeviceInput.init(device: cameraDevices)
        } catch {
            videoInput = nil
        }
        
        //セッションに追加
        captureSession.addInput(videoInput)
        
        //出力先を生成
        imageOutput = AVCaptureStillImageOutput()
        
        //セッションに追加
        captureSession.addOutput(imageOutput)
        
        //画像を表示するレイヤーを生成
        let captureVideoLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer.init(session: captureSession)
        captureVideoLayer.frame = self.view.bounds
        captureVideoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        //Viewに追加
        self.view.layer.addSublayer(captureVideoLayer)
        
        //セッション開始
        captureSession.startRunning()
        
    }
    // Do any additional setup after loading the view.
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func cameraStart(sender: AnyObject) {
        //ビデオ出力に接続
        let captureVideoConnection = imageOutput.connection(withMediaType: AVMediaTypeVideo)
        
        //接続から画像を取得
        self.imageOutput.captureStillImageAsynchronously(from: captureVideoConnection) { (imageDataBuffer, error) -> Void in
            //取得したImageのDataBufferをJPEGを変換
            let capturedImageData: NSData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataBuffer) as NSData
            //JPEGからUIImageを作成
            let Image: UIImage = UIImage(data: capturedImageData as Data)!
            //アルバムに追加
            UIImageWriteToSavedPhotosAlbum(Image, self, nil, nil)
        }
    }
}


/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */

