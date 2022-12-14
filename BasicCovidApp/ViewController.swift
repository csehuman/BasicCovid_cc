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
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingIndicator.startAnimating()
        stackView.alpha = 0.0
        pieChartView.alpha = 0.0
        
        fetchCityCovidOverview { result in
            switch result {
            case .success(let result):
                self.configureStackView(overview: result.korea)
                self.configuePieChartView(cityCovidOverview: result)
                self.loadingIndicator.stopAnimating()
                self.loadingIndicator.alpha = 0.0
                self.stackView.alpha = 1.0
                self.pieChartView.alpha = 1.0
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func configuePieChartView(cityCovidOverview: CityCovidOverview) {
        pieChartView.delegate = self
        
        let covideOverviewList = makeCovidOverViewList(cityCovidOverview: cityCovidOverview)
        let entries = covideOverviewList.compactMap { [weak self] covidOverview -> PieChartDataEntry? in
            guard let self = self else { return nil }
            return PieChartDataEntry(value: self.stringToNumber(string: covidOverview.newCase), label: covidOverview.countryName, data: covidOverview)
        }
        let dataSet = PieChartDataSet(entries: entries, label: "코로나 발생 현황")
        dataSet.sliceSpace = 1
        dataSet.entryLabelColor = .black
        dataSet.valueTextColor = .black
        dataSet.xValuePosition = .outsideSlice
        dataSet.valueLinePart1OffsetPercentage = 0.8
        dataSet.valueLinePart1Length = 0.2
        dataSet.valueLinePart2Length = 0.3
        
        dataSet.colors = ChartColorTemplates.vordiplom() + ChartColorTemplates.joyful() + ChartColorTemplates.liberty() + ChartColorTemplates.pastel() + ChartColorTemplates.material()
        
        pieChartView.data = PieChartData(dataSet: dataSet)
        pieChartView.spin(duration: 0.3, fromAngle: pieChartView.rotationAngle, toAngle: pieChartView.rotationAngle + 80)
    }
    
    func configureStackView(overview: CovidOverview) {
        totalCaseLabel.text = "\(overview.totalCase)명"
        newCaseLabel.text =  "\(overview.newCase)명"
    }
    
    func stringToNumber(string: String) -> Double {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let number = formatter.number(from: string)?.doubleValue ?? 0
        
        return number
    }
    
    func makeCovidOverViewList(cityCovidOverview: CityCovidOverview) -> [CovidOverview] {
        return [
            cityCovidOverview.seoul,
            cityCovidOverview.busan,
            cityCovidOverview.daegu,
            cityCovidOverview.incheon,
            cityCovidOverview.gwangju,
            cityCovidOverview.daejeon,
            cityCovidOverview.ulsan,
            cityCovidOverview.sejong,
            cityCovidOverview.gyeonggi,
            cityCovidOverview.chungbuk,
            cityCovidOverview.chungnam,
            cityCovidOverview.gyeongbuk,
            cityCovidOverview.gyeongnam,
            cityCovidOverview.jeju
        ]
    }

    func fetchCityCovidOverview(completion: @escaping (Result<CityCovidOverview, Error>) -> ()) {
        let url = "https://api.corona-19.kr/korea/country/new/"
        guard let serviceKey = Bundle.main.object(forInfoDictionaryKey: "SERVICE_KEY") else { return }
        let param = ["serviceKey": serviceKey]
        
        AF.request(url, method: .get, parameters: param)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(CityCovidOverview.self, from: data)
                        completion(.success(result))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}

extension ViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        guard let covidOverviewVC = storyboard?.instantiateViewController(withIdentifier: "CovidOverViewController") as? CovidOverViewController else { return }
        guard let covidOverview = entry.data as? CovidOverview else { return }
        covidOverviewVC.covidOverview = covidOverview
        navigationController?.pushViewController(covidOverviewVC, animated: true)
    }
}
