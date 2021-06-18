//
//  PlaceModel.swift
//  MyPlaces
//
//  Created by Ruslan Malbrook on 12.06.2021.
//

import Foundation
import RealmSwift
import UIKit

class Place: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var location: String?
    @objc dynamic var type: String?
    @objc dynamic var imageData: Data?
    @objc dynamic var date = Date()
    
    convenience init(name: String, location: String?, type: String?, imageData: Data?) {
        self.init()
        
        self.name = name
        self.location = location
        self.type = type
        self.imageData = imageData
    }
    
    let restaurantNames = [
        "Burger Heroes", "Kitchen", "Bonsai", "Дастархан",
        "Индокитай", "X.O", "Балкан Гриль", "Sherlock Holmes",
        "Speak Easy", "Morris Pub", "Вкусные истории",
        "Классик", "Love&Life", "Шок", "Бочка"
    ]

    public func savePlaces() {

        for place in restaurantNames {

            let image = UIImage(named: place)
            guard let imageData = image!.pngData() else { return }

            let newPlace = Place()
            newPlace.name = place
            newPlace.location = "Novosibirsk"
            newPlace.type = "Bar"
            newPlace.imageData = imageData

            StorageManager.saveObject(place: newPlace)
        }
    }
}
