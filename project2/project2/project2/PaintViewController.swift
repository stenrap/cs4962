//
//  PaintViewController
//  project2
//
//  Created by Robert Johansen on 2/21/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

import UIKit

class PaintViewController: UIViewController, MenuViewDelegate {

    var paintView: PaintView { return view as PaintView }
    var colorWheelViewController: ColorWheelViewController = ColorWheelViewController()
    var watchViewController: WatchViewController = WatchViewController()
    
    override func loadView() {
        view = PaintView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        paintView.menuView.delegate = self
        title = "Paint"
    }
    
    func colorTouched() {
        navigationController?.pushViewController(colorWheelViewController, animated: true)
    }
    
    func watchTouched() {
        navigationController?.pushViewController(watchViewController, animated: true)
    }

}

