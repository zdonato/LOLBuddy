//
//  SummonerInfoViewController.swift
//  LOLFun
//
//  Created by Zachary Donato on 7/15/15.
//  Copyright (c) 2015 Zachary Donato. All rights reserved.
//

import UIKit

class SummonerInfoViewController: UIViewController {

    @IBOutlet weak var summonerName: UILabel!
    var summString : String?;

    override func viewDidLoad() {
        super.viewDidLoad()
        
        summonerName.text = summString;

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
