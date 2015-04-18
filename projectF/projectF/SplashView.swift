//
//  SplashView.swift
//  projectF
//
//  Created by Robert Johansen on 4/11/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

import UIKit

class SplashView: UIView {
    
    override func layoutSubviews() {
        if (self.subviews.count == 0) {
            var sw: CGFloat = UIScreen.mainScreen().bounds.width
            var sh: CGFloat = UIScreen.mainScreen().bounds.height
            
            var digistruxLabel: UILabel = UILabel(frame: CGRectMake(0, 90, sw, 50))
            digistruxLabel.textColor = UIColor.whiteColor()
            digistruxLabel.font = UIFont(name: digistruxLabel.font.fontName, size: 33)
            digistruxLabel.textAlignment = NSTextAlignment.Center
            digistruxLabel.text = "digistrux"
            
            var image: UIImage = UIImage(named: "document.png")!
            var iw: CGFloat = image.size.width
            var ih: CGFloat = image.size.height
            
            var documentImage: UIImageView = UIImageView(image: image)
            documentImage.frame = CGRectMake((sw - iw) / 2, (sh - ih) / 2, iw, ih)
            
            self.addSubview(digistruxLabel)
            self.addSubview(documentImage)
        }
    }
    
}
