//
//  Champion.swift
//  LOLFun
//
//  Created by Zachary Donato on 10/21/15.
//  Copyright © 2015 Zachary Donato. All rights reserved.
//

import Foundation

class Champion
{
    // Private variables.
    private var name : String?;
    private var id : String?;
    private var title : String?;
    private var imageName : String?;
    
    init(name: String, id : String, title : String, imageName : String){
        self.name = name;
        self.id = id;
        self.title = title;
        self.imageName = imageName;
    }
    
    func getName() -> String
    {
        return self.name!;
    }
    
    func getId() -> String
    {
        return self.id!;
    }
    
    func getTitle() -> String
    {
        return self.title!;
    }
    
    func getImageName() -> String
    {
        return self.imageName!;
    }
}