//
//  LOLAPIHelper.swift
//  LOLFun
//
//  Created by Zachary Donato on 7/15/15.
//  Copyright (c) 2015 Zachary Donato. All rights reserved.
//

import Foundation

class APIManager : NSObject {

    // MARK: API Key + Base URL
    private let kAPIKey       : String = "?api_key=cdc51250-ae2b-440d-b750-9f6810468660";
    private let kBaseURL      : String = "api.pvp.net/api/lol/";
    private let kStaticURL    : String = "api.pvp.net/api/lol/static-data/";
    private let kBaseImageURL : String = "http://ddragon.leagueoflegends.com/cdn/5.2.1/img/";

    // MARK: Summoner Info URL's
    private let kBasicSummonerInfoURL : String = "v1.4/summoner/by-name/";

    // MARK: Static API Data
    private let kChampionsURL       : String = "v1.2/champion";
    private let kItemURL            : String = "v1.2/item";
    private let kMasteryURL         : String = "v1.2/mastery";
    private let kRuneURL            : String = "v1.2/rune";
    private let kSummonerSpell      : String = "v1.2/summoner-spell";
    
    override init()
    {
        super.init();
    }

    // Function to get basic summoner info. 
    // Returns summoner info in JSON format in the completion block.
    func getBasicSummonerInfo(summonerName : String, region: String, completion: (json: JSON) -> Void)
    {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration();
        let session = NSURLSession(configuration: config);
        var request = NSMutableURLRequest();
        
        // Clean the summoner name of spaces. 
        var cleanName = "".join(map(summonerName.generate()) {
            $0 == " " ? "" : String($0)
        })
        
        request.URL = NSURL(string: "https://\(region).\(kBaseURL)\(region)/\(kBasicSummonerInfoURL)\(cleanName)\(kAPIKey)");
        request.HTTPMethod = "GET";
        
        NSLog("Starting request for \(summonerName)");
        let task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
                if (error != nil)
                {
                    println(error);
                }
                else
                {
                    let jsonObject = JSON(data: data);
                    completion(json: jsonObject);
                }
        }
        
        task.resume();
    }

}