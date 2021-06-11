import Foundation

extension Date {

  func toString() -> String {
    let df = DateFormatter()
    df.dateFormat = "dd/MM/YYYY"
    return df.string(from: self)
  }
  
}
