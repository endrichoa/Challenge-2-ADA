//
//  StoreViewModel.swift
//  virtual-pet
//
//  Created by Hanna Nadia Savira on 28/05/25.
//

import Foundation

@Observable
class StoreViewModel {
    let items = StoreItemModel.items
    
    var coins: Int = UserDefaults.standard.integer(forKey: "coins")
    
    func buyItem(_ item: StoreItemModel) {
        if coins < item.price { return }
        coins -= item.price
        UserDefaults.standard.set(coins, forKey: "coins")
    }
    
}
