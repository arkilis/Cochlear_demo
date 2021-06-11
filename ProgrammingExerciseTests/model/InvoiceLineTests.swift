import XCTest

@testable import ProgrammingExercise

class InvoiceLineTests: XCTestCase {
    
    var testInvoiceLine1: InvoiceLine?
    var testInvoiceLine2: InvoiceLine?
    
    override func setUpWithError() throws {
        testInvoiceLine1 = InvoiceLine(invoiceLineId: 1,
                                             description: "invoice line 1",
                                             quantity: 1,
                                             cost: 0.1)
        testInvoiceLine2 = InvoiceLine(invoiceLineId: 2,
                                             description: "invoice line 2",
                                             quantity: 10,
                                             cost: 1.0)
    }
    
    override func tearDownWithError() throws {
    }
    
    func testEqual() {
        let testInvoiceLine3 = testInvoiceLine1
        XCTAssertNotEqual(testInvoiceLine1, testInvoiceLine2)
        XCTAssertEqual(testInvoiceLine1, testInvoiceLine3)
    }
    
}
