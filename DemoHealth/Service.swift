//
//  StepsService.swift
//  DemoHealth
//
//  Created by Talida on 26.11.2025.
//

import HealthKit

struct StepsService {
    let healthStore: HKHealthStore

    init(healthStore: HKHealthStore) {
        self.healthStore = healthStore
    }

    // Suma pașilor din ultimele 24 de ore.
    func fetchStepsLast24h(completion: @escaping (Double) -> Void) {
        // 1) Tipul de date
//        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
//            completion(0)
//            return
//        }
        let stepType =  HKQuantityType.quantityType(forIdentifier: .stepCount)!

        // 2) Interval: acum și cu 24h în urmă
        let now = Date()
        let fromDate = Date(timeIntervalSinceNow: -24 * 60 * 60)

        // 3) Predicate: mostra între fromDate și now
        let predicate = HKQuery.predicateForSamples(withStart: fromDate, end: now, options: [])

        // 4) Sortare opțională: de la cele mai noi la cele mai vechi
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)

        // 5) Query-ul efectiv
        let query = HKSampleQuery(sampleType: stepType,
                                  predicate: predicate,
                                  limit: HKObjectQueryNoLimit,
                                  sortDescriptors: [sortDescriptor]) { _, samples, error in
            // 6) Tratare erori
            if let error = error {
                NSLog("HKSampleQuery error: \(error.localizedDescription)")
                completion(0)
                return
            }

            // 7) Convertim la HKQuantitySample și însumăm valorile
          
            let quantitySamples = (samples as? [HKQuantitySample]) ?? []
            let unit = HKUnit.count()

            var total = 0.0
            for sample in quantitySamples {
                let value = sample.quantity.doubleValue(for: unit)
                total += value
            }

            // la final, folosești `total` (ex: completion(total))

            // 8) Returnăm rezultatul
            completion(total)
        }

        // 9) Lansăm query-ul
        healthStore.execute(query)
    }
}
