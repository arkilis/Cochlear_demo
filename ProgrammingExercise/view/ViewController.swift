import UIKit

class ViewController: UIViewController {
    
    private enum Constants {
        static let paddingX: CGFloat = 16.0
        static let paddingTop: CGFloat = 10.0
        static let tableSectionHeight: CGFloat = 80.0
        static let tableFooterHeight: CGFloat = 10.0
        static let tableCellHeight: CGFloat = 110.0
        static let tableCellID: String = "invoice_cell"
        static let title: String = "Invoices"
        static let btnTitle: String = "Edit"
        static let reset: String = "Reset"
        static let merge: String = "Merge all invoices to first one"
        static let cancel: String = "Cancel"
        static let ok: String = "OK"
        static let alertTitle: String = "Some Assumption"
        static let delete: String = "Delete all inovoices"
        static let clone: String = "Clone all invoices"
        static let sort: String = "Sort line items by ID"
        static let preview: String = "Preview first line item"
        static let assumpiton: String = """
                            1. Every invoice must has an invoice number and date\n \
                            2. Every invoice can has empty or nil line items\n \
                            3. Sort invoice Line Items by order line id ascending by default\n \
                            4. Different line items order means different invoice\n
                            """
    }
    
    // Private properties
    private let invoiceListViewModel = InvoiceListViewModel()
    private let tableView = UITableView()
    private let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: Constants.paddingTop))
    private var invoices: [Invoice]?
    private var sectionExpanded = [Int: Bool]()
    
    // Public methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavItem()
        setupTableView()
        reloadTableViewData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadTableViewData()
    }
    
    func setupNavItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: Constants.btnTitle,
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(addTapped))
    }
    
    // Initialises the tableview
    func setupTableView() {
        title = Constants.title
        view.addSubview(tableView)
        tableView.estimatedRowHeight = Constants.tableCellHeight
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.register(InvoiceTableViewCell.self, forCellReuseIdentifier: Constants.tableCellID)
        updateConstriants()
    }
    
    // Populates the cells with the invoices returned from GetInvoices
    func reloadTableViewData() {
        invoiceListViewModel.invoices.bind {
            self.invoices = $0
            if let _invoices = self.invoices {
                for index in 0..<_invoices.count {
                    self.sectionExpanded[index] = false
                }
            }
            self.tableView.reloadData()
        }
    }
    
    // Private methods
    private func updateConstriants() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: Constants.paddingTop),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.paddingX),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.paddingX),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func addTapped() {
        let myActionSheet = UIAlertController(title: Constants.alertTitle, message: Constants.assumpiton, preferredStyle: .actionSheet)
        
        myActionSheet.addAction(UIAlertAction(title: Constants.cancel, style: .cancel, handler: nil))
        myActionSheet.addAction(UIAlertAction(title: Constants.merge, style: .default, handler: { _ in
            self.invoiceListViewModel.mergeAllInvoices()
        }))
        myActionSheet.addAction(UIAlertAction(title: Constants.clone, style: .default, handler: { _ in
            self.invoiceListViewModel.cloneAllInvoices()
        }))
        myActionSheet.addAction(UIAlertAction(title: Constants.sort, style: .default, handler: { _ in
            self.invoiceListViewModel.sortAllInovices()
        }))
        myActionSheet.addAction(UIAlertAction(title: Constants.preview, style: .default, handler: { _ in
            self.invoiceListViewModel.previewAllInvoices()
        }))
        myActionSheet.addAction(UIAlertAction(title: Constants.reset, style: .destructive, handler: { _ in
            self.invoiceListViewModel.resetAllInvoices()
        }))
        myActionSheet.addAction(UIAlertAction(title: Constants.delete, style: .destructive, handler: { _ in
            self.invoiceListViewModel.deleteAllInvoices()
        }))
        self.present(myActionSheet, animated: true, completion: nil)
    }
}

// Tableview extension
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        (sectionExpanded[section] ?? false) ? (invoices?[section].lineItems?.count ?? 0) : 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        invoices?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let _invoiceLine = invoices?[indexPath.section].lineItems?[indexPath.row] {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.tableCellID) as! InvoiceTableViewCell
            cell.setup(invoiceLine: _invoiceLine)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        Constants.tableSectionHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        Constants.tableFooterHeight
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = InvoiceSectionView(invoice: (invoices?[section])!,
                                             isExpand: false,
                                             frame: CGRect(x: 0,
                                                           y: 0,
                                                           width: view.frame.width,
                                                           height: Constants.tableSectionHeight))
        sectionView.onTap = {
            self.sectionExpanded[section] = !(self.sectionExpanded[section] ?? true)
            self.tableView.reloadData()
        }
        return sectionView
    }
}
