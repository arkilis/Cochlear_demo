import Foundation

extension Date {

  func toString() -> String {
    let df = DateFormatter()
    df.dateFormat = "dd/MM/yyyy"
    return df.string(from: self)
  }
  
}
