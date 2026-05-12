import Foundation

struct TodoTask: Equatable {
    let id: UUID
    let remoteID: Int?
    var title: String
    var description: String
    var createdAt: Date
    var isCompleted: Bool
}
