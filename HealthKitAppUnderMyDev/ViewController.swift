//
//  ViewController.swift
//  HealthKitAppUnderMyDev
//
//  Created by VC on 06/05/24.
//

import UIKit
import HealthKitReporter

class ViewController: UIViewController {
    
    @IBOutlet weak var readButton: UIButton!
    @IBOutlet weak var writeButton: UIButton!

    private let healthKitReporterSerivce = HealthKitReporterService()

    override func viewDidLoad() {
        super.viewDidLoad()
        readButton.isEnabled = false
        writeButton.isEnabled = false
    }

    @IBAction func authorizeButtonTapped(_ sender: UIButton) {
        healthKitReporterSerivce.requestAuthorization { success, error in
            if success && error == nil {
                DispatchQueue.main.async { [unowned self] in
                    let alert = UIAlertController(
                        title: "HK",
                        message: "HK Authorized",
                        preferredStyle: .alert
                    )
                    alert.addAction(
                        UIAlertAction(
                            title: "OK",
                            style: .default
                        ) { [unowned self] (_) in
                            self.readButton.isEnabled = true
                            self.writeButton.isEnabled = true
                        }
                    )
                    self.present(alert, animated: true)
                }
            } else {
                print(error ?? "error")
            }
        }
    }
    @IBAction func readButtonTapped(_ sender: UIButton) {
        healthKitReporterSerivce.readCategories()
        healthKitReporterSerivce.readElectrocardiogram()
        healthKitReporterSerivce.readQuantitiesAndStatistics()
    }
    @IBAction func writeButtonTapped(_ sender: UIButton) {
        healthKitReporterSerivce.writeSteps()
        healthKitReporterSerivce.writeBloodPressureCorrelation()
    }
    @IBAction func seriesButtonTapped(_ sender: UIButton) {
        healthKitReporterSerivce.readWorkoutRoutes()
        healthKitReporterSerivce.readHearbeatSeries()
    }
}



extension ViewController {
    
    //MARK: Back action using navigation
    @IBAction func backIconBtn_Pressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
}


