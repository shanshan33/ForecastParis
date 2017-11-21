//
//  ViewController.swift
//  Weather
//
//  Created by Shanshan Zhao on 20/11/2017.
//  Copyright © 2017 Shanshan Zhao. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var weatherCollectionView: UICollectionView!
    @IBOutlet weak var weatherImageView: UIView!
    @IBOutlet weak var collectionViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var cityBasicInfoStackView: UIStackView!
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    var forecastAPI = ForecastAPI()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.contents = UIImage(named: "background")?.cgImage
        weatherCollectionView.layer.cornerRadius = 10
        weatherCollectionView.backgroundColor =  UIColor(white: 1, alpha: 0.9)
        forecastAPI.fetchForecast("https://api.openweathermap.org/data/2.5/forecast?id=6455259&appid=00f7f80aa3f203c7b7eaf6a31ea64c08", withCompletion: {_ in})
        presentBasicWeatherInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func presentBasicWeatherInfo() {
//        cityNameLabel.text = viewModel?.cityForForecast()
    }
}

extension ViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        weatherCollectionView.translatesAutoresizingMaskIntoConstraints = false
        if scrollView.panGestureRecognizer.translation(in: scrollView.superview).y > 0
        {
            collectionViewTopConstraint.constant = 450
            UIView.animate(withDuration: 0.3) {
                self.weatherImageView.alpha = 1
                self.weatherCollectionView.layoutIfNeeded()
            }
        }
        else
        {
            collectionViewTopConstraint.constant = 300
            UIView.animate(withDuration: 0.3) {
                self.weatherImageView.alpha = 0
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
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell", for: indexPath)
        return cell
    }
    
}



