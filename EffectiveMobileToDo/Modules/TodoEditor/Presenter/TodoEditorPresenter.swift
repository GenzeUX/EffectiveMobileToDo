import Foundation

protocol TodoEditorViewInput: AnyObject {
    func showTask(title: String, description: String, isCompleted: Bool)
    func showError(_ message: String)
    func close()
}

protocol TodoEditorViewOutput: AnyObject {
    func viewDidLoad()
    func didTapSave(title: String, description: String, isCompleted: Bool)
}

final class TodoEditorPresenter: TodoEditorViewOutput {
    weak var view: TodoEditorViewInput?

    private let interactor: TodoEditorInteractorInput
    private let router: TodoEditorRouterInput
    private let task: TodoTask?

    init(
        task: TodoTask?,
        interactor: TodoEditorInteractorInput,
        router: TodoEditorRouterInput
    ) {
        self.task = task
        self.interactor = interactor
        self.router = router
    }

    func viewDidLoad() {
        guard let task else { return }

        view?.showTask(
            title: task.title,
            description: task.description,
            isCompleted: task.isCompleted
        )
    }

    func didTapSave(title: String, description: String, isCompleted: Bool) {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedTitle.isEmpty else {
            view?.showError("Название задачи не может быть пустым")
            return
        }

        let taskToSave: TodoTask

        if let task {
            taskToSave = TodoTask(
                id: task.id,
                remoteID: task.remoteID,
                title: trimmedTitle,
                description: description,
                createdAt: task.createdAt,
                isCompleted: isCompleted
            )
        } else {
            taskToSave = TodoTask(
                id: UUID(),
                remoteID: nil,
                title: trimmedTitle,
                description: description,
                createdAt: Date(),
                isCompleted: isCompleted
            )
        }

        interactor.save(task: taskToSave, isNew: task == nil) { [weak self] result in
            switch result {
            case .success:
                self?.router.close()
            case .failure(let error):
                self?.view?.showError(error.localizedDescription)
            }
        }
    }
}
