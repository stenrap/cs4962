//
//  MenuView.swift
//  project2
//
//  Created by Robert Johansen on 2/21/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

import UIKit

class MenuView: UIView {
    
    private var colorButton: UIButton
    private var watchButton: UIButton

    override init(frame: CGRect) {
        colorButton = UIButton(frame: CGRectMake(0, 0, frame.width / 2, frame.height))
        colorButton.backgroundColor = UIColor.redColor()
        colorButton.setTitle("Color", forState: .Normal)
        watchButton = UIButton(frame: CGRectMake(colorButton.frame.width, 0, frame.width / 2, frame.height))
        watchButton.backgroundColor = UIColor.blueColor()
        watchButton.setTitle("Watch", forState: .Normal)
        super.init(frame: frame)
        self.addSubview(colorButton)
        self.addSubview(watchButton)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        colorButton.frame = CGRectMake(0, 0, frame.width / 2, frame.height)
        watchButton.frame = CGRectMake(colorButton.frame.width, 0, frame.width / 2, frame.height)
    }
    
}
