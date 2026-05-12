import CoreData
import Foundation

@objc(TodoTaskMO)
final class TodoTaskMO: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var remoteID: NSNumber?
    @NSManaged var title: String
    @NSManaged var taskDescription: String
    @NSManaged var createdAt: Date
    @NSManaged var isCompleted: Bool
}

extension TodoTaskMO {
    func toDomain() -> TodoTask {
        TodoTask(
            id: id,
            remoteID: remoteID?.intValue,
            title: title,
            description: taskDescription,
            createdAt: createdAt,
            isCompleted: isCompleted
        )
    }

    func update(from task: TodoTask) {
        id = task.id
        remoteID = task.remoteID.map { NSNumber(value: $0) }
        title = task.title
        taskDescription = task.description
        createdAt = task.createdAt
        isCompleted = task.isCompleted
    }
}
