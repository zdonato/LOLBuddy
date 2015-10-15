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
    private let kBaseDomain   : String = "api.pvp.net/";
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
    
    // MARK: Game Info URL's
    private let kInGameInfoURL      : String = "observer-mode/rest/consumer/getSpectatorGameInfo/"
    
    override init()
    {
        super.init();
    }
    
    // Function to clean the summoner name of spaces. 
    // 
    // @param summonerName : The name of the summoner to clean. 
    // 
    // @return Returns the cleaned up summoner name, devoid of spaces
    private func cleanSummonerName(summonerName : String) -> String
    {
        return "".join(map(summonerName.generate()) {
            $0 == " " ? "" : String($0)
        })
    }
    
    // Function to map the regions to a platform ID. 
    // 
    // @param region : The region to map
    // 
    // @return Returns the platform ID of the region
    func getPlatformIDForRegion(region : String) -> String {
        var platformID : String;
        switch (region) {
            case "BR" :
                platformID = "BR1";
            case "EUNE" :
                platformID = "EUN1";
            case "EUW" :
                platformID = "EUW1";
            case "KR" :
                platformID = "KR";
            case "LAN" :
                platformID = "LA1";
            case "LAS" :
                platformID = "LA2";
            case "NA" :
                platformID = "NA1";
            case "OCE" :
                platformID = "OC1";
            case "RU" :
                platformID = "RU";
            case "TR" :
                platformID = "TR1";
            default :
                platformID = "";
        }
        
        return platformID;
    }

    // Function to get basic summoner info. 
    //
    // @param summonerName : The name of the summoner
    // @param region : The region of the summoner
    // @param completion : Completion block to run once the data is returned
    //
    // @return Returns summoner info in JSON format in the completion block.
    func getBasicSummonerInfo(summonerName : String, region: String, completion: (json: JSON) -> Void)
    {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration();
        let session = NSURLSession(configuration: config);
        var request = NSMutableURLRequest();
        
        // Clean the summoner name of spaces. 
        var cleanName = cleanSummonerName(summonerName);
        
        request.URL = NSURL(string: "https://\(region).\(self.kBaseURL)\(region)/\(self.kBasicSummonerInfoURL)\(cleanName)\(self.kAPIKey)");
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
    
    // Function to get the in game information of a summoner.
    //
    // @param summonerName : The name of the summoner
    // @param region : The region of the summoner 
    // @param completion : The completion block to run once the data is returned
    //
    // @return Returns in game information in JSON format
    func getInGameInformationForSummoner(summonerID : String, region: String, completion: (json : JSON) -> Void)
    {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration();
        let session = NSURLSession(configuration: config);
        var request = NSMutableURLRequest();
        var platformID = getPlatformIDForRegion(region);
        request.URL = NSURL(string: "https://\(region).\(self.kBaseDomain)\(self.kInGameInfoURL)\(platformID)/\(summonerID)\(self.kAPIKey)");
                
        request.HTTPMethod = "GET";
        NSLog("Starting request for \(summonerID)");
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