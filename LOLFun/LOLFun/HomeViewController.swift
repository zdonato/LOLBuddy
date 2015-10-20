//
//  HomeViewController.swift
//  LOLFun
//
//  Created by Zachary Donato on 7/15/15.
//  Copyright (c) 2015 Zachary Donato. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
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
    
    private var region : String?;
    private var summonerInfo : JSON?;
    private var summonerId: String?;
    
    let helper = APIManager();
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.regionPicker?.delegate = self;
        self.regionPicker?.dataSource = self;
        self.summonerName?.delegate = self;
    }
    
    override func viewDidAppear(animated: Bool) {
        self.summonerName!.text = "";
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true);
    }
    
    // MARK: - UIPickerDelegate & DataSource
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return regions.count;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return regions[row];
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        region = regions[row];
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    

    // MARK: - Navigation
    
    @IBAction func searchSummoner()
    {
        helper.getBasicSummonerInfo(self.summonerName!.text!, region: region!)
        {
            (json) -> Void in
            dispatch_async(dispatch_get_main_queue()) {
            () -> Void in
                self.summonerInfo = json;
                
                // Convert summoner name to lower case and without white space for object name. 
                var cleanName = self.helper.cleanSummonerName(self.summonerName!.text!);
                
                cleanName = cleanName.lowercaseString;
                
                self.summonerId = json[cleanName]["id"].stringValue;
                
                self.performSegueWithIdentifier("showSummonerInfo", sender: self);
            }
        };
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        print(summonerName!.text);
        
        let destination: SummonerInfoViewController = segue.destinationViewController as! SummonerInfoViewController;
        
        destination.setSummonerInfo(self.summonerInfo!);
        destination.setSummonerId(self.summonerId!);
        destination.setRegion(self.region!);
        destination.setSummonerName(self.summonerName!.text!); 
    }
    
    
}
