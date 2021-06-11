import XCTest

@testable import ProgrammingExercise

class InvoiceListViewModelTests: XCTestCase {
    
    var viewModel: InvoiceListViewModel!

    override func setUpWithError() throws {
        viewModel = InvoiceListViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGetInovices() {
        let invoices = viewModel.getAllInvoices()
        XCTAssertEqual(invoices.count, 3)
    }
    
    func testMergeAllInvoices() {
        viewModel.mergeAllInvoices()
        let invoices = viewModel.invoices.value
        XCTAssertEqual(invoices?.count, 1)
        XCTAssertEqual(invoices?[0].lineItems?.count, 4)
    }
    
    func testResetAllInvoices() {
        viewModel.resetAllInvoices()
        let invoices = viewModel.invoices.value
        XCTAssertEqual(invoices?.count, 3)
    }
    
    func testDeleteAllInvoices() {
        viewModel.deleteAllInvoices()
        let invoices = viewModel.invoices.value
        XCTAssertEqual(invoices?.count, 0)
    }
    
    func testCloneAllInvoices() {
        viewModel.cloneAllInvoices()
        let invoices = viewModel.invoices.value
        XCTAssertEqual(invoices?.count, 6)
        let sortedInvoices = invoices?.sorted {
            $0.invoiceNumber < $1.invoiceNumber
        }
        XCTAssertEqual(sortedInvoices?[0], sortedInvoices?[1])
        XCTAssertNotEqual(sortedInvoices?[0], sortedInvoices?[2])
        XCTAssertEqual(sortedInvoices?[2], sortedInvoices?[3])
        XCTAssertEqual(sortedInvoices?[4], sortedInvoices?[5])
    }
   
    func testSortAllInovices() {
        let invoices = viewModel.getAllInvoices()
        let invoiceLineItems = invoices[1].lineItems?.sort()
        viewModel.sortAllInovices()
        XCTAssertEqual(invoiceLineItems, viewModel.invoices.value?[1].lineItems)
    }
    
    func testPreviewAllInovices() {
        let expectedNumOfLineItems = [1, 1, 1]
        viewModel.previewAllInvoices()
        let invoices = viewModel.invoices.value
        XCTAssertEqual(invoices?.map { $0.lineItems?.count }, expectedNumOfLineItems)
    }
    
}
