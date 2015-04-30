//
//  StruxController.swift
//  projectF
//
//  Created by Robert Johansen on 4/18/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

import UIKit

class StruxController: UIViewController, UIWebViewDelegate, DigistruxDelegate {
    
    var model: Digistrux = Digistrux()
    
    func getStruxView() -> StruxView {return view as StruxView}
    
    override func loadView() {
        view = StruxView(frame: CGRectMake(0, 64, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
        getStruxView().delegate = self
        getStruxView().showActivityIndicator()
        var baseUrl: String = "http://www.robjohansen.com/strux/"
        var code: String    = "?code="     + model.getCurrentCode()
        var font: String    = "&fontName=" + model.getFontName()
        var size: String    = "&fontSize=" + String(model.getFontSize())
        var fullUrl: NSURL = NSURL(string: baseUrl + code + font + size)!
        getStruxView().loadRequest(NSURLRequest(URL: fullUrl))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var myBackButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        myBackButton.addTarget(self, action: "popToRoot", forControlEvents: UIControlEvents.TouchUpInside)
        myBackButton.setTitle("< home", forState: UIControlState.Normal)
        myBackButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        myBackButton.sizeToFit()
        
        var myCustomBackButtonItem:UIBarButtonItem = UIBarButtonItem(customView: myBackButton)
        self.navigationItem.leftBarButtonItem  = myCustomBackButtonItem
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        getStruxView().indicator?.stopAnimating()
    }
    
    func popToRoot() {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
}
