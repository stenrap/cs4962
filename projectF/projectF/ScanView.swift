//
//  ScanView.swift
//  projectF
//
//  Created by Robert Johansen on 4/25/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

import AVFoundation
import UIKit

protocol ScanDelegate: class {
    
    func codeCaptured(code: String)
    
}

class ScanView: UIView, AVCaptureMetadataOutputObjectsDelegate {
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var highlightBox: UIView = UIView()
    
    weak var delegate: ScanDelegate? = nil
    
    func startCapture() {
        frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height)
        
        var captureDevice:AVCaptureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        var error: NSError? = nil
        var input: AnyObject = AVCaptureDeviceInput.deviceInputWithDevice(captureDevice, error: &error)
        if (error != nil) {
            println("Camera Error: This app requires a real iOS device with a camera.")
            return
        }
        captureSession = AVCaptureSession()
        captureSession?.addInput(input as AVCaptureInput)
        
        var captureMetadataOutput: AVCaptureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataOutput)
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer?.frame = layer.bounds
        layer.addSublayer(videoPreviewLayer)
        
        captureSession?.startRunning()
        
        highlightBox.layer.borderColor = UIColor.greenColor().CGColor
        highlightBox.layer.borderWidth = 4
        addSubview(highlightBox)
        bringSubviewToFront(highlightBox)
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        if metadataObjects == nil || metadataObjects.count == 0 {
            highlightBox.frame = CGRectZero
            println("No QR code is detected")
            return
        }
        
        var metadataObj = metadataObjects[0] as AVMetadataMachineReadableCodeObject
        if (metadataObj.type == AVMetadataObjectTypeQRCode) {
            var qrCodeObject = videoPreviewLayer?.transformedMetadataObjectForMetadataObject(metadataObj as AVMetadataMachineReadableCodeObject) as AVMetadataMachineReadableCodeObject
            highlightBox.frame = qrCodeObject.bounds
            if metadataObj.stringValue != nil {
                delegate?.codeCaptured(metadataObj.stringValue)
                captureSession?.stopRunning()
            }
        }
    }
    
}
