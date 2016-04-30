//
//  InGameInfoViewController.swift
//  LOLFun
//
//  Created by Zachary Donato on 10/24/15.
//  Copyright © 2015 Zachary Donato. All rights reserved.
//

import UIKit

class InGameInfoViewController: UIViewController {
    
    private var inGameInfo : JSON?; 

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .Fade);
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.

    }
    
    func setInGameInfo(info : JSON)
    {
        self.inGameInfo = info; 
    }
    
    @IBAction func close()
    {
        self.dismissViewControllerAnimated(true){Void in};
    }

}
