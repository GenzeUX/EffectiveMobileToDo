import Foundation
@testable import EffectiveMobileToDo

final class MockTodoRepository: TodoRepository {
    var tasks: [TodoTask] = []
    var shouldFail = false

    func fetchAll(completion: @escaping (Result<[TodoTask], Error>) -> Void) {
        if shouldFail {
            completion(.failure(MockError.failed))
        } else {
            completion(.success(tasks))
        }
    }

    func save(_ tasks: [TodoTask], completion: @escaping (Result<Void, Error>) -> Void) {
        if shouldFail {
            completion(.failure(MockError.failed))
        } else {
            self.tasks = tasks
            completion(.success(()))
        }
    }

    func add(_ task: TodoTask, completion: @escaping (Result<Void, Error>) -> Void) {
        if shouldFail {
            completion(.failure(MockError.failed))
        } else {
            tasks.append(task)
            completion(.success(()))
        }
    }

    func update(_ task: TodoTask, completion: @escaping (Result<Void, Error>) -> Void) {
        if shouldFail {
            completion(.failure(MockError.failed))
        } else {
            tasks = tasks.map { $0.id == task.id ? task : $0 }
            completion(.success(()))
        }
    }

    func delete(id: UUID, completion: @escaping (Result<Void, Error>) -> Void) {
        if shouldFail {
            completion(.failure(MockError.failed))
        } else {
            tasks.removeAll { $0.id == id }
            completion(.success(()))
        }
    }

    func search(query: String, completion: @escaping (Result<[TodoTask], Error>) -> Void) {
        if query.isEmpty {
            completion(.success(tasks))
        } else {
            completion(.success(tasks.filter {
                $0.title.localizedCaseInsensitiveContains(query) ||
                $0.description.localizedCaseInsensitiveContains(query)
            }))
        }
    }

    func isEmpty(completion: @escaping (Result<Bool, Error>) -> Void) {
        completion(.success(tasks.isEmpty))
    }
}

enum MockError: Error {
    case failed
}
