import Foundation
import CoreMotion
import Combine

@available(iOS 13.0, *)
public class WatchDataAggregator: ObservableObject {
    
    private var sensors: [Sensor]
    private var updateInterval: TimeInterval
    private var dataCollectionInterval: Int
    
    private let motionManager = CMMotionManager()
    private let queue = OperationQueue()
    
    private var timer: Timer?
    
    @Published private var collectedGravityData = [Gravity]()
    @Published private var collectedUserAccelerationData = [UserAcceleration]()
    @Published private var collectedAttitudeData = [Attitude]()
    @Published private var collectedRotationData = [RotationRate]()
    @Published private var collectedMagneticFieldData = [MagneticField]()
    @Published private var collectedHeadingData = [Heading]()
    
    public init(sensors: [Sensor], updateInterval: TimeInterval, dataCollectionInterval: Int) {
        
        self.sensors = sensors
        self.updateInterval = updateInterval
        self.dataCollectionInterval = dataCollectionInterval
    }
    
    public func startDataCollection() {
        
        if  motionManager.isDeviceMotionAvailable {
            
            readSensorData()
        }
        else {
            fatalError("Motion data is not available on this device.")
        }
    }
    
    private func readSensorData() {
        
        motionManager.deviceMotionUpdateInterval = updateInterval // Updates occur 60 times per second.
        motionManager.showsDeviceMovementDisplay = true
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(decreaseTimeOneSecond), userInfo: nil, repeats: true)
        
        self.motionManager.startDeviceMotionUpdates(using: .xMagneticNorthZVertical, to: self.queue, withHandler: { (motionData, error) in
            
            
            if let motionData = self.motionManager.deviceMotion {
                
                self.appendNewGravityReading(
                    gravity: motionData.gravity,
                    timestamp: motionData.timestamp
                )
                
                self.appendNewUserAccelerationReading(
                    userAcceleration: motionData.userAcceleration,
                    timestamp: motionData.timestamp
                )
                
                self.appendNewAttitudeReading(
                    attitude: motionData.attitude,
                    timestamp: motionData.timestamp
                )
                
                self.appendNewRotationRateReading(
                    rotationRate: motionData.rotationRate,
                    timestamp: motionData.timestamp
                )
                
                self.appendNewMagneticFieldReading(
                    magneticField: motionData.magneticField.field,
                    timestamp: motionData.timestamp
                )
                
                self.appendNewHeadingReading(
                    heading: motionData.heading,
                    timestamp: motionData.timestamp
                )
            }
        })
    }
    
    @objc private func decreaseTimeOneSecond() {
        
        dataCollectionInterval -= 1
        
        if dataCollectionInterval <= 0 {
            
            if timer != nil {
                
                timer!.invalidate()
                timer = nil
            }
            
            stopDataCollection()
        }
    }
    
    public func stopDataCollection() {
        
        self.motionManager.stopDeviceMotionUpdates()
    }
    
    private func exportCSVFile() {
        
    }
    
    // ------------- Gravity Data Getters and Append Function ------------- //
    
    public func getLastGravityReading() -> Gravity? {
        
        if let lastReading = collectedGravityData.last {
            return lastReading
        }
        
        return nil
    }
    
    private func appendNewGravityReading(gravity: CMAcceleration, timestamp: TimeInterval) {
        
        DispatchQueue.main.async {
            
            self.collectedGravityData.append(
                Gravity(
                    x: gravity.x,
                    y: gravity.y,
                    z: gravity.z,
                    timestamp: timestamp
                )
            )
        }
        
        //print(getLastGravityReading()!.toString())
    }
    
    // -------------------------------------------------------------------- //
    
    // ------------- User Acceleration Data Getters and Append Function ------------- //
    
    public func getLastUserAccelerationReading() -> UserAcceleration? {
        
        if let lastReading = collectedUserAccelerationData.last {
            return lastReading
        }
        
        return nil
    }
    
    private func appendNewUserAccelerationReading(userAcceleration: CMAcceleration, timestamp: TimeInterval) {
        
        DispatchQueue.main.async {
            
            self.collectedUserAccelerationData.append(
                UserAcceleration(
                    x: userAcceleration.x,
                    y: userAcceleration.y,
                    z: userAcceleration.z,
                    timestamp: timestamp
                )
            )
        }
        
        //print(getLastUserAccelerationReading()!.toString())
    }
    
    // ------------------------------------------------------------------------------ //
    
    // ------------- Attitude Data Getters and Append Function ------------- //
    
    public func getLastAttitudeReading() -> Attitude? {
        
        if let lastReading = collectedAttitudeData.last {
            return lastReading
        }
        
        return nil
    }
    
    private func appendNewAttitudeReading(attitude: CMAttitude, timestamp: TimeInterval) {
        
        DispatchQueue.main.async {
            
            self.collectedAttitudeData.append(
                Attitude(
                    pitch: attitude.pitch,
                    roll: attitude.roll,
                    yaw: attitude.yaw,
                    attitude: timestamp
                )
            )
        }
        
        //print(getLastAttitudeReading()!.toString())
    }
    
    // --------------------------------------------------------------------- //
    
    // ------------- Rotation Rate Data Getters and Append Function ------------- //
    
    public func getLastRotationRateReading() -> RotationRate? {
        
        if let lastReading = collectedRotationData.last {
            return lastReading
        }
        
        return nil
    }
    
    private func appendNewRotationRateReading(rotationRate: CMRotationRate, timestamp: TimeInterval) {
        
        DispatchQueue.main.async {
            
            self.collectedRotationData.append(
                RotationRate(
                    x: rotationRate.x,
                    y: rotationRate.y,
                    z: rotationRate.z,
                    timestamp: timestamp
                )
            )
        }
        
        //print(getLastRotationRateReading()!.toString())
    }
    
    // -------------------------------------------------------------------------- //
    
    // ------------- Magnetic Field Data Getters and Append Function ------------- //
    
    public func getLastMagneticFieldReading() -> MagneticField? {
        
        if let lastReading = collectedMagneticFieldData.last {
            return lastReading
        }
        
        return nil
    }
    
    private func appendNewMagneticFieldReading(magneticField: CMMagneticField, timestamp: TimeInterval) {
        
        DispatchQueue.main.async {
            
            self.collectedMagneticFieldData.append(
                MagneticField(
                    x: magneticField.x,
                    y: magneticField.y,
                    z: magneticField.z,
                    timestamp: timestamp
                )
            )
        }
        
        //print(getLastMagneticFieldReading()!.toString())
    }
    
    // --------------------------------------------------------------------------- //
    
    // ------------- Heading Data Getters and Append Function ------------- //
    
    public func getLastHeadingReading() -> Heading? {
        
        if let lastReading = collectedHeadingData.last {
            return lastReading
        }
        
        return nil
    }
    
    private func appendNewHeadingReading(heading: Double, timestamp: TimeInterval) {
        
        DispatchQueue.main.async {
            self.collectedHeadingData.append(
                Heading(
                    value: heading,
                    timestamp: timestamp
                )
            )
        }
        
        //print(getLastHeadingReading()!.toString())
    }
    
    // -------------------------------------------------------------------- //
}
