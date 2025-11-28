//
//  HealthStore.swift
//  DemoHealth
//

import HealthKit


final class HealthKitManager {

    private let healthStore = HKHealthStore()

    // Fă init-ul accesibil dacă vei crea instanțe din afară; altfel poți păstra private dacă ai un pattern de tip singleton.
    init() {}

    // Variante simplă cu completion (callback).
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        // 1) Verifică dacă HealthKit e disponibil.
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false)
            return
        }

        // 2) Creează setul de tipuri pe care vrei să le CITEȘTI.
        var readTypes = Set<HKObjectType>()

        // 3) Obține tipul pentru număr de pași și adaugă-l în set.
        if let stepsType = HKObjectType.quantityType(forIdentifier: .stepCount) {
            readTypes.insert(stepsType)
        } else {
            // Nu am putut obține tipul; anunțăm eșecul.
            completion(false)
            return
        }

        // 4) Cere autorizare. Nu scriem nimic (toShare: nil), doar citim (read: readTypes).
        healthStore.requestAuthorization(toShare: nil, read: readTypes) { success, error in
            // 5) AICI este "closure"-ul HealthKit. Când se termină promptul,
            //    HealthKit ne cheamă cu 'success'. Noi, la rândul nostru,
            //    chemăm closure-ul primit de la apelant: 'completion(success)'.
            if let error = error {
                // Poți loga eroarea pentru debugging; nu poți arunca aici.
                NSLog("HealthKit authorization error: \(error.localizedDescription)")
                completion(false)
                return
            }
            completion(success)
        }
    }

        
    
}
