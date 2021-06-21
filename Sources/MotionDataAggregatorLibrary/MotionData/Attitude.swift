import Foundation
import CoreMotion

public struct Attitude {
    
    let pitch: Double
    let roll: Double
    let yaw: Double
    let attitude: TimeInterval
    
    func toString() -> String {
        
        return "\(String(format: "%.3f", pitch)), \(String(format: "%.3f", roll)), \(String(format: "%.3f", yaw))"
    }
}
