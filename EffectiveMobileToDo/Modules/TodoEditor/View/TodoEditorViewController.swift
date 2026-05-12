import UIKit

final class TodoEditorViewController: UIViewController {
    private let presenter: TodoEditorViewOutput
    private let isEditingExistingTask: Bool

    private let titleTextField = UITextField()
    private let descriptionTextView = UITextView()
    private let completedSwitch = UISwitch()

    init(
        presenter: TodoEditorViewOutput,
        isEditingExistingTask: Bool
    ) {
        self.presenter = presenter
        self.isEditingExistingTask = isEditingExistingTask
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        presenter.viewDidLoad()
    }

    private func setupUI() {
        title = isEditingExistingTask ? "Редактирование" : "Новая задача"
        view.backgroundColor = .systemBackground

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Отмена",
            style: .plain,
            target: self,
            action: #selector(cancelTapped)
        )

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Сохранить",
            style: .done,
            target: self,
            action: #selector(saveTapped)
        )

        titleTextField.placeholder = "Название"
        titleTextField.borderStyle = .roundedRect

        descriptionTextView.font = .systemFont(ofSize: 16)
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.borderColor = UIColor.systemGray4.cgColor
        descriptionTextView.layer.cornerRadius = 8

        let completedLabel = UILabel()
        completedLabel.text = "Выполнена"
        completedLabel.font = .systemFont(ofSize: 16)

        let statusStack = UIStackView(arrangedSubviews: [
            completedLabel,
            completedSwitch
        ])
        statusStack.axis = .horizontal
        statusStack.alignment = .center
        statusStack.distribution = .equalSpacing

        let stack = UIStackView(arrangedSubviews: [
            titleTextField,
            descriptionTextView,
            statusStack
        ])

        stack.axis = .vertical
        stack.spacing = 16

        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            descriptionTextView.heightAnchor.constraint(equalToConstant: 180),

            stack.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 20
            ),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    @objc private func cancelTapped() {
        dismiss(animated: true)
    }

    @objc private func saveTapped() {
        presenter.didTapSave(
            title: titleTextField.text ?? "",
            description: descriptionTextView.text ?? "",
            isCompleted: completedSwitch.isOn
        )
    }
}

extension TodoEditorViewController: TodoEditorViewInput {
    func showTask(title: String, description: String, isCompleted: Bool) {
        titleTextField.text = title
        descriptionTextView.text = description
        completedSwitch.isOn = isCompleted
    }

    func showError(_ message: String) {
        let alert = UIAlertController(
            title: "Ошибка",
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    func close() {
        dismiss(animated: true)
    }
}
