//
//  project0
//
//  Created by
//  Rob Johansen
//  u0531837
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var sliderBox: UIView?
    var xSlider: UISlider?
    var ySlider: UISlider?
    var xValue: UILabel?
    var yValue: UILabel?
    var plusValue: UILabel?
    var timesValue: UILabel?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = UIColor.lightGrayColor()
        
        var screenWidth = UIScreen.mainScreen().bounds.width
        var screenHeight = UIScreen.mainScreen().bounds.height
        var sliderBoxHeight = 200 as CGFloat
        sliderBox = UIView(frame: CGRectMake(0, (screenHeight - sliderBoxHeight) / 2, screenWidth, sliderBoxHeight))    
        
        var leftLabelX = 60 as CGFloat
        var xLeftLabel = UILabel(frame: CGRectMake(leftLabelX, 0, 20, 20))
        xLeftLabel.text = "X"
        
        var yLeftLabel = UILabel(frame: CGRectMake(leftLabelX, 50, 20, 20))
        yLeftLabel.text = "Y"
        
        var sliderWidth = screenWidth - 150
        xSlider = UISlider(frame: CGRectMake(sliderWidth / 2, 0,  sliderWidth, 20))
        ySlider = UISlider(frame: CGRectMake(sliderWidth / 2, 50, sliderWidth, 20))
        
        var rightLabelX = xSlider!.bounds.origin.x + xSlider!.bounds.width + 90
        xValue = UILabel(frame: CGRectMake(rightLabelX, 0, 80, 20))
        yValue = UILabel(frame: CGRectMake(rightLabelX, 50, 80, 20))
        
        var resultLabelX = 100 as CGFloat
        plusValue = UILabel(frame: CGRectMake(resultLabelX, 100, 180, 20))
        timesValue = UILabel(frame: CGRectMake(resultLabelX, 150, 180, 20))
        
        sliderBox!.addSubview(xLeftLabel)
        sliderBox!.addSubview(yLeftLabel)
        sliderBox!.addSubview(xSlider!)
        sliderBox!.addSubview(ySlider!)
        sliderBox!.addSubview(xValue!)
        sliderBox!.addSubview(yValue!)
        sliderBox!.addSubview(plusValue!)
        sliderBox!.addSubview(timesValue!)
        
        window!.addSubview(sliderBox!)
        
        xSlider!.addTarget(self, action: "onChangeX", forControlEvents: UIControlEvents.ValueChanged)
        ySlider!.addTarget(self, action: "onChangeY", forControlEvents: UIControlEvents.ValueChanged)
        
        onChangeX()
        onChangeY()
        
        return true
    }
    
    func changeArithmeticLabels() {
        plusValue!.text = "X + Y: \(xSlider!.value + ySlider!.value)"
        timesValue!.text = "X * Y: \(xSlider!.value * ySlider!.value)"
    }
    
    func onChangeX() {
        xValue!.text = "\(xSlider!.value)"
        changeArithmeticLabels()
    }
    
    func onChangeY() {
        yValue!.text = "\(ySlider!.value)"
        changeArithmeticLabels()
    }

    
/* The following methods are not required

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
*/

    
}

