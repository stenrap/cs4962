//
//  StatusView.swift
//  project3
//
//  Created by Robert Johansen on 3/30/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

import UIKit

protocol StatusViewDelegate: class {
    
    func waitingTouched()
    func playingTouched()
    func doneTouched()
    
}

class StatusView: UIView {
    
    private var waitingButton: UIButton
    private var playingButton: UIButton
    private var doneButton: UIButton
    weak var delegate: StatusViewDelegate? = nil
    private let BUTTON_HEIGHT: CGFloat = 50
    
    override init(frame: CGRect) {
        waitingButton = UIButton(frame: CGRectMake(frame.width / 4, 99, frame.width / 2, BUTTON_HEIGHT))
        waitingButton.backgroundColor = UIColor.blueColor()
        waitingButton.setTitle("Waiting", forState: .Normal)
        
        playingButton = UIButton(frame: CGRectMake(frame.width / 4, 183, frame.width / 2, BUTTON_HEIGHT))
        playingButton.backgroundColor = UIColor.blueColor()
        playingButton.setTitle("Playing", forState: .Normal)
        
        doneButton = UIButton(frame: CGRectMake(frame.width / 4, 267, frame.width / 2, BUTTON_HEIGHT))
        doneButton.backgroundColor = UIColor.blueColor()
        doneButton.setTitle("Done", forState: .Normal)
        
        super.init(frame: frame)
        
        self.addSubview(waitingButton)
        self.addSubview(playingButton)
        self.addSubview(doneButton)
        
        waitingButton.addTarget(self, action: "waitingTouched", forControlEvents: UIControlEvents.TouchUpInside)
        playingButton.addTarget(self, action: "playingTouched", forControlEvents: UIControlEvents.TouchUpInside)
        doneButton.addTarget(self, action: "doneTouched", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func waitingTouched() {
        delegate?.waitingTouched()
    }
    
    func playingTouched() {
        delegate?.playingTouched()
    }
    
    func doneTouched() {
        delegate?.doneTouched()
    }
    
}