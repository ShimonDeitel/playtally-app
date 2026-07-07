import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published private(set) var entries: [PlaySession] = []
    @Published var isPro: Bool = false

    /// Free-tier cap. Kept comfortably above seed count so a fresh install
    /// never hits the paywall on first launch.
    let freeLimit = 40

    private let fileURL: URL

    init() {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        fileURL = dir.appendingPathComponent("playtally_entries.json")
        load()
    }

    var canAddMore: Bool {
        isPro || entries.count < freeLimit
    }

    func add(_ entry: PlaySession) {
        entries.insert(entry, at: 0)
        save()
    }

    func update(_ entry: PlaySession) {
        guard let idx = entries.firstIndex(where: { $0.id == entry.id }) else { return }
        entries[idx] = entry
        save()
    }

    func delete(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
        save()
    }

    func delete(_ entry: PlaySession) {
        entries.removeAll { $0.id == entry.id }
        save()
    }

    private func load() {
        if let data = try? Data(contentsOf: fileURL),
           let decoded = try? JSONDecoder().decode([PlaySession].self, from: data) {
            entries = decoded
        } else {
            entries = Store.seedData
        }
    }

    func save() {
        if let data = try? JSONEncoder().encode(entries) {
            try? data.write(to: fileURL, options: .atomic)
        }
    }

    static var seedData: [PlaySession] {
        [
        PlaySession(petName: "Pet Name 1", activity: "Activity 1", minutes: 1.0, date: Date().addingTimeInterval(-86400)),
        PlaySession(petName: "Pet Name 2", activity: "Activity 2", minutes: 2.0, date: Date().addingTimeInterval(-172800)),
        PlaySession(petName: "Pet Name 3", activity: "Activity 3", minutes: 3.0, date: Date().addingTimeInterval(-259200)),
        PlaySession(petName: "Pet Name 4", activity: "Activity 4", minutes: 4.0, date: Date().addingTimeInterval(-345600)),
        PlaySession(petName: "Pet Name 5", activity: "Activity 5", minutes: 5.0, date: Date().addingTimeInterval(-432000)),
        PlaySession(petName: "Pet Name 6", activity: "Activity 6", minutes: 6.0, date: Date().addingTimeInterval(-518400)),
        PlaySession(petName: "Pet Name 7", activity: "Activity 7", minutes: 7.0, date: Date().addingTimeInterval(-604800))
        ]
    }
}
