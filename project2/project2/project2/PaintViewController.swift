//
//  PaintViewController
//  project2
//
//  Created by Robert Johansen on 2/21/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

import UIKit

class PaintViewController: UIViewController {

    var paintView: PaintView { return view as PaintView }
    
    override func loadView() {
        view = PaintView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Paint"
    }

}

