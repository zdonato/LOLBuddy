//
//  SummonerInfoViewController.swift
//  LOLFun
//
//  Created by Zachary Donato on 7/15/15.
//  Copyright (c) 2015 Zachary Donato. All rights reserved.
//

import UIKit

class SummonerInfoViewController: UIViewController {

    @IBOutlet weak var summonerName: UILabel!;
    @IBOutlet weak var region: UILabel!;
    @IBOutlet weak var id: UILabel!;
    @IBOutlet weak var level: UILabel!;
    
    var summonerInfo : JSON?;
    var summString : String?;
    var regionString : String?;
    var idString : String?;
    var levelString : String?;

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        summonerName.text = "Summoner Name: \(summString!)";
        region.text = "Region: \(regionString!)";
        id.text = "ID: \(idString!)";
        level.text = "Level: \(levelString!)";
        
        println(summonerInfo); 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back()
    {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        });
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
