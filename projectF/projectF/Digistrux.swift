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
    
    /* Default App Settings */
    private var fontName: String = "Arial"
    private var fontSize: Int = 14
    private var updates: String = "doc"
    private var strux: [String] = ["9F8ED514-4081-4C3E-A1AC-273445D81AE9", "6768A4BE-8146-4049-B426-142457287E4D"]
    
    private func getModelPath() -> String {
        let documentsDirectory: String? = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)?[0] as String?
        var filePath: String? = documentsDirectory?.stringByAppendingPathComponent("digistrux.plist")
        
        let env = NSProcessInfo.processInfo().environment
        if let local = env["ROB_LOCAL"] as? String {
            filePath = local
        }
        
        return filePath!
    }
    
    func readFromFile() {
        var rawModel: NSDictionary? = NSDictionary(contentsOfFile: getModelPath())
        if (rawModel != nil) {
            var rawStrux: NSArray = rawModel!.objectForKey("strux") as NSArray
            for (var i: Int = 0; i < rawStrux.count; i++) {
                // WYLO .... Your last thought was: Oops, there's no name associated with each strux UUID...
            }
        }
    }
    
    private func writeToFile() {
        var model: NSMutableDictionary = NSMutableDictionary()
        var settings: NSMutableDictionary = NSMutableDictionary()
        var font: NSMutableDictionary = NSMutableDictionary()
        
        font.setObject(fontName, forKey: "name")
        font.setObject(fontSize, forKey: "size")
        settings.setObject(font, forKey: "font")
        settings.setObject(updates, forKey: "updates")
        
        var rawStrux: NSMutableArray = []
        for (var i: Int = 0; i < strux.count; i++) {
            rawStrux.addObject(strux[i])
        }
        
        model.setObject(settings, forKey: "settings")
        model.setObject(rawStrux, forKey: "strux")
        
        model.writeToFile(getModelPath(), atomically: true)
    }
    
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
