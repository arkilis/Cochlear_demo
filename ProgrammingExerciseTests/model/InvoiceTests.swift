import XCTest

@testable import ProgrammingExercise

class InvoiceTests: XCTestCase {
    
    var invoice: Invoice?
    var invoiceWithNilLines: Invoice?
    var sourceInvoice: Invoice?
    var sourceInvoiceWithNilLines: Invoice?
    let invaidInvoiceLineID = -1
    var testInvoiceLine1: InvoiceLine?
    var testInvoiceLine2: InvoiceLine?

    override func setUpWithError() throws {
        invoice = Invoice(invoiceNumber: 1, invoiceDate: Date(), lineItems: [])
        invoiceWithNilLines = Invoice(invoiceNumber: 1, invoiceDate: Date(), lineItems: nil)
        testInvoiceLine1 = InvoiceLine(invoiceLineId: 1,
                                             description: "invoice line 1",
                                             quantity: 1,
                                             cost: 0.1)
        testInvoiceLine2 = InvoiceLine(invoiceLineId: 2,
                                             description: "invoice line 2",
                                             quantity: 10,
                                             cost: 1.0)
        sourceInvoice = Invoice(invoiceNumber: 2, invoiceDate: Date(), lineItems: [testInvoiceLine2!])
        sourceInvoiceWithNilLines = Invoice(invoiceNumber: 2, invoiceDate: Date(), lineItems: nil)
    }

    override func tearDownWithError() throws {
    }
    
    func testAddInvoiceLine() {
        // test non-nil line items
        invoice?.addInvoiceLine(testInvoiceLine1!)
        XCTAssertEqual(invoice?.lineItems?.count, 1)
        XCTAssertEqual(invoice?.lineItems?[0], testInvoiceLine1)
        
        // test nil line items
        invoiceWithNilLines?.addInvoiceLine(testInvoiceLine1!)
        XCTAssertEqual(invoiceWithNilLines?.lineItems?.count, 1)
        XCTAssertEqual(invoiceWithNilLines?.lineItems?[0], testInvoiceLine1)
    }
    
    func testRemoveInvoiceLine() {
        // test non-nil line items
        invoice?.addInvoiceLine(testInvoiceLine1!)
        XCTAssertEqual(invoice?.lineItems?[0], testInvoiceLine1)
        invoice?.removeInvoiceLine(with: (testInvoiceLine1?.invoiceLineId)!)
        XCTAssertEqual(invoice?.lineItems?.count, 0)
        
        // test nil line items
        invoiceWithNilLines?.addInvoiceLine(testInvoiceLine1!)
        XCTAssertEqual(invoiceWithNilLines?.lineItems?[0], testInvoiceLine1)
        invoiceWithNilLines?.removeInvoiceLine(with: (testInvoiceLine1?.invoiceLineId)!)
        XCTAssertEqual(invoiceWithNilLines?.lineItems?.count, 0)
        
        // test delete invalid invoiceLineID
        invoice?.addInvoiceLine(testInvoiceLine1!)
        invoice?.removeInvoiceLine(with: invaidInvoiceLineID)
        XCTAssertEqual(invoice?.lineItems?[0], testInvoiceLine1)
    }
    
    func testGetTotal() {
        // test non-nil line items
        XCTAssertEqual(invoice?.getTotal(), 0.0)
        invoice?.addInvoiceLine(testInvoiceLine1!)
        XCTAssertEqual(invoice?.getTotal(), 0.1)
        invoice?.removeInvoiceLine(with: (testInvoiceLine1?.invoiceLineId)!)
        XCTAssertEqual(invoice?.getTotal(), 0.0)
        
        // test nil line items
        XCTAssertEqual(invoiceWithNilLines?.getTotal(), 0.0)
        invoiceWithNilLines?.addInvoiceLine(testInvoiceLine1!)
        XCTAssertEqual(invoiceWithNilLines?.getTotal(), 0.1)
        invoiceWithNilLines?.removeInvoiceLine(with: (testInvoiceLine1?.invoiceLineId)!)
        XCTAssertEqual(invoiceWithNilLines?.getTotal(), 0.0)
    }
    
    func testMergeInvoices() {
        // test both non-nil line items
        invoice?.mergeInvoices(sourceInvoice: sourceInvoice!)
        XCTAssertEqual(invoice?.lineItems?.count, 1)
        XCTAssertEqual(invoice?.lineItems?[0], testInvoiceLine2)
        invoice?.removeInvoiceLine(with: (testInvoiceLine2?.invoiceLineId)!)
        XCTAssertEqual(invoice?.lineItems?.count, 0)
        
        // test source invoice nil line items
        invoice?.mergeInvoices(sourceInvoice: sourceInvoiceWithNilLines!)
        XCTAssertEqual(invoice?.lineItems?.count, 0)
        
        // test destinate invoice nil line items
        invoiceWithNilLines?.mergeInvoices(sourceInvoice: sourceInvoice!)
        XCTAssertEqual(invoiceWithNilLines?.lineItems?.count, 1)
        XCTAssertEqual(invoiceWithNilLines?.lineItems?[0], testInvoiceLine2)
        invoiceWithNilLines?.removeInvoiceLine(with: (testInvoiceLine2?.invoiceLineId)!)
        XCTAssertEqual(invoiceWithNilLines?.lineItems?.count, 0)
        
        // test both nil line items
        invoiceWithNilLines?.mergeInvoices(sourceInvoice: sourceInvoiceWithNilLines!)
        XCTAssertEqual(invoice?.lineItems?.count, 0)
    }
    
