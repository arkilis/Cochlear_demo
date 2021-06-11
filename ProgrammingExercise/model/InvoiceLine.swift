import Foundation

struct InvoiceLine: Equatable {
    
    var invoiceLineId: Int!
    var description: String
    var quantity: Int
    var cost: Decimal
    
    static func == (lhs: InvoiceLine, rhs: InvoiceLine) -> Bool {
        return (lhs.invoiceLineId == rhs.invoiceLineId
                    && lhs.quantity == rhs.quantity
                    && lhs.cost == rhs.cost)
    }
}

extension Array where Element == InvoiceLine {
    
    func sort() -> [InvoiceLine] {
        return sorted { $0.invoiceLineId < $1.invoiceLineId }
    }
    
    func equal(invoiceLines: [InvoiceLine]?) -> Bool {
        if let _invoiceLines = invoiceLines {
            if (self.count != _invoiceLines.count) {
                return false
            } else {
                let sortedLeft = self.sort()
                let sortedRight = _invoiceLines.sort()
                
                for (invoiceLine1, invoiceLine2) in zip(sortedLeft, sortedRight) {
                    if (invoiceLine1 != invoiceLine2) {
                        return false
                    }
                }
                return true
            }
        } else {
            return false
        }
    }
}
