//
//  HealthKitViewController.swift
//  step-strikers-app
//
//  Created by Alekhya Kuchimanchi on 3/6/23.
//

import UIKit
import HealthKit

class HealthKitViewController: UIViewController {

    private let healthStore = HKHealthStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        authorizeHealthKit()
    }
    
    // This function provides to authorize the _HealthKit_.
    private func authorizeHealthKit() {
        let healthKitTypes: Set = [ HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)! ] // We want to access the step count.
        healthStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { (success, error) in  // We will check the authorization.
            if success {} // Authorization is successful.
        }
    }
    
    func getTodaysSteps(completion: @escaping (Double) -> Void) {
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(
            withStart: startOfDay,
            end: now,
            options: .strictStartDate
        )
        
        let query = HKStatisticsQuery(
            quantityType: stepsQuantityType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) { _, result, _ in
            guard let result = result, let sum = result.sumQuantity() else {
                completion(0.0)
                return 
            }
            completion(sum.doubleValue(for: HKUnit.count()))
        }
        
        healthStore.execute(query)
    }
    
    func getSteps() {
        if HKHealthStore.isHealthDataAvailable(){
            let writeDataTypes = dataTypesToWrite()
            let readDataTypes = dataTypesToWrite()
            
            healthStore.requestAuthorization(toShare: writeDataTypes as? Set<HKSampleType>, read: readDataTypes as? Set<HKObjectType>, completion: { (success, error) in
                if(!success){
                    print("error")
                    
                    return
                }
                DispatchQueue.main.async {
                    HealthKitViewController().getTodaysSteps() { sum in
                        steps = sum
                    }
                }
                
            })
        }
    }
    
    func dataTypesToWrite() -> NSSet{
        let stepsCount = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)

        let returnSet = NSSet(objects: stepsCount!)
        return returnSet
    }
    
    func dataTypesToRead() -> NSSet{
        let stepsCount = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
        let returnSet = NSSet(objects: stepsCount!)

        return returnSet
    }

}
