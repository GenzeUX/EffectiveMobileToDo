import CoreData

final class CoreDataStack {
    static let shared = CoreDataStack()

    let persistentContainer: NSPersistentContainer

    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    init(inMemory: Bool = false) {
        let model = Self.makeModel()
        persistentContainer = NSPersistentContainer(name: "TodoModel", managedObjectModel: model)

        if inMemory {
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            persistentContainer.persistentStoreDescriptions = [description]
        }

        persistentContainer.loadPersistentStores { _, error in
            if let error {
                fatalError("CoreData store failed: \(error)")
            }
        }

        persistentContainer.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }

    func makeBackgroundContext() -> NSManagedObjectContext {
        let context = persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }

    private static func makeModel() -> NSManagedObjectModel {
        let model = NSManagedObjectModel()

        let entity = NSEntityDescription()
        entity.name = "TodoTaskMO"
        entity.managedObjectClassName = NSStringFromClass(TodoTaskMO.self)

        let id = NSAttributeDescription()
        id.name = "id"
        id.attributeType = .UUIDAttributeType
        id.isOptional = false

        let remoteID = NSAttributeDescription()
        remoteID.name = "remoteID"
        remoteID.attributeType = .integer64AttributeType
        remoteID.isOptional = true

        let title = NSAttributeDescription()
        title.name = "title"
        title.attributeType = .stringAttributeType
        title.isOptional = false

        let taskDescription = NSAttributeDescription()
        taskDescription.name = "taskDescription"
        taskDescription.attributeType = .stringAttributeType
        taskDescription.isOptional = false

        let createdAt = NSAttributeDescription()
        createdAt.name = "createdAt"
        createdAt.attributeType = .dateAttributeType
        createdAt.isOptional = false

        let isCompleted = NSAttributeDescription()
        isCompleted.name = "isCompleted"
        isCompleted.attributeType = .booleanAttributeType
        isCompleted.isOptional = false

        entity.properties = [
            id,
            remoteID,
            title,
            taskDescription,
            createdAt,
            isCompleted
        ]

        model.entities = [entity]
        return model
    }
}
