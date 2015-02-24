//
//  ColorView.swift
//  project2
//
//  Created by Robert Johansen on 2/23/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

import UIKit

protocol ColorDelegate: class {
    
    func setColor(color:UIColor)
    
}

class ColorView: UIView {
    
    private var buttons = [UIButton]()
    weak var delegate: ColorDelegate? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        for (var i = 0; i <= 15; i++) {
            var button = UIButton(frame: CGRectZero)
            switch i {
                case 0:
                    button.setTitle("Silver", forState: .Normal)
                    button.backgroundColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0)
                case 1:
                    button.setTitle("Gray", forState: .Normal)
                    button.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
                case 2:
                    button.setTitle("Black", forState: .Normal)
                    button.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
                case 3:
                    button.setTitle("Red", forState: .Normal)
                    button.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
                case 4:
                    button.setTitle("Maroon", forState: .Normal)
                    button.backgroundColor = UIColor(red: 0.5, green: 0.0, blue: 0.0, alpha: 1.0)
                case 5:
                    button.setTitle("Yellow", forState: .Normal)
                    button.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 1.0)
                    button.setTitleColor(UIColor.blackColor(), forState: .Normal)
                case 6:
                    button.setTitle("Olive", forState: .Normal)
                    button.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.0, alpha: 1.0)
                case 7:
                    button.setTitle("Lime", forState: .Normal)
                    button.backgroundColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
                case 8:
                    button.setTitle("Green", forState: .Normal)
                    button.backgroundColor = UIColor(red: 0.0, green: 0.5, blue: 0.0, alpha: 1.0)
                case 9:
                    button.setTitle("Aqua", forState: .Normal)
                    button.backgroundColor = UIColor(red: 0.0, green: 1.0, blue: 1.0, alpha: 1.0)
                case 10:
                    button.setTitle("Teal", forState: .Normal)
                    button.backgroundColor = UIColor(red: 0.0, green: 0.5, blue: 0.5, alpha: 1.0)
                case 11:
                    button.setTitle("Blue", forState: .Normal)
                    button.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)
                case 12:
                    button.setTitle("Navy", forState: .Normal)
                    button.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.5, alpha: 1.0)
                case 13:
                    button.setTitle("Fuchsia", forState: .Normal)
                    button.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 1.0, alpha: 1.0)
                case 14:
                    button.setTitle("Purple", forState: .Normal)
                    button.backgroundColor = UIColor(red: 0.5, green: 0.0, blue: 0.5, alpha: 1.0)
                default:
                    button.setTitle("Orange", forState: .Normal)
                    button.backgroundColor = UIColor(red: 1.0, green: 0.65, blue: 0.0, alpha: 1.0)
            }
            button.addTarget(self, action: "setColor:", forControlEvents: UIControlEvents.TouchUpInside)
            self.addSubview(button)
            buttons.append(button)
        }
        setNeedsLayout()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        var buttonX: CGFloat = 0
        var buttonY: CGFloat = 64
        for (var i = 0; i <= 15; i++) {
            var button = buttons[i]
            button.frame = CGRectMake(buttonX, buttonY, 70, 30)
            if (buttonX + 150 >= self.bounds.width) {
                buttonX = 0
                buttonY += 40
            } else {
                buttonX += 80
            }
        }
    }
    
    func setColor(button:UIButton!) {
        delegate?.setColor(button.backgroundColor!)
    }
    
}
