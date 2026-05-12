import UIKit

protocol TodoListRouterInput {
    func openEditor(task: TodoTask?, onFinish: @escaping () -> Void)
}

final class TodoListRouter: TodoListRouterInput {
    weak var viewController: UIViewController?

    static func createModule() -> UIViewController {
        let repository = CoreDataTodoRepository()
        let networkService = DummyJSONNetworkService()

        let interactor = TodoListInteractor(
            repository: repository,
            networkService: networkService
        )

        let router = TodoListRouter()

        let presenter = TodoListPresenter(
            interactor: interactor,
            router: router
        )

        let view = TodoListViewController(presenter: presenter)

        presenter.view = view
        router.viewController = view

        return UINavigationController(rootViewController: view)
    }

    func openEditor(task: TodoTask?, onFinish: @escaping () -> Void) {
        let editor = TodoEditorRouter.createModule(
            task: task,
            onFinish: onFinish
        )

        let navigation = UINavigationController(rootViewController: editor)
        viewController?.present(navigation, animated: true)
    }
}
