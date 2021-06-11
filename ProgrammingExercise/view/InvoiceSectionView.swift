import UIKit

class InvoiceSectionView: UIView {
    
    // Constants
    private enum Constants {
        static let paddingX = 16.0
        static let invoiceNumWidth: CGFloat = 100.0
        static let backgroundColor = #colorLiteral(red: 0.3921568627, green: 0.5215686275, blue: 1, alpha: 1)
        static let invoiceNumber = "Invoice #"
        static let invoiceDate = "Invoice Date"
        static let invoiceLineItemsCount = "Item(s)"
    }
    
    // Private properties
    private var backgroundStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    private let invoiceNumber = InvoiceSectionColumnView()
    private let invoiceDate = InvoiceSectionColumnView()
    private let invoicelineItemsCount = InvoiceSectionColumnView()
    private let toggleBtn = UIButton()
    private var isToggleBtnHidden = false
    
    // Public Property
    public var onTap: OnButtonClick?
    
    convenience init(invoice: Invoice, isExpand: Bool, frame: CGRect) {
        self.init(frame: frame)
        setup(invoice: invoice, isExpand: isExpand)
        updateConstraint()
    }
    
    func setup(invoice: Invoice, isExpand: Bool) {
        backgroundColor = Constants.backgroundColor
        addSubview(backgroundStack)
        invoiceNumber.translatesAutoresizingMaskIntoConstraints = false
        toggleBtn.translatesAutoresizingMaskIntoConstraints = false
        invoiceNumber.setup(title: Constants.invoiceNumber, value: "\(invoice.invoiceNumber ?? 0)")
        invoiceDate.setup(title: Constants.invoiceDate, value: "\(invoice.invoiceDate.toString())")
        invoicelineItemsCount.setup(title: Constants.invoiceLineItemsCount, value: "\(invoice.lineItems?.count ?? 0)")
        toggleBtn.setImage(UIImage(systemName: "plus"), for: .normal)
        toggleBtn.imageView?.tintColor = .white
        toggleBtn.isHidden = isToggleBtnHidden
        toggleBtn.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        
        [invoiceNumber, invoiceDate, invoicelineItemsCount, toggleBtn].forEach {
            self.backgroundStack.addArrangedSubview($0)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tap)
    }
    
    // Private methods
    @objc private func handleTap() {
        isToggleBtnHidden = !isToggleBtnHidden
        if let _onTap = onTap {
            _onTap()
        }
    }

    private func updateConstraint() {
        NSLayoutConstraint.activate([
            backgroundStack.widthAnchor.constraint(equalTo: widthAnchor),
            backgroundStack.heightAnchor.constraint(equalTo: heightAnchor),
            backgroundStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundStack.topAnchor.constraint(equalTo: topAnchor),
            invoiceNumber.widthAnchor.constraint(equalToConstant: Constants.invoiceNumWidth),
            toggleBtn.widthAnchor.constraint(equalTo: toggleBtn.heightAnchor)
        ])
    }
    
    
}
