import WatchKit
import Foundation
import HealthKit

class InterfaceController: WKInterfaceController {
    @IBOutlet weak var hrvLabel: WKInterfaceLabel!
    
    let healthStore = HKHealthStore()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        authorizeHealthKit()
    }
    
    func authorizeHealthKit(){
        let read = Set([HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!])
        let share = Set([HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!])
        healthStore.requestAuthorization(toShare: share, read: read) { (chk, error) in
            if (chk) {
                print("permission granted")
                self.latestHRV()
            }
        }
    }
    
    func latestHRV(){
        guard let sampleType = HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN) else {
            return
        }
        
        let startDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictEndDate)
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        var HRV = 0.0
        
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [sortDescriptor]) { (sample, result, error) in
            guard error == nil else {
                return
            }
            let data = result![0] as! HKDiscreteQuantitySample
            let unit = HKUnit(from: "ms")
            let latestHRV = data.quantity.doubleValue(for: unit)
            HRV = latestHRV
            print("Latest HRV \(latestHRV) ms")
            
            // Update the label's text property with the HRV value
            DispatchQueue.main.async { [weak self] in
                self?.hrvLabel.setText("\(HRV)")
            }
        }
        
        healthStore.execute(query)
    }
}

