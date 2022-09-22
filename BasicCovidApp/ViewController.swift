//
//  ViewController.swift
//  BasicCovidApp
//
//  Created by Paul Lee on 2022/09/21.
//

import UIKit

import Alamofire
import Charts

class ViewController: UIViewController {
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var totalCaseLabel: UILabel!
    @IBOutlet weak var newCaseLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

