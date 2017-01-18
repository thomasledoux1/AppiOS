//
//  Movie.swift
//  NewApp
//
//  Created by Thomas on 04/01/2017.
//  Copyright © 2017 Thomas. All rights reserved.
//

import UIKit

class Movie : NSObject, NSCoding {
    //MARK : properties
    var name : String
    var photo : UIImage?
    var rating : Int
    
    //Paths
    static let DocumentsDirectory = FileManager().urls(for : .documentDirectory, in : .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("movies")
    
    //MARK : types
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let rating = "rating"
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey : PropertyKey.name)
        aCoder.encode(photo, forKey : PropertyKey.photo)
        aCoder.encode(rating, forKey : PropertyKey.rating)
    }
    
    required convenience init? (coder aDecoder : NSCoder) {
        guard let name = aDecoder.decodeObject(forKey : PropertyKey.name) as? String else {
            return nil
        }
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
        
        self.init(name : name, photo : photo, rating : rating)
    }
    
    init?(name : String, photo : UIImage?, rating : Int){
        if name.isEmpty{
            return nil
        }
        self.name = name
        self.photo = photo
        self.rating = rating
    }
    
}


