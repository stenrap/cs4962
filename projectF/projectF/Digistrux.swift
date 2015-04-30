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
    
    private var currentCode: String = ""
    func getCurrentCode() -> String {return currentCode}
    private func setCurrentCode(code: String) {
        currentCode = code[find(code, ",")!.successor() ..< code.endIndex]
    }
    
    /* Default App Settings */
    private var fontName: String = "Arial"
    func getFontName() -> String {return fontName}
    func setFontName(fontName: String) {
        self.fontName = fontName
        writeToFile()
    }
    
    private var fontSize: Int = 16
    func getFontSize() -> Int {return fontSize}
    func setFontSize(fontSize: Int) {
        self.fontSize = fontSize
        writeToFile()
    }
    
    private var updates: String = "doc"
    func getUpdates() -> String {return updates}
    func setUpdates(updates: String) {
        self.updates = updates
        writeToFile()
    }
    
    private var strux: [String] = [String]()
    func getStrux() -> [String] {return strux}
    
    func getStruxLabel(index: Int) -> String {
        var struxLabel: String = ""
        if (index < strux.count) {
            var labelWithCode: String = strux[index]
            var labelWithUnderScores: String = labelWithCode[labelWithCode.startIndex ..< find(labelWithCode, ",")!]
            struxLabel = labelWithUnderScores.stringByReplacingOccurrencesOfString("_", withString: " ", options: .LiteralSearch, range: nil)
        }
        return struxLabel
    }
    
    func addToStrux(code: String) {
        var alreadyHaveCode: Bool = false
        for (var i: Int = 0; i < strux.count; i++) {
            if (strux[i] == code) {
                alreadyHaveCode = true
                break
            }
        }
        if (!alreadyHaveCode) {
            strux.append(code)
            writeToFile()
        }
        setCurrentCode(code)
    }
    
    func setStrux(index: Int) {
        setCurrentCode(strux[index])
    }
    
    private func getModelPath() -> String {
        let documentsDirectory: String? = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)?[0] as String?
        var filePath: String? = documentsDirectory?.stringByAppendingPathComponent("digistrux.plist")
        
        /*
        let env = NSProcessInfo.processInfo().environment
        if let local = env["ROB_LOCAL"] as? String {
            filePath = local
        }
        */
        
        return filePath!
    }
    
    func readFromFile() {
        var rawModel: NSDictionary? = NSDictionary(contentsOfFile: getModelPath())
        if (rawModel != nil) {
            var rawStrux: NSArray = rawModel!.objectForKey("strux") as NSArray
            for (var i: Int = 0; i < rawStrux.count; i++) {
                strux.append(rawStrux[i] as NSString)
            }
            
            var settings: NSDictionary = rawModel!.objectForKey("settings") as NSDictionary
            updates = settings.objectForKey("updates") as NSString
            
            var font: NSDictionary = settings.objectForKey("font") as NSDictionary
            fontName = font.objectForKey("name") as NSString
            fontSize = font.objectForKey("size") as Int
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
        
        var result: Bool = model.writeToFile(getModelPath(), atomically: true)
    }
    
    /*
        http://www.robjohansen.com/strux?code=9F8ED514-4081-4C3E-A1AC-273445D81AE9&fontName=Arial&fontSize=14
        
        IKEA Drawer: http://www.ikea.com/ms/en_US/customer_service/assembly/A/A70069977.pdf
    
        Rubbermaid Decorative Bracket: http://s7d2.scene7.com/is/content/RubbermaidConsumer/PDF/54155%20RM%2013-CO-188%20Decor%20Bracket%20Installation%20V1R2.pdf
    
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
                "IKEA_Drawer,9F8ED514-4081-4C3E-A1AC-273445D81AE9",                    //  qrcode1.png
                "Rubbermaid_Decorative_Bracket,6768A4BE-8146-4049-B426-142457287E4D"   //  qrcode2.png
            ]
        }
    */
    
}
