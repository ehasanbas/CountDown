//
//  EventStore.swift
//  CountDown
//
//  Created by Ersin Hasanbas on 08/08/2025.
//

import Foundation
import SwiftUI

class EventStore: ObservableObject {
    @Published var events: [Event] = []

    let saveKey = "savedEvents"
    let appGroupID = "group.com.yourname.CountDown" // use your App Group ID here

    private var sharedURL: URL? {
        FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupID)
    }

    init() {
        load()
    }

    func load() {
        guard let url = sharedURL?.appendingPathComponent("events.json") else {
            loadFromUserDefaults()
            return
        }
        if let data = try? Data(contentsOf: url),
           let decoded = try? JSONDecoder().decode([Event].self, from: data) {
            events = decoded
        } else {
            loadFromUserDefaults()
        }
    }

    private func loadFromUserDefaults() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([Event].self, from: data) {
            events = decoded
        }
    }

    func save() {
        guard let url = sharedURL?.appendingPathComponent("events.json") else {
            saveToUserDefaults()
            return
        }
        if let encoded = try? JSONEncoder().encode(events) {
            try? encoded.write(to: url)
        }
    }

    private func saveToUserDefaults() {
        if let encoded = try? JSONEncoder().encode(events) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }

    func add(event: Event) {
        events.append(event)
        save()
    }
}
