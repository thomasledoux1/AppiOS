//
//  Task.swift
//  NewApp
//
//  Created by Thomas on 02/01/2017.
//  Copyright © 2017 Thomas. All rights reserved.
//

import UIKit
import MapKit

class Task : NSObject, NSCoding {
    //Properties
    var name : String
    var date : Date
    var importance : Int
    var location : MKPlacemark?
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("tasks")
    
    struct Key {
        static let name = "name"
        static let date = "date"
        static let importance = "importance"
        static let location = "location"
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey : Key.name)
        aCoder.encode(date, forKey : Key.date)
        aCoder.encode(importance, forKey : Key.importance)
        if let locationTask = location {
            aCoder.encode(locationTask, forKey : Key.location)
        }
        
    }
    
    required convenience init?(coder aDecoder : NSCoder) {
        guard let name = aDecoder.decodeObject(forKey : Key.name) as? String else{
            return nil
        }
        guard let date = aDecoder.decodeObject(forKey : Key.date) as? Date else{
            return nil
        }
        let importance = aDecoder.decodeInteger(forKey : Key.importance)
        
        guard let location = aDecoder.decodeObject(forKey : Key.location) as? MKPlacemark else {
            return nil
        }
        
        self.init(name : name, date : date, importance:  importance, location : location)
     }
    
    //Init
    init?(name : String, date : Date, importance : Int, location : MKPlacemark){
        if name.isEmpty || importance < 0{
            return nil
        }
        self.name = name
        self.date = date
        self.importance = importance
        self.location = location
    }
    
    
}
