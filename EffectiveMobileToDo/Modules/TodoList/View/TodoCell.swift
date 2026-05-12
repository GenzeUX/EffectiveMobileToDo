import UIKit

final class TodoCell: UITableViewCell {
    static let reuseID = "TodoCell"

    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let dateLabel = UILabel()
    private let statusImageView = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with task: TodoTask) {
        titleLabel.text = task.title
        descriptionLabel.text = task.description
        dateLabel.text = Self.dateFormatter.string(from: task.createdAt)

        let imageName = task.isCompleted ? "checkmark.circle.fill" : "circle"
        statusImageView.image = UIImage(systemName: imageName)
        statusImageView.tintColor = task.isCompleted ? .systemGreen : .systemGray
    }

    private func setupUI() {
        selectionStyle = .none

        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        titleLabel.numberOfLines = 2

        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 2

        dateLabel.font = .systemFont(ofSize: 12)
        dateLabel.textColor = .tertiaryLabel

        statusImageView.contentMode = .scaleAspectFit
        statusImageView.setContentHuggingPriority(.required, for: .horizontal)

        let textStack = UIStackView(arrangedSubviews: [
            titleLabel,
            descriptionLabel,
            dateLabel
        ])
        textStack.axis = .vertical
        textStack.spacing = 4

        let rootStack = UIStackView(arrangedSubviews: [
            statusImageView,
            textStack
        ])
        rootStack.axis = .horizontal
        rootStack.spacing = 12
        rootStack.alignment = .top

        contentView.addSubview(rootStack)
        rootStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            statusImageView.widthAnchor.constraint(equalToConstant: 24),
            statusImageView.heightAnchor.constraint(equalToConstant: 24),

            rootStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            rootStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            rootStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            rootStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        return formatter
    }()
}
