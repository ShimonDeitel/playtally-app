import Foundation

struct PlaySession: Identifiable, Codable, Equatable {
    let id: UUID
    var createdAt: Date
    var petName: String
    var activity: String
    var minutes: Double
    var date: Date

    init(id: UUID = UUID(), createdAt: Date = Date(), petName: String = "", activity: String = "", minutes: Double = 0, date: Date = Date()) {
        self.id = id
        self.createdAt = createdAt
        self.petName = petName
        self.activity = activity
        self.minutes = minutes
        self.date = date
    }
}
