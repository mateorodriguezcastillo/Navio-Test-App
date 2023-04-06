import UIKit
import HealthKit

class ViewController: UIViewController {
    let healthStore = HKHealthStore()
    
    // Define a label to display the HRV value
    let textDisplayLabel = UILabel()
    let hrvLabel = UILabel()
    
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
                        self?.hrvLabel.text = "\(HRV) ms"
                    }
        }
        
        healthStore.execute(query)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = tabBarItem.title
        view.backgroundColor = .systemBackground
        
        // Set the label's position and size
            self.textDisplayLabel.text = "Latest HRV"
        
            textDisplayLabel.frame = CGRect(x: view.bounds.width/2 - 40, y: 100, width: view.bounds.width/3, height: view.bounds.height/9)
        
            hrvLabel.frame = CGRect(x: 20, y: view.bounds.height/3, width: view.bounds.width, height: view.bounds.height/3)
            
            // Add the label to the view
            view.addSubview(hrvLabel)
            view.addSubview(textDisplayLabel)
            
            // Set the label's properties
            hrvLabel.backgroundColor = .systemBackground
            hrvLabel.textColor = .red
            hrvLabel.textAlignment = .center
            hrvLabel.font = UIFont.systemFont(ofSize: 60, weight: .bold)
        
        authorizeHealthKit()
    }
}

