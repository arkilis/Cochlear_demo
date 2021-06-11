import Foundation

struct Invoice: Equatable {
    
    var invoiceNumber: Int!
    var invoiceDate: Date!
    var lineItems: [InvoiceLine]?
    
    mutating func addInvoiceLine(_ line: InvoiceLine) {
        if lineItems != nil {
            lineItems?.append(line)
        } else {
            lineItems = [line]
        }
    }
    
    mutating func removeInvoiceLine(with invoiceLineId: Int) {
        lineItems = lineItems?.filter { $0.invoiceLineId != invoiceLineId }
    }
    
    /// GetTotal should return the sum of (Cost * Quantity) for each line item
    func getTotal() -> Decimal {
        if let _lineItems = self.lineItems {
            return _lineItems.reduce(0.0) { $0 + $1.cost * Decimal($1.quantity) }
        } else {
            return 0.0
        }
    }
    
    /// MergeInvoices appends the items from the sourceInvoice to the current invoice
    mutating func mergeInvoices(sourceInvoice: Invoice) {
        if lineItems == nil {
            lineItems = sourceInvoice.lineItems
        } else {
            if let _lineItems = lineItems,
               let _sourceLineItems = sourceInvoice.lineItems {
                lineItems = _lineItems + _sourceLineItems
            }
        }
    }
    
    /// Creates a deep clone of the current invoice (all fields and properties)
    func clone() -> Invoice {
        Invoice(invoiceNumber: invoiceNumber, invoiceDate: invoiceDate, lineItems: lineItems)
    }
    
    /// Order the lineItems by Id
    mutating func orderLineItems() {
        lineItems?.sort {
            $0.invoiceLineId < $1.invoiceLineId
        }
    }
    
    /// returns the number of the line items specified in the variable `max`
    func previewLineItems(_ max: Int) -> [InvoiceLine] {
        if max <= 0 {
            return []
        } else {
            if let _lineItems = self.lineItems {
                return max > _lineItems.count ? _lineItems: Array(_lineItems[0..<max])
            } else {
                return []
            }
        }
    }
    
    /// remove the line items in the current invoice that are also in the sourceInvoice
    mutating func removeItems(from sourceInvoice: Invoice) {
        if let _sourceLineItems = sourceInvoice.lineItems {
            lineItems = lineItems?.filter { !_sourceLineItems.contains($0) }
        }
    }
    
    /// Outputs string containing the following (replace [] with actual values):
    /// Invoice Number: [InvoiceNumber], InvoiceDate: [DD/MM/YYYY], LineItemCount: [Number of items in LineItems]
    func toString() -> String {
        "Invoice Number: \(self.invoiceNumber ?? 0), InvoiceDate: \(self.invoiceDate.toString()), LineItemCount: \(lineItems?.count ?? 0)"
    }
    
    static func == (lhs: Invoice, rhs: Invoice) -> Bool {
        if let _lhsLineItems = lhs.lineItems, let _rhsLineItems = rhs.lineItems {
            return (lhs.invoiceNumber == rhs.invoiceNumber
                        && lhs.invoiceDate == rhs.invoiceDate
                        && _lhsLineItems.equal(invoiceLines: _rhsLineItems))
        } else if (lhs.lineItems == nil && rhs.lineItems == nil) {
            return (lhs.invoiceNumber == rhs.invoiceNumber
                        && lhs.invoiceDate == rhs.invoiceDate)
        } else {
            return false
        }
    }
}
