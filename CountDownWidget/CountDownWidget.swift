//
//  CountDownWidget.swift
//  CountDownWidget
//
//  Created by Ersin Hasanbas on 08/08/2025.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent(), event: sampleEvent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration, event: sampleEvent())
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        let events = loadEvents()
        let currentDate = Date()

        // Use first event or a default event if none
        let event = events.first ?? sampleEvent()

        let entry = SimpleEntry(date: currentDate, configuration: configuration, event: event)
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 1, to: currentDate)!
        return Timeline(entries: [entry], policy: .after(nextUpdate))
    }

    // Load saved events from shared container
    func loadEvents() -> [Event] {
        let appGroupID = "group.com.yourname.CountDown" // Use your actual App Group ID
        guard let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupID)?
                .appendingPathComponent("events.json"),
              let data = try? Data(contentsOf: url),
              let events = try? JSONDecoder().decode([Event].self, from: data) else {
            return []
        }
        return events
    }

    func sampleEvent() -> Event {
        Event(title: "Sample Event", targetDate: Date().addingTimeInterval(3600), imageData: nil)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    let event: Event
}

struct CountDownWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            if let data = entry.event.imageData, let nsImage = NSImage(data: data) {
                Image(nsImage: nsImage)
                    .resizable()
                    .scaledToFill()
                    .clipped()
            } else {
                Color.blue
            }
            
            VStack {
                Text(entry.event.title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .shadow(radius: 3)
                
                Text(countdownText(to: entry.event.targetDate))
                    .font(.title)
                    .foregroundColor(.white)
                    .shadow(radius: 3)
            }
            .padding()
        }
    }

    func countdownText(to targetDate: Date) -> String {
        let diff = Calendar.current.dateComponents([.day, .hour, .minute], from: Date(), to: targetDate)
        let d = diff.day ?? 0
        let h = diff.hour ?? 0
        let m = diff.minute ?? 0
        return "\(d)d \(h)h \(m)m"
    }
}

struct CountDownWidget: Widget {
    let kind: String = "CountDownWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            CountDownWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}
