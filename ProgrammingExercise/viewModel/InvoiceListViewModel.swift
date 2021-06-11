import Foundation

class InvoiceListViewModel {
    
    let invoices: Container<[Invoice]?> = Container(nil)
    
    init() {
        invoices.value = getAllInvoices()
    }
    
    // Get all invoices
    func getAllInvoices() -> [Invoice] {
        var invoice1 = Invoice(invoiceNumber: 1, invoiceDate: Date(), lineItems: [])
        
        invoice1.addInvoiceLine(InvoiceLine(invoiceLineId: 1,
                                            description: "Banana",
                                            quantity: 4,
                                            cost: 10.33))
        
        var invoice2 = Invoice(invoiceNumber: 2, invoiceDate: Date(), lineItems: [])
        
        invoice2.addInvoiceLine(InvoiceLine(invoiceLineId: 2,
                                            description: "Blueberries",
                                            quantity: 3,
                                            cost: 6.27))
        
        invoice2.addInvoiceLine(InvoiceLine(invoiceLineId: 1,
                                            description: "Orange",
                                            quantity: 1,
                                            cost: 5.22))
        
        var invoice3 = Invoice(invoiceNumber: 3, invoiceDate: Date(), lineItems: [])
        
        let longText = """
            Lorem Ipsum is simply dummy text of the printing and typesetting industry. \
            Lorem Ipsum has been the industry's standard dummy text ever since the 150s\
            when an unknown printer took a galley of type and scrambled it to make all \
            specimen book. It has survived not only five centuries, but also they leap \
            electronic typesetting, remaining essentially unchanged. It is popularised \
            in the 1960s with the release of Letraset sheets containing an Lorem Ipsum \
            , and more recently with desktop publishing software like Aldeus PageMaker \
            including versions of Lorem Ipsum.
            """
        invoice3.addInvoiceLine(InvoiceLine(invoiceLineId: 1,
                                            description: longText,
                                            quantity: 1,
                                            cost: 9.99))
        return [invoice1, invoice2, invoice3]
    }
    
    // Merge all the invoices to the first one
    func mergeAllInvoices() {
        if let _invoices = self.invoices.value {
            let lineItems = _invoices.reduce([]) { $0 + ($1.lineItems ?? [])}
            self.invoices.value = [Invoice(invoiceNumber: _invoices[0].invoiceNumber,
                                          invoiceDate: _invoices[0].invoiceDate,
                                          lineItems: lineItems)]
        }
    }
    
    // Reset all invoice
    func resetAllInvoices() {
        self.invoices.value = getAllInvoices()
    }
    
    // Delete all invoices
    func deleteAllInvoices() {
        self.invoices.value = []
    }
    
    // Clone all invoices
    func cloneAllInvoices() {
        if let _invoices = self.invoices.value {
            let clonedInvoices = _invoices.map { $0.clone() }
            self.invoices.value = _invoices + clonedInvoices
        }
    }
    
    // Sort all invoices by line item id
    func sortAllInovices() {        
        if let _invoices = self.invoices.value {
            self.invoices.value = _invoices.map { invoice in
                var sortedInvoice = invoice
                sortedInvoice.orderLineItems()
                return Invoice(invoiceNumber: invoice.invoiceNumber,
                               invoiceDate: invoice.invoiceDate,
                               lineItems: sortedInvoice.lineItems)
            }
        }
    }
    
    // Preview first line item for each invoice
    func previewAllInvoices() {
        if let _invoices = self.invoices.value {
            self.invoices.value = _invoices.map {
                Invoice(invoiceNumber: $0.invoiceNumber,
                        invoiceDate: $0.invoiceDate,
                        lineItems: $0.previewLineItems(1))
            }
        }
    }
}
