import UIKit

protocol TodoEditorRouterInput {
    func close()
}

final class TodoEditorRouter: TodoEditorRouterInput {
    weak var viewController: UIViewController?

    private let onFinish: () -> Void

    init(onFinish: @escaping () -> Void) {
        self.onFinish = onFinish
    }

    static func createModule(
        task: TodoTask?,
        onFinish: @escaping () -> Void
    ) -> UIViewController {
        let repository = CoreDataTodoRepository()
        let interactor = TodoEditorInteractor(repository: repository)
        let router = TodoEditorRouter(onFinish: onFinish)

        let presenter = TodoEditorPresenter(
            task: task,
            interactor: interactor,
            router: router
        )

        let view = TodoEditorViewController(
            presenter: presenter,
            isEditingExistingTask: task != nil
        )

        presenter.view = view
        router.viewController = view

        return view
    }

    func close() {
        onFinish()
        viewController?.dismiss(animated: true)
    }
}
