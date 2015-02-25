//
//  PlayView.swift
//  project2
//
//  Created by Robert Johansen on 2/24/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

import UIKit

protocol PlayDelegate: class {
    
    
    
}

class PlayView: UIView {
    
    var playButton: UIButton
    var playTrack: UISlider
    
    override init(frame: CGRect) {
        playButton = UIButton(frame: CGRectZero)
        playButton.setTitle("Play", forState: .Normal)
        playButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        playTrack = UISlider(frame: CGRectZero)
        super.init(frame: frame)
        self.addSubview(playButton)
        self.addSubview(playTrack)
        playButton.addTarget(self, action: "playTouched", forControlEvents: UIControlEvents.TouchUpInside)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        playButton.frame = CGRectMake(0, 0, frame.width / 4, frame.height)
        playTrack.frame = CGRectMake(frame.width / 4 + 20, 0, ((3 * frame.width) / 4 - 40), frame.height)
    }
    
    func playTouched() {
        var wasPlaying: Bool = playButton.titleLabel!.text == "Play"
        playButton.setTitle(wasPlaying ? "Stop" : "Play", forState: .Normal)
    }
    
}
