import Foundation

struct TodosResponseDTO: Decodable {
    let todos: [TodoDTO]
    let total: Int
    let skip: Int
    let limit: Int
}

struct TodoDTO: Decodable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}

extension TodoDTO {
    func toDomain() -> TodoTask {
        TodoTask(
            id: UUID(),
            remoteID: id,
            title: todo,
            description: "User ID: \(userId)",
            createdAt: Date(),
            isCompleted: completed
        )
    }
}
