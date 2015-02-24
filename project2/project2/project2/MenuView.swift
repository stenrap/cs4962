//
//  MenuView.swift
//  project2
//
//  Created by Robert Johansen on 2/21/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

import UIKit

protocol MenuViewDelegate: class {
    
    func colorTouched()
    func watchTouched()
    
}

class MenuView: UIView {
    
    var colorButton: UIButton
    var watchButton: UIButton
    weak var delegate: MenuViewDelegate? = nil

    override init(frame: CGRect) {
        colorButton = UIButton(frame: CGRectMake(0, 0, frame.width / 2, frame.height))
        colorButton.backgroundColor = UIColor.redColor()
        colorButton.setTitle("Color", forState: .Normal)
        watchButton = UIButton(frame: CGRectMake(colorButton.frame.width, 0, frame.width / 2, frame.height))
        watchButton.backgroundColor = UIColor.brownColor()
        watchButton.setTitle("Watch", forState: .Normal)
        super.init(frame: frame)
        self.addSubview(colorButton)
        self.addSubview(watchButton)
        colorButton.addTarget(self, action: "colorTouched", forControlEvents: UIControlEvents.TouchUpInside)
        watchButton.addTarget(self, action: "watchTouched", forControlEvents: UIControlEvents.TouchUpInside)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        colorButton.frame = CGRectMake(0, 0, frame.width / 2, frame.height)
        watchButton.frame = CGRectMake(colorButton.frame.width, 0, frame.width / 2, frame.height)
    }
    
    func colorTouched() {
        delegate?.colorTouched()
    }
    
    func watchTouched() {
        delegate?.watchTouched()
    }
    
}
