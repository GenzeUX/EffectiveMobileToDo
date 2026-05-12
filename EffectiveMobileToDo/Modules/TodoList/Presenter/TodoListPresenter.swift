import Foundation

protocol TodoListViewInput: AnyObject {
    func showLoading()
    func hideLoading()
    func showTasks(_ tasks: [TodoTask])
    func showError(_ message: String)
}

protocol TodoListViewOutput: AnyObject {
    func viewDidLoad()
    func didTapAdd()
    func didSelectTask(_ task: TodoTask)
    func didDeleteTask(_ task: TodoTask)
    func didToggleTask(_ task: TodoTask)
    func didSearch(query: String)
}

final class TodoListPresenter: TodoListViewOutput {
    weak var view: TodoListViewInput?

    private let interactor: TodoListInteractorInput
    private let router: TodoListRouterInput

    private var tasks: [TodoTask] = []

    init(
        interactor: TodoListInteractorInput,
        router: TodoListRouterInput
    ) {
        self.interactor = interactor
        self.router = router
    }

    func viewDidLoad() {
        view?.showLoading()

        interactor.loadInitialDataIfNeeded { [weak self] result in
            guard let self else { return }

            self.view?.hideLoading()

            switch result {
            case .success(let tasks):
                self.tasks = tasks
                self.view?.showTasks(tasks)

            case .failure(let error):
                self.view?.showError(error.localizedDescription)
            }
        }
    }

    func didTapAdd() {
        router.openEditor(task: nil) { [weak self] in
            self?.viewDidLoad()
        }
    }

    func didSelectTask(_ task: TodoTask) {
        router.openEditor(task: task) { [weak self] in
            self?.viewDidLoad()
        }
    }

    func didDeleteTask(_ task: TodoTask) {
        interactor.delete(task: task) { [weak self] result in
            switch result {
            case .success:
                self?.viewDidLoad()
            case .failure(let error):
                self?.view?.showError(error.localizedDescription)
            }
        }
    }

    func didToggleTask(_ task: TodoTask) {
        var updatedTask = task
        updatedTask.isCompleted.toggle()

        interactor.update(task: updatedTask) { [weak self] result in
            switch result {
            case .success:
                self?.viewDidLoad()
            case .failure(let error):
                self?.view?.showError(error.localizedDescription)
            }
        }
    }

    func didSearch(query: String) {
        interactor.search(query: query) { [weak self] result in
            switch result {
            case .success(let tasks):
                self?.tasks = tasks
                self?.view?.showTasks(tasks)
            case .failure(let error):
                self?.view?.showError(error.localizedDescription)
            }
        }
    }
}
