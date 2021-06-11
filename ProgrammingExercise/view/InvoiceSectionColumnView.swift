import UIKit

class InvoiceSectionColumnView: UIView {
    
    // Constants
    private enum Constants {
        static let paddingX: CGFloat = 16.0
        static let titleFontSize: CGFloat = 14.0
        static let valueFontSize: CGFloat = 16.0
    }
    
    // Private properties
    private var backgroundStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: Constants.titleFontSize)
        label.textColor = .white
        return label
    }()
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.valueFontSize)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    // Public methods
    func setup(title: String, value: String) {
        addSubview(backgroundStack)
        titleLabel.text = title
        valueLabel.text = value
        [titleLabel, valueLabel].forEach {
            self.backgroundStack.addArrangedSubview($0)
        }
        updateConstraint()
    }
    
    // Private methods
    private func updateConstraint() {
        NSLayoutConstraint.activate([
            backgroundStack.widthAnchor.constraint(equalTo: widthAnchor),
            backgroundStack.heightAnchor.constraint(equalTo: heightAnchor),
            backgroundStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundStack.topAnchor.constraint(equalTo: topAnchor),
        ])
    }
}

