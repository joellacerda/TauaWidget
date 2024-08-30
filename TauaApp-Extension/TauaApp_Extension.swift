//
//  TauaApp_Extension.swift
//  TauaApp-Extension
//
//  Created by Joel Lacerda on 29/08/24.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    private let placeholderEntry = SimpleEntry(
        date: Date(), projeto: "", learningObjects: []
    )
    
    func placeholder(in context: Context) -> SimpleEntry {
        return placeholderEntry
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        completion(placeholderEntry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, projeto: "Tauá", learningObjects: ["CBL"])
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let projeto: String
    let learningObjects: [String]
}

struct TauaApp_ExtensionEntryView : View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    var entry: Provider.Entry

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text(entry.projeto)
                    .bold()
                    .font(.title)
                
                Text("Learning Objects:")
                    .bold()
                    .font(.title2)
                HStack {
                    ForEach(entry.learningObjects, id: \.self) { object in
                        Text(object)
                    }
                }
            }
           
            Spacer()
        }
        .foregroundStyle(colorScheme == .light ? .black : .yellow)
        .containerBackground(for: .widget) {
            colorScheme == .light ? Color.yellow : Color.black
        }
    }
}

struct TauaApp_Extension: Widget {
    let kind: String = "TauaApp_Extension"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
           TauaApp_ExtensionEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemSmall) {
    TauaApp_Extension()
} timeline: {
    SimpleEntry(date: .now, projeto: "Tauá", learningObjects: ["CBL"])
    SimpleEntry(date: .now + 1, projeto: "Tauá", learningObjects: ["SwiftUI"])
}

#Preview(as: .systemMedium) {
    TauaApp_Extension()
} timeline: {
    SimpleEntry(date: .now, projeto: "Residência", learningObjects: ["CBL", "SwiftUI"])
    SimpleEntry(date: .now + 1, projeto: "Residência", learningObjects: ["CBL", "SwiftUI"])
}
