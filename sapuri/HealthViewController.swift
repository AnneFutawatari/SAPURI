//
//  HealthViewController.swift
//  sapuri
//
//  Created by 二渡杏 on 2019/12/16.
//  Copyright © 2019 二渡杏. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import HealthKit

class HealthViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    let healthStore = HKHealthStore()
    
    var myMapView: MKMapView!
    var myLocationManager: CLLocationManager!

    var stepsStringToday = 0.0
    var stepsStringWeek = 0.0
    var stepsStringMonth = 0.0

    
    @IBOutlet var todayLabel: UILabel!
    @IBOutlet var weekLabel: UILabel!
    @IBOutlet var monthLabel: UILabel!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getTodaysSteps{(steps)in
            self.stepsStringToday = steps
            print(steps)
        }
        
        getWeekSteps {(steps)in
            self.stepsStringWeek = steps
            print(steps)
        }
        
        getMonthSteps {(steps)in
            self.stepsStringMonth = steps
            print(steps)
        }
        
        // LocationManagerの生成.
        myLocationManager = CLLocationManager()

        // Delegateの設定.
        myLocationManager.delegate = self

        // 距離のフィルタ.
        myLocationManager.distanceFilter = 100.0

        // 精度.
        myLocationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters

        // セキュリティ認証のステータスを取得.
        let status = CLLocationManager.authorizationStatus()

        // まだ認証が得られていない場合は、認証ダイアログを表示.
        if(status != CLAuthorizationStatus.authorizedWhenInUse) {

            print("not determined")
            // まだ承認が得られていない場合は、認証ダイアログを表示.
            myLocationManager.requestWhenInUseAuthorization()
        }
        
        // 位置情報の更新を開始.
            myLocationManager.startUpdatingLocation()

            // MapViewの生成.
            myMapView = MKMapView()

            // Delegateを設定.
            myMapView.delegate = self

            // MapViewをViewに追加.
            self.view.addSubview(myMapView)

            // 中心点の緯度経度.
            let myLat: CLLocationDegrees = 37.506804
            let myLon: CLLocationDegrees = 139.930531
            let myCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(myLat, myLon) as CLLocationCoordinate2D

            // 縮尺.
            let myLatDist : CLLocationDistance = 100
            let myLonDist : CLLocationDistance = 100

            // Regionを作成.
            let myRegion: MKCoordinateRegion = MKCoordinateRegion(center: myCoordinate, latitudinalMeters: myLatDist, longitudinalMeters: myLonDist);

            // MapViewに反映.
            myMapView.setRegion(myRegion, animated: true)
            myMapView.setCenter(myMapView.userLocation.coordinate, animated: true)
            myMapView.userTrackingMode = MKUserTrackingMode.follow
    }
    
    override func viewDidAppear(_ animated: Bool) {
        todayLabel.text = String(stepsStringToday)
        weekLabel.text = String(stepsStringWeek)
        monthLabel.text = String(stepsStringMonth)
    }
        
    //今日の現在時刻までの歩数を取得する
    func getTodaysSteps(completion: @escaping (Double) -> Void) {
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!

        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)

        let query = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            guard let result = result, let sum = result.sumQuantity() else {
                completion(0.0)
                return
            }
            completion(sum.doubleValue(for: HKUnit.count()))
        }

        healthStore.execute(query)
    }
    
    //1週間前から今日までの現在時刻までの歩数を取得する
    func getWeekSteps(completion: @escaping (Double) -> Void) {
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!

        let calendar = Calendar.current
        let now = Date()
        let lastWeek = calendar.date(byAdding: .weekday, value: -1, to: calendar.startOfDay(for: now))
        let predicate = HKQuery.predicateForSamples(withStart: lastWeek, end: now, options: .strictStartDate)

        let query = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            guard let result = result, let sum = result.sumQuantity() else {
                completion(0.0)
                return
            }
            completion(sum.doubleValue(for: HKUnit.count()))
        }

        healthStore.execute(query)
    }
    
    //1ヶ月前から現在までの歩数を取得する
    func getMonthSteps(completion: @escaping (Double) -> Void) {
            let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!

            let calendar = Calendar.current
            let now = Date()
            let lastMonth = calendar.date(byAdding: .month, value: -1, to: calendar.startOfDay(for: now))
            let predicate = HKQuery.predicateForSamples(withStart: lastMonth, end: now, options: .strictStartDate)

            let query = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
                guard let result = result, let sum = result.sumQuantity() else {
                    completion(0.0)
                    return
                }
                completion(sum.doubleValue(for: HKUnit.count()))
            }

            healthStore.execute(query)
        }
    
    // GPSから値を取得した際に呼び出されるメソッド.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        print("didUpdateLocations")

        // 配列から現在座標を取得.
        let myLocations: NSArray = locations as NSArray
        let myLastLocation: CLLocation = myLocations.lastObject as! CLLocation
        let myLocation:CLLocationCoordinate2D = myLastLocation.coordinate

        print("\(myLocation.latitude), \(myLocation.longitude)")

        // 縮尺.
        let myLatDist : CLLocationDistance = 100
        let myLonDist : CLLocationDistance = 100

        // Regionを作成.
        let myRegion: MKCoordinateRegion = MKCoordinateRegion(center: myLocation, latitudinalMeters: myLatDist, longitudinalMeters: myLonDist);

        // MapViewに反映.
        myMapView.setRegion(myRegion, animated: true)
    }
    
    // Regionが変更した時に呼び出されるメソッド.
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("regionDidChangeAnimated")
    }

    // 認証が変更された時に呼び出されるメソッド.
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            print("AuthorizedWhenInUse")
        case .authorizedAlways:
            print("AuthorizedAlways")
        case .denied:
            print("Denied")
        case .restricted:
            print("Restricted")
        case .notDetermined:
            print("NotDetermined")
        @unknown default: break
        }
    }
}
