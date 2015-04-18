//
//  Digistrux.swift
//  projectF
//
//  Created by Robert Johansen on 4/18/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

import Foundation

protocol DigistruxDelegate: class {
    
    
    
}

class Digistrux {
    
    weak var delegate: DigistruxDelegate? = nil
    
    /*
        http://www.robjohansen.com/strux?code=9F8ED514-4081-4C3E-A1AC-273445D81AE9&fontName=Arial&fontSize=14
        
        {
            settings:
            {
                font:
                {
                    name: "Arial",
                    size: "14"
                },
                updates: "doc"
            },
            strux:
            [
                "9F8ED514-4081-4C3E-A1AC-273445D81AE9",  //  qrcode1.png
                "6768A4BE-8146-4049-B426-142457287E4D"   //  qrcode2.png
            ]
        }
    */
    
}
