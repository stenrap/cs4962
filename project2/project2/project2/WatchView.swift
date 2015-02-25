//
//  WatchView.swift
//  project2
//
//  Created by Robert Johansen on 2/21/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

import UIKit

class WatchView: UIView {
    
    private let BUTTON_HEIGHT: CGFloat = 50
    var playView: PlayView
    
    override init(frame: CGRect) {
        playView = PlayView(frame: CGRectMake(0, frame.height - BUTTON_HEIGHT, frame.width, BUTTON_HEIGHT))
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        self.addSubview(playView)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        playView.frame = CGRectMake(0, frame.height - BUTTON_HEIGHT, frame.width, BUTTON_HEIGHT)
    }
    
}
