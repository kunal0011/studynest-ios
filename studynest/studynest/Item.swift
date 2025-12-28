//
//  Item.swift
//  studynest
//
//  Created by Kunal Kumar on 09/12/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
