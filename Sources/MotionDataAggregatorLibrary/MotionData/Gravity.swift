import Foundation
import CoreMotion

public struct Gravity {
    
    let x: Double
    let y: Double
    let z: Double
    let timestamp: TimeInterval
    
    func toString() -> String {
        
        return "\(String(format: "%.3f", x)), \(String(format: "%.3f", y)), \(String(format: "%.3f", z))"
    }
}
