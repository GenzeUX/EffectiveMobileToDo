import XCTest
@testable import EffectiveMobileToDo

@MainActor
final class TodoEditorPresenterTests: XCTestCase {

    func testViewDidLoadWithExistingTaskShowsTaskData() {
        // Arrange
        let task = TodoTask(
            id: UUID(),
            remoteID: 1,
            title: "Test title",
            description: "Test description",
            createdAt: Date(),
            isCompleted: true
        )

        let repository = MockTodoRepository()
        let interactor = TodoEditorInteractor(repository: repository)
        let router = MockTodoEditorRouter()

        let presenter = TodoEditorPresenter(
            task: task,
            interactor: interactor,
            router: router
        )

        let view = MockTodoEditorView()
        presenter.view = view

        // Act
        presenter.viewDidLoad()

        // Assert
        XCTAssertEqual(view.shownTitle, "Test title")
        XCTAssertEqual(view.shownDescription, "Test description")
        XCTAssertEqual(view.shownIsCompleted, true)
    }

    func testViewDidLoadWithNewTaskDoesNotShowTaskData() {
        // Arrange
        let repository = MockTodoRepository()
        let interactor = TodoEditorInteractor(repository: repository)
        let router = MockTodoEditorRouter()

        let presenter = TodoEditorPresenter(
            task: nil,
            interactor: interactor,
            router: router
        )

        let view = MockTodoEditorView()
        presenter.view = view

        // Act
        presenter.viewDidLoad()

        // Assert
        XCTAssertNil(view.shownTitle)
        XCTAssertNil(view.shownDescription)
        XCTAssertNil(view.shownIsCompleted)
    }

    func testDidTapSaveWithEmptyTitleShowsError() {
        // Arrange
        let repository = MockTodoRepository()
        let interactor = TodoEditorInteractor(repository: repository)
        let router = MockTodoEditorRouter()

        let presenter = TodoEditorPresenter(
            task: nil,
            interactor: interactor,
            router: router
        )

        let view = MockTodoEditorView()
        presenter.view = view

        // Act
        presenter.didTapSave(
            title: "   ",
            description: "Description",
            isCompleted: false
        )

        // Assert
        XCTAssertEqual(view.errorMessage, "Название задачи не может быть пустым")
        XCTAssertFalse(router.didClose)
        XCTAssertTrue(repository.tasks.isEmpty)
    }

    func testDidTapSaveForNewTaskAddsTaskAndClosesScreen() {
        // Arrange
        let repository = MockTodoRepository()
        let interactor = TodoEditorInteractor(repository: repository)
        let router = MockTodoEditorRouter()

        let presenter = TodoEditorPresenter(
            task: nil,
            interactor: interactor,
            router: router
        )

        let view = MockTodoEditorView()
        presenter.view = view

        // Act
        presenter.didTapSave(
            title: " New task ",
            description: "New description",
            isCompleted: false
        )

        // Assert
        XCTAssertEqual(repository.tasks.count, 1)
        XCTAssertEqual(repository.tasks.first?.title, "New task")
        XCTAssertEqual(repository.tasks.first?.description, "New description")
        XCTAssertEqual(repository.tasks.first?.isCompleted, false)
        XCTAssertNil(repository.tasks.first?.remoteID)
        XCTAssertTrue(router.didClose)
    }

    func testDidTapSaveForExistingTaskUpdatesTaskAndClosesScreen() {
        // Arrange
        let existingTask = TodoTask(
            id: UUID(),
            remoteID: 10,
            title: "Old title",
            description: "Old description",
            createdAt: Date(),
            isCompleted: false
        )

        let repository = MockTodoRepository()
        repository.tasks = [existingTask]

        let interactor = TodoEditorInteractor(repository: repository)
        let router = MockTodoEditorRouter()

        let presenter = TodoEditorPresenter(
            task: existingTask,
            interactor: interactor,
            router: router
        )

        let view = MockTodoEditorView()
        presenter.view = view

        // Act
        presenter.didTapSave(
            title: "Updated title",
            description: "Updated description",
            isCompleted: true
        )

        // Assert
        XCTAssertEqual(repository.tasks.count, 1)
        XCTAssertEqual(repository.tasks.first?.id, existingTask.id)
        XCTAssertEqual(repository.tasks.first?.remoteID, existingTask.remoteID)
        XCTAssertEqual(repository.tasks.first?.title, "Updated title")
        XCTAssertEqual(repository.tasks.first?.description, "Updated description")
        XCTAssertEqual(repository.tasks.first?.createdAt, existingTask.createdAt)
        XCTAssertEqual(repository.tasks.first?.isCompleted, true)
        XCTAssertTrue(router.didClose)
    }

    func testDidTapSaveWhenRepositoryFailsShowsErrorAndDoesNotClose() {
        // Arrange
        let repository = MockTodoRepository()
        repository.shouldFail = true

        let interactor = TodoEditorInteractor(repository: repository)
        let router = MockTodoEditorRouter()

        let presenter = TodoEditorPresenter(
            task: nil,
            interactor: interactor,
            router: router
        )

        let view = MockTodoEditorView()
        presenter.view = view

        // Act
        presenter.didTapSave(
            title: "Task",
            description: "Description",
            isCompleted: false
        )

        // Assert
        XCTAssertNotNil(view.errorMessage)
        XCTAssertFalse(router.didClose)
    }
}

// MARK: - Mocks

private final class MockTodoEditorView: TodoEditorViewInput {
    var shownTitle: String?
    var shownDescription: String?
    var shownIsCompleted: Bool?

    var errorMessage: String?
    var didClose = false

    func showTask(title: String, description: String, isCompleted: Bool) {
        shownTitle = title
        shownDescription = description
        shownIsCompleted = isCompleted
    }

    func showError(_ message: String) {
        errorMessage = message
    }

    func close() {
        didClose = true
    }
}

private final class MockTodoEditorRouter: TodoEditorRouterInput {
    var didClose = false

    func close() {
        didClose = true
    }
}
