//
//  StoreItemModel.swift
//  virtual-pet
//
//  Created by Hanna Nadia Savira on 28/05/25.
//

import Foundation

struct StoreItemModel: Identifiable {
    let id = UUID()
    let name: String
    let image: String
    let price: Int
    
    init(name: String, image: String, price: Int) {
        self.name = name
        self.image = image
        self.price = price
    }
    
    static let items: [StoreItemModel] = [
        .init(name: "Canned Food", image: "CannedFood", price: 3),
        .init(name: "Chicken", image: "Drumstick", price: 2),
        .init(name: "Meat", image: "Meat", price: 5),
        .init(name: "Biscuit", image: "Cookies", price: 2)
    ]
}
