//
//  ScanController.swift
//  projectF
//
//  Created by Robert Johansen on 4/18/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

import UIKit
import AVFoundation

class ScanController: UIViewController, DigistruxDelegate, ScanDelegate {
    
    var model: Digistrux = Digistrux()
    
    func getScanView() -> ScanView {return view as ScanView}
    
    override func loadView() {
        view = ScanView()
        getScanView().delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getScanView().startCapture()
    }
    
    func codeCaptured(code: String) {
        model.addToStrux(code)
        var struxController: StruxController = StruxController()
        struxController.model = model
        struxController.model.delegate = struxController
        navigationController?.pushViewController(struxController, animated: true)
    }
    
}
