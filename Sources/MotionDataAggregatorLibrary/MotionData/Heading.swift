import Foundation
import CoreMotion

public struct Heading {
    
    let value: Double
    let timestamp: TimeInterval
    
    func toString() -> String {
        
        return "\(String(format: "%.3f", value))"
    }
}
