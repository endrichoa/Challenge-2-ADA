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
        .init(name: "Canned Food", image: "canned-food", price: 3),
        .init(name: "Chicken", image: "drumstick", price: 2),
        .init(name: "Meat", image: "meat", price: 5),
        .init(name: "Biscuit", image: "cookies", price: 2)
    ]
}