    func testClone() {
        invoice?.addInvoiceLine(testInvoiceLine1!)
        let invoiceClone = invoice?.clone()
        XCTAssertEqual(invoice, invoiceClone)
        
        invoice?.removeInvoiceLine(with: (testInvoiceLine1?.invoiceLineId)!)
        XCTAssertNotEqual(invoice, invoiceClone)
    }
    
    func testOrderLineItems() {
        // test non-nil line items
        invoice?.addInvoiceLine(testInvoiceLine2!)
        invoice?.addInvoiceLine(testInvoiceLine1!)
        let lineItemIDsOrderBefore = invoice?.lineItems!.map { $0.invoiceLineId }
        invoice?.orderLineItems()
        let lineItemIDsOrderAfter = invoice?.lineItems!.map { $0.invoiceLineId }
        XCTAssertNotEqual(lineItemIDsOrderBefore, lineItemIDsOrderAfter)
        let lineItemIDsOrderBeforeSorted = lineItemIDsOrderBefore?.sorted { $0! < $1! }
        XCTAssertEqual(lineItemIDsOrderBeforeSorted, lineItemIDsOrderAfter)
        
        // test nil line items
        invoiceWithNilLines?.addInvoiceLine(testInvoiceLine2!)
        invoiceWithNilLines?.addInvoiceLine(testInvoiceLine1!)
        let nillineItemIDsOrderBefore = invoiceWithNilLines?.lineItems!.map { $0.invoiceLineId }
        invoiceWithNilLines?.orderLineItems()
        let nillineItemIDsOrderAfter = invoiceWithNilLines?.lineItems!.map { $0.invoiceLineId }
        XCTAssertNotEqual(nillineItemIDsOrderBefore, nillineItemIDsOrderAfter)
        let nillineItemIDsOrderBeforeSorted = nillineItemIDsOrderBefore?.sorted { $0! < $1! }
        XCTAssertEqual(nillineItemIDsOrderBeforeSorted, nillineItemIDsOrderAfter)
    }
    
    func testPreviewLineItems() {
        
        // test non-nil line items
        XCTAssertEqual(invoice?.previewLineItems(0), [])
        XCTAssertEqual(invoice?.previewLineItems(-1), [])
        XCTAssertEqual(invoice?.previewLineItems(1), [])
        XCTAssertEqual(invoice?.previewLineItems(100), [])
        invoice?.addInvoiceLine(testInvoiceLine1!)
        XCTAssertEqual(invoice?.previewLineItems(1).count, 1)
        invoice?.addInvoiceLine(testInvoiceLine2!)
        XCTAssertEqual(invoice?.previewLineItems(1).count, 1)
        
        // test nil line items
        XCTAssertEqual(invoiceWithNilLines?.previewLineItems(0), [])
        XCTAssertEqual(invoiceWithNilLines?.previewLineItems(-1), [])
        XCTAssertEqual(invoiceWithNilLines?.previewLineItems(1), [])
        XCTAssertEqual(invoiceWithNilLines?.previewLineItems(100), [])
        invoiceWithNilLines?.addInvoiceLine(testInvoiceLine1!)
        XCTAssertEqual(invoiceWithNilLines?.previewLineItems(1).count, 1)
        invoiceWithNilLines?.addInvoiceLine(testInvoiceLine2!)
        XCTAssertEqual(invoiceWithNilLines?.previewLineItems(1).count, 1)
    }
    
    func testRemoveItems() {
        
        invoice?.addInvoiceLine(testInvoiceLine1!)
        invoice?.addInvoiceLine(testInvoiceLine2!)
        
        var newInvoice = Invoice(invoiceNumber: 3, invoiceDate: Date(), lineItems: [])
        newInvoice.addInvoiceLine(testInvoiceLine1!)
        invoice?.removeItems(from: newInvoice)
        XCTAssertEqual(invoice?.lineItems?.count, 1)
        XCTAssertEqual(invoice?.lineItems?[0], testInvoiceLine2)
        
    }
    
    func testToString() {
        
        let invoiceExpectStringNoLineItem = "Invoice Number: 1, InvoiceDate: \(invoice?.invoiceDate.toString() ?? ""), LineItemCount: 0"
        XCTAssertEqual(invoiceExpectStringNoLineItem, invoice?.toString())
        
        invoice?.addInvoiceLine(testInvoiceLine1!)
        let invoiceExpectStringOneLineItem = "Invoice Number: 1, InvoiceDate: \(invoice?.invoiceDate.toString() ?? ""), LineItemCount: 1"
        XCTAssertEqual(invoiceExpectStringOneLineItem, invoice?.toString())
        
    }

}
