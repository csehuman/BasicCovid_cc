//
//  CovidOverViewController.swift
//  BasicCovidApp
//
//  Created by Paul Lee on 2022/09/21.
//

import UIKit

class CovidOverViewController: UITableViewController {
    @IBOutlet weak var newCaseCell: UITableViewCell!
    @IBOutlet weak var totalCaseCell: UITableViewCell!
    @IBOutlet weak var recoveredCell: UITableViewCell!
    @IBOutlet weak var deathCell: UITableViewCell!
    @IBOutlet weak var percentageCell: UITableViewCell!
    @IBOutlet weak var overseasInflowCell: UITableViewCell!
    @IBOutlet weak var regionalOutbreakCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
