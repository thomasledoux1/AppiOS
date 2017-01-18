//
//  HelperMethods.swift
//  NewApp
//
//  Created by Thomas on 10/01/2017.
//  Copyright © 2017 Thomas. All rights reserved.
//

import Foundation
import MapKit

class HelperMethods {
    static func parseAddress(selectedItem : MKPlacemark) -> String{
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        let comma = (selectedItem.subThoroughfare != nil  || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
        var addressLine = String(
            format:"%@%@%@%@%@%@%@",
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            selectedItem.thoroughfare ?? "",
            comma,
            selectedItem.locality ?? "",
            secondSpace,
            selectedItem.administrativeArea ?? ""
        )
        if addressLine.isEmpty {
            addressLine = "No location specified"
        }
        return addressLine
        
        
    }

}
