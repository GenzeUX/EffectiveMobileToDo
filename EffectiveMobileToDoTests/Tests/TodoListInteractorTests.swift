import XCTest
@testable import EffectiveMobileToDo

final class TodoListInteractorTests: XCTestCase {
    func testSearchReturnsFilteredTasks() {
        let repository = MockTodoRepository()
        repository.tasks = [
            TodoTask(
                id: UUID(),
                remoteID: nil,
                title: "Купить хлеб",
                description: "",
                createdAt: Date(),
                isCompleted: false
            ),
            TodoTask(
                id: UUID(),
                remoteID: nil,
                title: "Выучить VIPER",
                description: "",
                createdAt: Date(),
                isCompleted: false
            )
        ]

        let interactor = TodoListInteractor(
            repository: repository,
            networkService: MockNetworkService(),
            userDefaults: UserDefaults(suiteName: #file)!
        )

        let expectation = expectation(description: "Search expectation")

        interactor.search(query: "VIPER") { result in
            switch result {
            case .success(let tasks):
                XCTAssertEqual(tasks.count, 1)
                XCTAssertEqual(tasks.first?.title, "Выучить VIPER")
            case .failure:
                XCTFail("Search should not fail")
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    func testDeleteRemovesTask() {
        let task = TodoTask(
            id: UUID(),
            remoteID: nil,
            title: "Task",
            description: "",
            createdAt: Date(),
            isCompleted: false
        )

        let repository = MockTodoRepository()
        repository.tasks = [task]

        let interactor = TodoListInteractor(
            repository: repository,
            networkService: MockNetworkService(),
            userDefaults: UserDefaults(suiteName: #file)!
        )

        let expectation = expectation(description: "Delete expectation")

        interactor.delete(task: task) { result in
            switch result {
            case .success:
                XCTAssertTrue(repository.tasks.isEmpty)
            case .failure:
                XCTFail("Delete should not fail")
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }
}
