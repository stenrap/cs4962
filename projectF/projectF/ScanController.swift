//
//  ScanController.swift
//  projectF
//
//  Created by Robert Johansen on 4/18/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

import UIKit
import AVFoundation

class ScanController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, DigistruxDelegate {
    
    var model: Digistrux = Digistrux()
    
    //var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        DOESN'T WORK (because you need a real phone/iPad)?
        (from http://www.appcoda.com/qr-code-reader-swift/)
        var captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        var error: NSError? = nil
        var input: AnyObject! = AVCaptureDeviceInput.deviceInputWithDevice(captureDevice, error: &error)
        
        if (error != nil) {
            println("Error: \(error!.localizedDescription)")
            return
        }
        
        captureSession = AVCaptureSession()
        captureSession?.addInput(input as AVCaptureInput)
        
        var captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataOutput)
        
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer)
        
        captureSession?.startRunning()
        */
        
        
        /*
        
        (from http://jamesonquave.com/blog/taking-control-of-the-iphone-camera-in-ios-8-with-swift-part-1/)
        */
        
        var captureSession: AVCaptureSession = AVCaptureSession()
        captureSession.sessionPreset = AVCaptureSessionPresetLow
        
        var devices = AVCaptureDevice.devices()
        println(devices)
    }
    
}
