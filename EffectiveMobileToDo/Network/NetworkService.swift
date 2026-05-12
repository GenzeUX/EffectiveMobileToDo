import Foundation

protocol NetworkService {
    func fetchTodos(completion: @escaping (Result<[TodoTask], Error>) -> Void)
}

final class DummyJSONNetworkService: NetworkService {
    func fetchTodos(completion: @escaping (Result<[TodoTask], Error>) -> Void) {
        guard let url = URL(string: "https://dummyjson.com/todos") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        DispatchQueue.global(qos: .userInitiated).async {
            URLSession.shared.dataTask(with: url) { data, _, error in
                if let error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                    return
                }

                guard let data else {
                    DispatchQueue.main.async {
                        completion(.failure(NetworkError.noData))
                    }
                    return
                }

                do {
                    let dto = try JSONDecoder().decode(TodosResponseDTO.self, from: data)
                    let tasks = dto.todos.map { $0.toDomain() }

                    DispatchQueue.main.async {
                        completion(.success(tasks))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }.resume()
        }
    }
}

enum NetworkError: Error {
    case invalidURL
    case noData
}
