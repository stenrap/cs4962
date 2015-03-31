//
//  RotatePlaceView.swift
//  project3
//
//  Created by Robert Johansen on 3/13/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

import UIKit

protocol RotatePlaceViewDelegate: class {
    
    func rotateTouched()
    func confirmTouched()
    
}

class RotatePlaceView: UIView {
    
    private var rotateButton: UIButton
    private var confirmButton: UIButton
    weak var delegate: RotatePlaceViewDelegate? = nil
    
    override init(frame: CGRect) {
        rotateButton = UIButton(frame: CGRectMake(0, 0, frame.width / 2, frame.height))
        rotateButton.backgroundColor = UIColor.whiteColor()
        rotateButton.setTitle("Rotate", forState: .Normal)
        rotateButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        
        confirmButton = UIButton(frame: CGRectMake(rotateButton.frame.width, 0, frame.width / 2, frame.height))
        confirmButton.backgroundColor = UIColor.greenColor()
        confirmButton.setTitle("Confirm", forState: .Normal)
        confirmButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        
        super.init(frame: frame)
        
        self.addSubview(rotateButton)
        self.addSubview(confirmButton)
        
        rotateButton.addTarget(self, action: "rotateTouched", forControlEvents: UIControlEvents.TouchUpInside)
        confirmButton.addTarget(self, action: "confirmTouched", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        rotateButton.frame = CGRectMake(0, 0, frame.width / 2, frame.height)
        confirmButton.frame = CGRectMake(rotateButton.frame.width, 0, frame.width / 2, frame.height)
    }
    
    func rotateTouched() {
        delegate?.rotateTouched()
    }
    
    func confirmTouched() {
        delegate?.confirmTouched()
    }
    
}
