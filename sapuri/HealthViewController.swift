//
//  HealthViewController.swift
//  sapuri
//
//  Created by 二渡杏 on 2019/12/16.
//  Copyright © 2019 二渡杏. All rights reserved.
//

import UIKit
import CoreMotion
import CoreLocation
import MapKit
import HealthKit

class HealthViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var myMapView: MKMapView!
    var myLocationManager: CLLocationManager!
    var myPedometer: CMPedometer!
    
    let saveData: UserDefaults = UserDefaults.standard
    @IBOutlet var startButton: UIButton!
    @IBOutlet var todayLabel: UILabel!
    @IBOutlet var monthLabel: UILabel!
    
    var numberArray:[Int] = []
    
    @IBOutlet var hour2Label: UILabel!
    @IBOutlet var hour1Label: UILabel!
    @IBOutlet var minuts2Label: UILabel!
    @IBOutlet var minuts1Label: UILabel!
    @IBOutlet var second2Label: UILabel!
    @IBOutlet var second1Label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let saveState = saveData.object(forKey: "walkStart")
        if saveState != nil{
            startButton.setTitle("walkStop", for: .normal)
        }
        if let array = saveData.array(forKey: "steps") {
            numberArray = array as![Int]
        }
        
        let timer = Timer.scheduledTimer(timeInterval: 1.0,
                                         target: self,
                                         selector: #selector(time),
                                         userInfo: nil,
                                         repeats: true)
        timer.fire()
        
        //歩数計の生成
        myPedometer = CMPedometer()
        
        //ペドメーター（歩数計）で計測開始
        myPedometer.startUpdates(from: NSDate() as Date, withHandler: { (pedometerData, error) in
            if let e = error {
                print(e.localizedDescription)
                return
            }
            guard let data = pedometerData else {
                return
            }
            let myStep = data.numberOfSteps
        self.todayLabel.text = "\(myStep) 歩"
        })
        
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
    
    @objc func time(){
        
        let date: Date = Date()
        let calender: Calendar = Calendar(identifier: .gregorian)
        let components: DateComponents = calender.dateComponents([.hour, .minute, .second], from: date)
        
        let hour:Int = components.hour!
        let minute:Int = components.minute!
        let second:Int = components.second!
        
        hour2Label.text = String(hour / 10)
        hour1Label.text = String(hour % 10)
        minuts2Label.text = String(minute / 10)
        minuts1Label.text = String(minute % 10)
        second2Label.text = String(second / 10)
        second1Label.text = String(second % 10)
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
    
    func loadWalkCount(){
        let start = Calendar.current.date(byAdding: .month, value: -1, to: Date())
        let end = Date()
        
        let store = HKHealthStore()
        let types: Set<HKSampleType> = [
            HKSampleType.quantityType(forIdentifier: .stepCount)!
        ]
        store.requestAuthorization(toShare: types, read: types) { success, error in
            if success{
                print("認証成功")
            }
        }
        
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end)
        if let type = types.first {
            let query = HKStatisticsQuery(quantityType: type as! HKQuantityType,
                                          quantitySamplePredicate: predicate,
                                          options: .cumulativeSum){ (query, statistics, error) in
                                            
                                            if let walkCount = statistics?.sumQuantity()?.description {
                                                let count = walkCount.replacingOccurrences(of: " count", with: "")
                                                self.numberArray.append(Int(count)!)
                                                self.saveData.set(self.numberArray, forKey: "steps")
                                                self.monthLabel.text = count
                                            } else {
                                                print("--1--")
                                                self.monthLabel.text = "--2--"
                                            }
            }
            store.execute(query)
        }
    }
    
    @IBAction func walkStart() {
        self.monthLabel.text = "歩数が表示されます"
        
        if startButton.titleLabel?.text == "start" {
            saveData.set(Data(), forKey: "walkStart")
            startButton.setTitle("walkStop", for: .normal)
        } else {
            loadWalkCount()
            startButton.setTitle("start", for: .normal)
            saveData.removeObject(forKey: "walkStart")
        }
    }
}
