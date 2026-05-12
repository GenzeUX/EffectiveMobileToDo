import Foundation

protocol TodoEditorInteractorInput {
    func save(
        task: TodoTask,
        isNew: Bool,
        completion: @escaping (Result<Void, Error>) -> Void
    )
}

final class TodoEditorInteractor: TodoEditorInteractorInput {
    private let repository: TodoRepository

    init(repository: TodoRepository) {
        self.repository = repository
    }

    func save(
        task: TodoTask,
        isNew: Bool,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        if isNew {
            repository.add(task, completion: completion)
        } else {
            repository.update(task, completion: completion)
        }
    }
}
