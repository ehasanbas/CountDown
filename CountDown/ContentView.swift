import SwiftUI

struct ContentView: View {
    @State private var title = ""
    @State private var targetDate = Date()
    @State private var selectedImage: NSImage?
    @State private var showingImagePicker = false
    @StateObject var eventStore = EventStore()

    var body: some View {
        VStack(spacing: 20) {
            Text("Create New Event")
                .font(.largeTitle)
                .padding()

            TextField("Event Title", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            DatePicker("Target Date", selection: $targetDate)
                .padding()

            if let image = selectedImage {
                Image(nsImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(10)
                    .padding()
            } else {
                Text("No image selected")
            }

            Button("Pick Image") {
                showingImagePicker = true
            }
            .padding()

            Button("Save Event") {
                let imageData = selectedImage?.tiffRepresentation
                let newEvent = Event(title: title, targetDate: targetDate, imageData: imageData)
                eventStore.add(event: newEvent)
                title = ""
                targetDate = Date()
                selectedImage = nil
            }
            .padding()

            // Events list or placeholder
            if eventStore.events.isEmpty {
                Text("No events created yet")
                    .foregroundColor(.gray)
                    .frame(height: 200)
            } else {
                List(eventStore.events) { event in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(event.title)
                            .font(.headline)
                        CountdownView(targetDate: event.targetDate)
                    }
                    .padding(.vertical, 4)
                }
                .frame(maxHeight: 200)
            }
        }
        .padding()
        .frame(width: 400)
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
    }
}

struct CountdownView: View {
    let targetDate: Date
    @State private var now: Date = Date()
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        let remaining = max(Int(targetDate.timeIntervalSince(now)), 0)
        let days = remaining / 86400
        let hours = (remaining % 86400) / 3600
        let minutes = (remaining % 3600) / 60
        let seconds = remaining % 60
        HStack {
            Text(String(format: "%02dd %02dh %02dm %02ds", days, hours, minutes, seconds))
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .onReceive(timer) { input in
            self.now = Date()
        }
    }
}
