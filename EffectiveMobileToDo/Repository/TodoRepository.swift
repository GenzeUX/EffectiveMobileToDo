import Foundation

protocol TodoRepository {
    func fetchAll(completion: @escaping (Result<[TodoTask], Error>) -> Void)
    func save(_ tasks: [TodoTask], completion: @escaping (Result<Void, Error>) -> Void)
    func add(_ task: TodoTask, completion: @escaping (Result<Void, Error>) -> Void)
    func update(_ task: TodoTask, completion: @escaping (Result<Void, Error>) -> Void)
    func delete(id: UUID, completion: @escaping (Result<Void, Error>) -> Void)
    func search(query: String, completion: @escaping (Result<[TodoTask], Error>) -> Void)
    func isEmpty(completion: @escaping (Result<Bool, Error>) -> Void)
}
