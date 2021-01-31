//
//  model.swift
//  Map
//
//  Created by Alexander Romanenko on 25.09.2020.
//  Copyright © 2020 Alexander Romanenko. All rights reserved.
//

import Foundation
import MapKit


/*class modelUser {
    var users = [User]()
}

 */
class User: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var pictures: [UIImage] = []
    init(title: String,coordinate: CLLocationCoordinate2D){
        self.title = title
        self.coordinate = coordinate
    }
}


//let spots = modelUser()

var spots = [User]()


