import UIKit

class InvoiceTableViewSingleRow: UIView {
    
    // Constants
    private enum Constants {
        static let paddingX: CGFloat = 16.0
        static let titleFontSize: CGFloat = 12.0
        static let valueFontSize: CGFloat = 12.0
    }
    
    // Private properties
    private var backgroundStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: Constants.titleFontSize)
        label.textColor = .gray
        return label
    }()
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.valueFontSize)
        label.textAlignment = .left
        return label
    }()
    
    // Public methods
    func setup(title: String, value: String) {
        addSubview(backgroundStack)
        titleLabel.text = title
        valueLabel.text = value
        titleLabel.setContentHuggingPriority(.defaultHigh+1, for: .horizontal)
        valueLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        [titleLabel, valueLabel].forEach {
            self.backgroundStack.addArrangedSubview($0)
        }
        updateConstraint()
    }
    
    // Private methods
    func updateConstraint() {
        NSLayoutConstraint.activate([
            backgroundStack.widthAnchor.constraint(equalTo: widthAnchor),
            backgroundStack.heightAnchor.constraint(equalTo: heightAnchor),
            backgroundStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundStack.topAnchor.constraint(equalTo: topAnchor),
        ])
    }
}


