//
//  ViewController.swift
//  Weather
//
//  Created by Shanshan Zhao on 20/11/2017.
//  Copyright © 2017 Shanshan Zhao. All rights reserved.
//

import UIKit

/**
 *  A 'ViewController' has a stackView for basic weather infomation of Today,
 *  it also includes a collectionView and each cell shows time, weather, tempreture.
 */

class ViewController: UIViewController {
    
    
    
    @IBOutlet weak var basicInfoStackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var cityBasicInfoStackView: UIStackView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherDiscriptionLabel: UILabel!
    @IBOutlet weak var blackOverlayView: UIView!

    @IBOutlet weak var stickHeaderView: CollectionViewHeaderView!

    @IBOutlet weak var detailsWeatherScrollViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var detailsWeatherScrollView: UIScrollView!
    @IBOutlet weak var weatherCollectionView: UICollectionView!

    var viewModel = ForecastViewModel()
    var forecastViewModels : [ForecastViewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configFriendlyUI()
        fetchDataOnLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func configFriendlyUI() {
        self.view.layer.contents = UIImage(named: "background")?.cgImage
        detailsWeatherScrollView.roundCorners(corners: [.topLeft, .topRight], radius: 25)
        weatherCollectionView.backgroundColor =  UIColor(white: 1, alpha: 1)
    }
    
    func fetchDataOnLoad() {
        viewModel.fetchForecastForParis { (viewModels, error) in
            self.forecastViewModels = viewModels
            DispatchQueue.main.async {
                self.cityNameLabel.text = viewModels.first?.cityName
                self.weatherDiscriptionLabel.text = viewModels.first?.weatherDescription
                self.temperatureLabel.text = viewModels.first?.averageTemp
                self.weatherCollectionView.reloadData()
            }
        }
    }
}

/* Animation scroll */
extension ViewController: UIScrollViewDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool{
        return false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        weatherCollectionView.translatesAutoresizingMaskIntoConstraints = false
        let panGesturePointY = scrollView.panGestureRecognizer.translation(in: scrollView.superview).y
        //Scroll down
        if panGesturePointY > 0 {
//            self.detailsWeatherScrollViewTopConstraint.constant = 400
            UIView.animate(withDuration: 0.3) {
                self.blackOverlayView.alpha = 0.25
 //               self.stickHeaderView.alpha = 1
                self.weatherCollectionView.layoutIfNeeded()
            }
        }
        else {
//            self.detailsWeatherScrollViewTopConstraint.constant = 310   //         basicInfoStackViewTopConstraint.constant = 130
            UIView.animate(withDuration: 0.3) {
                self.blackOverlayView.alpha = 0.6
//                self.stickHeaderView.alpha = 0
                self.weatherCollectionView.layoutIfNeeded()
            }
        }
    }
}

extension ViewController :UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

extension ViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.forecastViewModels.count > 0 ? self.forecastViewModels.count : 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell", for: indexPath) as? ForcastCollectionViewCell
        if self.forecastViewModels.count > 0 {
            cell?.configCell(viewModel: self.forecastViewModels[indexPath.row] )
        }
        return cell!
    }
    
}



