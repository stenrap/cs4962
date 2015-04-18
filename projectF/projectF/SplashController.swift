//
//  SplashController.swift
//  projectF
//
//  Created by Robert Johansen on 4/11/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

import UIKit

protocol SplashControllerDelegate: class {
    
    func splashTimeOut()
    
}

class SplashController: UIViewController {
    
    var delegate: SplashControllerDelegate? = nil
    
    func getSplashView() -> SplashView {return view as SplashView}
    
    override func loadView() {
        view = SplashView()
        view.backgroundColor = UIColor(red: 59/255, green: 89/255, blue: 152/255, alpha: 1.0)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        UIView.animateWithDuration(0.75, delay: 2.5, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.getSplashView().alpha = 0.0
            }, completion: timeOut) 
    }
    
    func timeOut(complete: Bool) {
        delegate?.splashTimeOut()
    }

}

