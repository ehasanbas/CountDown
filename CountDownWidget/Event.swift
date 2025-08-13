//
//  Event.swift
//  CountDown
//
//  Created by Ersin Hasanbas on 08/08/2025.
//


import Foundation

struct Event: Identifiable, Codable {
    var id = UUID()
    var title: String
    var targetDate: Date
    var imageData: Data?
}