//
//  StruxView.swift
//  projectF
//
//  Created by Robert Johansen on 4/18/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

import UIKit

class StruxView: UIWebView {
    
    var indicator: UIActivityIndicatorView? = nil
    
    func showActivityIndicator() {
        var bw: CGFloat = bounds.width
        var bh: CGFloat = bounds.height
        var size: CGFloat = 200
        indicator = UIActivityIndicatorView(frame: CGRectMake((bw - size) / 2, (bh - size) / 2, size, size))
        indicator?.hidesWhenStopped = true
        indicator?.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        indicator?.startAnimating()
        self.addSubview(indicator!)
    }
    
}
