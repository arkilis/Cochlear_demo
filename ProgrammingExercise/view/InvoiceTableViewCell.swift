import UIKit

class InvoiceTableViewCell: UITableViewCell {
    
    // Constants
    private enum Constants {
        static let descFontSize: CGFloat = 11.0
        static let paddingY: CGFloat = 8.0
        static let backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9450980392, blue: 0.9803921569, alpha: 1)
        static let bottomLineColor = #colorLiteral(red: 0.631372549, green: 0.6274509804, blue: 0.8588235294, alpha: 1)
        static let invoiceTitle = "InvoiceLine ID: "
        static let cost = "Cost: "
        static let quantity = "Quantity: "
        static let descTitle = "Description: "
    }
    
    // Private properties
    private var backgroundStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private let invoiceID = InvoiceTableViewSingleRow()
    private let cost = InvoiceTableViewSingleRow()
    private let quantity = InvoiceTableViewSingleRow()
    private let descTitle = InvoiceTableViewSingleRow()
    private let desc: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: Constants.descFontSize)
        return label
    }()
    private let bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.bottomLineColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Public methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    // Public method
    func setup(invoiceLine: InvoiceLine) {
        contentView.backgroundColor = Constants.backgroundColor
        contentView.addSubview(backgroundStackView)
        invoiceID.setup(title: Constants.invoiceTitle, value: "\(invoiceLine.invoiceLineId ?? 0)")
        cost.setup(title: Constants.cost, value: "$\(invoiceLine.cost)")
        quantity.setup(title: Constants.quantity, value: "\(invoiceLine.quantity)")
        descTitle.setup(title: Constants.descTitle, value: "")
        desc.text = invoiceLine.description
        
        [invoiceID, cost, quantity, descTitle, desc, bottomLine].forEach {
            self.backgroundStackView.addArrangedSubview($0)
        }
        updateConstraint()
    }
    
    // Private methods
    private func updateConstraint() {
        NSLayoutConstraint.activate([
            backgroundStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.paddingY),
            backgroundStackView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            backgroundStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.paddingY),
            backgroundStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bottomLine.heightAnchor.constraint(equalToConstant: 1.0)
        ])
    }
    
    
}
