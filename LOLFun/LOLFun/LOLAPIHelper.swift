//
//  LOLAPIHelper.swift
//  LOLFun
//
//  Created by Zachary Donato on 7/15/15.
//  Copyright (c) 2015 Zachary Donato. All rights reserved.
//

import Foundation
import UIKit

class APIManager : NSObject {

    // MARK: String Constants
    private let kEntry : String = "entry"
    
    // MARK: API Key + Base URL
    private let kAPIKey       : String = "?api_key=cdc51250-ae2b-440d-b750-9f6810468660";
    private let kBaseURL      : String = "api.pvp.net/api/lol/";
    private let kBaseDomain   : String = "api.pvp.net/";
    private let kStaticURL    : String = "api.pvp.net/api/lol/static-data/";
    private let kBaseImageURL : String = "http://ddragon.leagueoflegends.com/cdn/5.2.1/img/";
    

    // MARK: Summoner Info URL's
    private let kBasicSummonerInfoURL : String = "v1.4/summoner/by-name/";
    private let kSummonerLeagueInfoURL : String = "v2.5/league/by-summoner/";

    // MARK: Static API Data
    private let kChampionsURL       : String = "v1.2/champion";
    private let kItemURL            : String = "v1.2/item";
    private let kMasteryURL         : String = "v1.2/mastery";
    private let kRuneURL            : String = "v1.2/rune";
    private let kSummonerSpell      : String = "v1.2/summoner-spell";
    private let kChampionImageURL   : String = "ddragon.leagueoflegends.com/cdn/5.20.1/img/champion/";
    
    // MARK: Game Info URL's
    private let kInGameInfoURL      : String = "observer-mode/rest/consumer/getSpectatorGameInfo/"
    
    override init()
    {
        super.init();
    }
    
    // MARK: Helper functions
    // Function to clean the summoner name of spaces. 
    // 
    // @param summonerName : The name of the summoner to clean. 
    // 
    // @return Returns the cleaned up summoner name, devoid of spaces
    func cleanSummonerName(summonerName : String) -> String
    {
        let toArray = summonerName.componentsSeparatedByString(" ");
        let backToString = toArray.joinWithSeparator("");
        return backToString;
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
    
    // Function to prepare summonerIDs for the URL. 
    //
    // @param summonerIDs Array<String> : Array of summoner IDs
    // 
    // @return Returns a string to be used in a URL
    func getSummonerIDsString(summonerIDs : Array<String>) -> String
    {
        var summonerIDString = "";
        
        for var i = 0; i < summonerIDs.count; i++ {
            summonerIDString += cleanSummonerName(summonerIDs[i]);
            if (i != summonerIDs.count-1)
            {
                summonerIDString += ",";
            }
        }
        
        return summonerIDString;
    }
    
    // Function to get the division image for a summoner.
    //
    // @param divisionName : The name of the division as returned from the server.
    //
    // @return Returns the image for the divison
    func getImageForDivisionByName(tier: String, division : String = "") -> UIImage
    {
        var imageName = tier.lowercaseString;
        if (division != "")
        {
            imageName += "_" + division.lowercaseString;
        }
        
        return UIImage(named: imageName)!;
    }
    
    // MARK: Static API Helper Functions
    
    // Function to get the info of a champion given the champion ID. 
    //
    //@param championID : The id's of the champions to return
    //@param completion : Completion block to run once the data is returned
    //
    //@return Returns the champion info in JSON format in the completion block
    func getChampionsById(championID : Array<String>) -> Array<Champion>
    {
        var championObjectArray : Array<Champion> = Array<Champion>();
        var champObject : Champion?;
        for id in championID
        {
            for (_, championObj) in champData
            {
                if (id == championObj["id"].stringValue){
                    champObject = Champion(name: championObj["name"].stringValue, id: championObj["id"].stringValue, title: championObj["title"].stringValue, imageName: championObj["image"]["full"].stringValue);
                    championObjectArray.append(champObject!);
                }
            }
        }
        
        return championObjectArray;
    }
    
    // Function to get the champion square image by name.
    //
    // @param championName : The name of the champion's image.
    // @param completion : Completion block to run once the data is returned.
    //
    // @return Returns the image for the champion.
    func getChampionImageByName(championName : String, completion : (image: UIImage) -> Void)
    {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration();
        let session = NSURLSession(configuration: config);
        let request = NSMutableURLRequest();
        
        request.URL = NSURL(string: "http://\(kChampionImageURL)\(championName)");
        request.HTTPMethod = "GET";
        
        let task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
                if (error != nil)
                {
                    print(error);
                }
                else
                {
                    completion(image: UIImage(data: data!)!);
                }
        }
        
        task.resume();
    }
    
    // MARK: Get Basic Summoner Info

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
        let request = NSMutableURLRequest();
        
        // Clean the summoner name of spaces. 
        let cleanName = cleanSummonerName(summonerName);
        
        request.URL = NSURL(string: "https://\(region).\(self.kBaseURL)\(region)/\(self.kBasicSummonerInfoURL)\(cleanName)\(self.kAPIKey)");
        request.HTTPMethod = "GET";
        
        NSLog("Starting request for \(summonerName)");
        let task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
                if (error != nil)
                {
                    print(error);
                }
                else
                {
                    let jsonObject = JSON(data: data!);
                    completion(json: jsonObject);
                }
        }
        
        task.resume();
    }
    
    // MARK : Get Ranked information for Summoner by Id
    
    // Function to get the ranked information for a summoner by Id.
    //
    // @param summonerIds : Array<String> Array of summoner ids
    // @param region : The region of the summoner
    // @param completion : Completion block to run once the data is returned
    // 
    // @Return Returns the ranked information for the summoner in JSON format in the completion block.
    func getRankedInformationForSummonerById(summonerIDs : Array<String>, region : String, completion : (json: JSON) -> Void)
    {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration();
        let session = NSURLSession(configuration: config);
        let request = NSMutableURLRequest();
        
        let summonerIDsURLParam = getSummonerIDsString(summonerIDs);
        
        request.URL = NSURL(string: "https://\(region).\(self.kBaseURL)\(region)/\(self.kSummonerLeagueInfoURL)\(summonerIDsURLParam)/\(self.kEntry)\(self.kAPIKey)");
        request.HTTPMethod = "GET";
        
        NSLog("Starting request for \(summonerIDsURLParam)");
        let task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
                if (error != nil)
                {
                    print(error);
                }
                else
                {
                    let jsonObject = JSON(data: data!);
                    completion(json: jsonObject);
                }
        }
        
        task.resume();
    }
    
    // MARK: Get In Game Info for Summoner
    
    // Function to get the in game information of a summoner.
    //
    // @param summonerName : The name of the summoner
    // @param region : The region of the summoner 
    // @param completion : The completion block to run once the data is returned
    //
    // @return Returns in game information in JSON format
    func getInGameInformationForSummonerById(summonerID : String, region: String, completion: (json : JSON) -> Void)
    {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration();
        let session = NSURLSession(configuration: config);
        let request = NSMutableURLRequest();
        let platformID = getPlatformIDForRegion(region);
        request.URL = NSURL(string: "https://\(region).\(self.kBaseDomain)\(self.kInGameInfoURL)\(platformID)/\(summonerID)\(self.kAPIKey)");
                
        request.HTTPMethod = "GET";
        NSLog("Starting request for \(summonerID)");
        let task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            if (error != nil)
            {
                print(error);
            }
            else
            {
                let jsonObject = JSON(data: data!);
                completion(json: jsonObject);
            }
        }
        
        task.resume(); 
    }
}