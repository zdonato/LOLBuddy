//
//  SummonerInfoViewController.swift
//  LOLFun
//
//  Created by Zachary Donato on 7/15/15.
//  Copyright (c) 2015 Zachary Donato. All rights reserved.
//

import UIKit

class SummonerInfoViewController: UIViewController {
    
    @IBOutlet weak var summonerNameLabel: UILabel!
    @IBOutlet weak var divisionNameLabel: UILabel!
    @IBOutlet weak var winLossLabel: UILabel!
    @IBOutlet weak var tierLabel: UILabel!
    @IBOutlet weak var divisionImage: UIImageView!

    // Cached info to store.
    private var summonerInfo : JSON?;
    private var summonerId : String?;
    private var region : String?
    private var summonerName : String?
    private let kRankedSoloQueue : String = "RANKED_SOLO_5x5";
    private var inGameInfo : JSON?;
    
    let helper = APIManager();

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(summonerInfo);
        
        // Set title to the summoner name
        self.title = self.summonerName!; 
        
        // Get the ranked information for the summoner. 
        dispatch_async(dispatch_get_main_queue()) {
            self.helper.getRankedInformationForSummonerById([self.summonerId!], region: self.region!.lowercaseString)
                {
                    (json) -> Void in
                    self.summonerInfo = json;
                    print(json);
                    self.setUpUI(json);
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func getInGameInfo()
    {
        dispatch_async(dispatch_get_main_queue())
        {
            self.helper.getInGameInformationForSummonerById(self.summonerId!, region: self.region!)
            {
                (json) -> Void in
                self.inGameInfo = json;
                self.performSegueWithIdentifier("showInGameInfo", sender: self);
            }
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let destination : InGameInfoViewController = segue.destinationViewController as! InGameInfoViewController;
        
        destination.setInGameInfo(self.inGameInfo!);
    }

    
    // MARK : Getters and Setters
    func getSummonerInfo () -> JSON
    {
        return self.summonerInfo!;
    }
    
    func setSummonerInfo(json: JSON)
    {
        self.summonerInfo = json;
    }
    
    func getSummonerId () -> String
    {
        return self.summonerId!;
    }
    
    func setSummonerId(id: String)
    {
        self.summonerId = id;
    }
    
    func getRegion () -> String
    {
        return self.region!;
    }
    
    func setRegion(id: String)
    {
        self.region = id;
    }
    
    func getSummonerName () -> String
    {
        return self.summonerName!;
    }
    
    func setSummonerName(name: String)
    {
        self.summonerName = name;
    }

    func setUpUI(json: JSON)
    {
        dispatch_async(dispatch_get_main_queue())
        {
            let soloQueueIndex          = self.findRankedSolo(json, id: self.summonerId!);
            let soloQueueObject         = json[self.summonerId!][soloQueueIndex];
            let tier                    = soloQueueObject["tier"].stringValue.lowercaseString;
            var division : String       = ""
            if (tier != "challenger" && tier != "master")
            {
                division = soloQueueObject["entries"][0]["division"].stringValue.lowercaseString;
            }
            self.divisionImage.image    = self.helper.getImageForDivisionByName(tier, division: division);
            self.divisionNameLabel.text = soloQueueObject["name"].stringValue;
            self.winLossLabel.text      = String(soloQueueObject["entries"][0]["wins"].intValue) + "W  " +  String(soloQueueObject["entries"][0]["losses"].intValue) + "L";
            self.tierLabel.text         = soloQueueObject["tier"].stringValue.lowercaseString.capitalizedString + " " + soloQueueObject["entries"][0]["division"].stringValue + "  " + String(soloQueueObject["entries"][0]["leaguePoints"].intValue) + "LP";
        }
    }
    
    func findRankedSolo(json: JSON, id : String) -> Int
    {
        for (var i = 0; i < json[id].count; i++)
        {
            if (json[id][i]["queue"].stringValue == self.kRankedSoloQueue)
            {
                return i;
            }
        }
        
        return -1;
    }

}
