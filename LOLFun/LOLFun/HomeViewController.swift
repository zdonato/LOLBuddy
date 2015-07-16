//
//  HomeViewController.swift
//  LOLFun
//
//  Created by Zachary Donato on 7/15/15.
//  Copyright (c) 2015 Zachary Donato. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var summonerName: UITextField?;
    @IBOutlet weak var regionPicker: UIPickerView?;
    
    private let regions = [ "BR",
                            "EUNE",
                            "EUW",
                            "KR",
                            "LAN",
                            "LAS",
                            "NA",
                            "OCE",
                            "RU",
                            "TR"
                            ]
    
    private var selectedRegion : String?;
    private var summonerInfo : JSON?;
    private var idString: String?;
    private var levelString: String?;
    private var summonerString : String?;
    
    let helper = APIManager();
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.regionPicker?.delegate = self;
        self.regionPicker?.dataSource = self;
    }
    
    override func viewDidAppear(animated: Bool) {
        self.summonerName!.text = "";
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UIPickerDelegate & DataSource
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return regions.count;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return regions[row];
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRegion = regions[row];
    }
    

    // MARK: - Navigation
    
    @IBAction func searchSummoner()
    {
        helper.getBasicSummonerInfo(summonerName!.text, region: selectedRegion!)
        {
            (json) -> Void in
            dispatch_async(dispatch_get_main_queue()) {
            () -> Void in
                self.summonerInfo = json;
                
                // Convert summoner name to lower case and without white space for object name. 
                var cleanName = "".join(map(self.summonerName!.text.generate()) {
                    $0 == " " ? "" : String($0)
                })
                
                cleanName = cleanName.lowercaseString;
                
                self.idString       = json[cleanName]["id"].stringValue;
                self.levelString    = String(json[cleanName]["summonerLevel"].intValue);
                self.summonerString = json[cleanName]["name"].stringValue;
                
                self.performSegueWithIdentifier("showSummonerInfo", sender: self);
            }
        };
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        println(summonerName!.text);
        
        let destination: SummonerInfoViewController = segue.destinationViewController as! SummonerInfoViewController;
        
        destination.summString   = self.summonerString;
        destination.regionString = self.selectedRegion;
        destination.summonerInfo = self.summonerInfo;
        destination.idString     = self.idString;
        destination.levelString  = self.levelString;
    }
}
