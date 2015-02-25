//
//  PaintViewController
//  project2
//
//  Created by Robert Johansen on 2/21/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

import UIKit

class PaintViewController: UIViewController, MenuViewDelegate, ColorDelegate, PaintViewDelegate {

    var model: DrawingModel = DrawingModel()
    var paintView: PaintView { return view as PaintView }
    var colorViewController: ColorViewController = ColorViewController()
    var watchViewController: WatchViewController = WatchViewController()
    
    override func loadView() {
        view = PaintView(frame: CGRectMake(0, 64, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 64))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        paintView.menuView.delegate = self
        colorViewController.colorView.delegate = self
        title = "Paint"
    }
    
    func colorTouched() {
        navigationController?.pushViewController(colorViewController, animated: true)
    }
    
    func watchTouched() {
        navigationController?.pushViewController(watchViewController, animated: true)
    }
    
    func setColor(color: UIColor) {
        model.color = color
        paintView.setColor(color)
        navigationController?.popViewControllerAnimated(true)
    }
    
    func addPolyLine(polyline: [CGPoint]) {
        
    }

}

