import CoreData
import Foundation

final class CoreDataTodoRepository: TodoRepository {
    private let coreDataStack: CoreDataStack

    init(coreDataStack: CoreDataStack = .shared) {
        self.coreDataStack = coreDataStack
    }

    func fetchAll(completion: @escaping (Result<[TodoTask], Error>) -> Void) {
        let context = coreDataStack.makeBackgroundContext()

        context.perform {
            do {
                let request = TodoTaskMO.fetchRequest()
                request.sortDescriptors = [
                    NSSortDescriptor(key: "createdAt", ascending: false)
                ]

                let result = try context.fetch(request) as? [TodoTaskMO] ?? []
                let tasks = result.map { $0.toDomain() }

                DispatchQueue.main.async {
                    completion(.success(tasks))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    func save(_ tasks: [TodoTask], completion: @escaping (Result<Void, Error>) -> Void) {
        let context = coreDataStack.makeBackgroundContext()

        context.perform {
            do {
                for task in tasks {
                    let object = TodoTaskMO(context: context)
                    object.update(from: task)
                }

                try context.save()

                DispatchQueue.main.async {
                    completion(.success(()))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    func add(_ task: TodoTask, completion: @escaping (Result<Void, Error>) -> Void) {
        let context = coreDataStack.makeBackgroundContext()

        context.perform {
            do {
                let object = TodoTaskMO(context: context)
                object.update(from: task)
                try context.save()

                DispatchQueue.main.async {
                    completion(.success(()))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    func update(_ task: TodoTask, completion: @escaping (Result<Void, Error>) -> Void) {
        let context = coreDataStack.makeBackgroundContext()

        context.perform {
            do {
                let request = TodoTaskMO.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", task.id as CVarArg)
                request.fetchLimit = 1

                guard let object = try context.fetch(request).first as? TodoTaskMO else {
                    throw RepositoryError.taskNotFound
                }

                object.update(from: task)
                try context.save()

                DispatchQueue.main.async {
                    completion(.success(()))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    func delete(id: UUID, completion: @escaping (Result<Void, Error>) -> Void) {
        let context = coreDataStack.makeBackgroundContext()

        context.perform {
            do {
                let request = TodoTaskMO.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

                let objects = try context.fetch(request) as? [TodoTaskMO] ?? []
                objects.forEach { context.delete($0) }

                try context.save()

                DispatchQueue.main.async {
                    completion(.success(()))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    func search(query: String, completion: @escaping (Result<[TodoTask], Error>) -> Void) {
        let context = coreDataStack.makeBackgroundContext()

        context.perform {
            do {
                let request = TodoTaskMO.fetchRequest()
                request.sortDescriptors = [
                    NSSortDescriptor(key: "createdAt", ascending: false)
                ]

                if !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    request.predicate = NSPredicate(
                        format: "title CONTAINS[cd] %@ OR taskDescription CONTAINS[cd] %@",
                        query,
                        query
                    )
                }

                let result = try context.fetch(request) as? [TodoTaskMO] ?? []
                let tasks = result.map { $0.toDomain() }

                DispatchQueue.main.async {
                    completion(.success(tasks))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    func isEmpty(completion: @escaping (Result<Bool, Error>) -> Void) {
        let context = coreDataStack.makeBackgroundContext()

        context.perform {
            do {
                let request = TodoTaskMO.fetchRequest()
                let count = try context.count(for: request)

                DispatchQueue.main.async {
                    completion(.success(count == 0))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}

enum RepositoryError: Error {
    case taskNotFound
}
