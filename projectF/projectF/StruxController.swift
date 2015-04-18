//
//  StruxController.swift
//  projectF
//
//  Created by Robert Johansen on 4/18/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

import UIKit

class StruxController: UIViewController, DigistruxDelegate {
    
    var model: Digistrux = Digistrux()
    
    func getStruxView() -> StruxView {return view as StruxView}
    
    override func loadView() {
        view = StruxView()
    }
    
}
