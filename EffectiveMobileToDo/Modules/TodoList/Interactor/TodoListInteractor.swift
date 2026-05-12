import Foundation

protocol TodoListInteractorInput {
    func loadInitialDataIfNeeded(completion: @escaping (Result<[TodoTask], Error>) -> Void)
    func delete(task: TodoTask, completion: @escaping (Result<Void, Error>) -> Void)
    func update(task: TodoTask, completion: @escaping (Result<Void, Error>) -> Void)
    func search(query: String, completion: @escaping (Result<[TodoTask], Error>) -> Void)
}

final class TodoListInteractor: TodoListInteractorInput {
    private let repository: TodoRepository
    private let networkService: NetworkService
    private let userDefaults: UserDefaults

    init(
        repository: TodoRepository,
        networkService: NetworkService,
        userDefaults: UserDefaults = .standard
    ) {
        self.repository = repository
        self.networkService = networkService
        self.userDefaults = userDefaults
    }

    func loadInitialDataIfNeeded(completion: @escaping (Result<[TodoTask], Error>) -> Void) {
        let didLoadInitialTodos = userDefaults.bool(forKey: UserDefaultsKeys.didLoadInitialTodos)

        repository.isEmpty { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let isEmpty):
                if !didLoadInitialTodos && isEmpty {
                    self.loadFromNetworkAndSave(completion: completion)
                } else {
                    self.repository.fetchAll(completion: completion)
                }

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func delete(task: TodoTask, completion: @escaping (Result<Void, Error>) -> Void) {
        repository.delete(id: task.id, completion: completion)
    }

    func update(task: TodoTask, completion: @escaping (Result<Void, Error>) -> Void) {
        repository.update(task, completion: completion)
    }

    func search(query: String, completion: @escaping (Result<[TodoTask], Error>) -> Void) {
        repository.search(query: query, completion: completion)
    }

    private func loadFromNetworkAndSave(completion: @escaping (Result<[TodoTask], Error>) -> Void) {
        networkService.fetchTodos { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let tasks):
                self.repository.save(tasks) { saveResult in
                    switch saveResult {
                    case .success:
                        self.userDefaults.set(true, forKey: UserDefaultsKeys.didLoadInitialTodos)
                        self.repository.fetchAll(completion: completion)

                    case .failure(let error):
                        completion(.failure(error))
                    }
                }

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
