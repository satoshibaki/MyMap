//
//  ViewController.swift
//  MyMap
//
//  Created by 中村智史 on 2021/03/02.
//

import UIKit
import MapKit

class ViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //textfieldのdelegate通知を設定
        inputText.delegate = self
        
    }

    @IBOutlet weak var inputText: UITextField!
    
    @IBOutlet weak var dispMap: MKMapView!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //キーボードを閉じる
        textField.resignFirstResponder()
        
        //入力された文字を取り出す
        if let searthKey = textField.text {
            //入力された文字をデバッグエリアに表示
            print(searthKey)
            
            //CLインスタンスを取得
            let geocoder = CLGeocoder()
            
            //入力された文字から位置情報を取得
            geocoder.geocodeAddressString(searthKey, completionHandler: { (placemarks,error) in
                
                //位置情報が存在する場合は、unwrapPlacemarksに取り出す
                if let unwrapPlacemarks = placemarks {
                    
                    //1件目の情報を取り出す
                    if let firstPlacemark = unwrapPlacemarks.first {
                        
                        //位置情報を取り出す
                        if let location = firstPlacemark.location {
                            
                            //位置情報から緯度軽度をtargetCoordineteに取り出す
                            let targetCoordinate = location.coordinate
                            
                            //緯度軽度をデバックエリアに表示
                            print(targetCoordinate)
                            
                            //MKPointAnnotaitonインスタンスを取得し、ビンを生成
                            let pin = MKPointAnnotation()
                            
                            //ピンの置く場所に緯度軽度を設定
                            pin.coordinate = targetCoordinate
                            
                            //ピンのタイトルを設定
                            pin.title = searthKey
                            
                            //ピンを地図に置く
                            self.dispMap.addAnnotation(pin)
                            
                            //緯度軽度を中心にして半径５００mの範囲を表示
                            self.dispMap.region = MKCoordinateRegion(center: targetCoordinate, latitudinalMeters: 500.0, longitudinalMeters: 500.0)
                            
                            
                        }
                        
                    }
                }
            })
            
        }
        //デフォルトに動作をおこなうのでtrueを返す
        return true
    }
    
    @IBAction func changeMapButton(_ sender: Any) {
        //maptypeプロパティ値をトグル
        //標準→航空写真→航空写真＋標準
        //→3Dflyover+標準
        //→交通機関
        if dispMap.mapType == .standard {
            dispMap.mapType = .satellite
        } else if dispMap.mapType == .satellite {
            dispMap.mapType = .hybrid
        } else if dispMap.mapType == .hybrid {
            dispMap.mapType = .satelliteFlyover
        } else if dispMap.mapType == .satelliteFlyover {
            dispMap.mapType = .hybridFlyover
        } else if dispMap.mapType == .hybridFlyover {
            dispMap.mapType = .mutedStandard
        } else {
            dispMap.mapType = .standard
        }
        
    }
}
