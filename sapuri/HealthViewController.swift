//
//  HealthViewController.swift
//  sapuri
//
//  Created by 二渡杏 on 2019/12/16.
//  Copyright © 2019 二渡杏. All rights reserved.
//

import UIKit
import HealthKit

class HealthViewController: UIViewController {
    
    let saveData: UserDefaults = UserDefaults.standard
    @IBOutlet var startButton: UIButton!
    
    @IBOutlet var todayLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func back() {
        
    }
    
    func loadWalkCount(start: Date, end: Date) {
        
        let store = HKHealthStore()
        let types: Set<HKSampleType> = [
            HKSampleType.quantityType(forIdentifier: .stepCount)!
        ]
        
        store.requestAuthorization(toShare: types, read: types) { success, error in
            if success {
                print("認証成功")
            }
        }
        
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end)
        if let type = types.first {
            let query = HKStatisticsQuery(quantityType: type as! HKQuantityType,
                                          quantitySamplePredicate: predicate,
                                          options: .cumulativeSum) { (query, statistics, error) in
                                            DispatchQueue.main.async {
                                                if let walkCount = statistics?.sumQuantity()?.description {
                                                    self.todayLabel.text = walkCount
                                                } else {
                                                    self.todayLabel.text = "読み込めませんでした"
                                                }
                                            }
                                            
            }
            store.execute(query)
        }
        
    }
    
    @IBAction func walkStart() {
        
        if startButton.titleLabel?.text == "start" {
            saveData.set(Date(), forKey:"walkStart")
            startButton.setTitle("walkStop", for: .normal)
        } else {
            let startTime = saveData.object(forKey: "walkStart") as! Date
            let currentTime = Date()
            loadWalkCount(start: startTime, end: currentTime)
            startButton.setTitle("start", for: .normal)
        }
    }
    
    
    
    
    }
