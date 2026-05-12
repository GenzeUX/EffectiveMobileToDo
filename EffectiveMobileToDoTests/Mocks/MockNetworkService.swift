import Foundation
@testable import EffectiveMobileToDo

final class MockNetworkService: NetworkService {
    var result: Result<[TodoTask], Error> = .success([])

    func fetchTodos(completion: @escaping (Result<[TodoTask], Error>) -> Void) {
        completion(result)
    }
}
