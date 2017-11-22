//
//  ViewController.swift
//  Weather
//
//  Created by Shanshan Zhao on 20/11/2017.
//  Copyright © 2017 Shanshan Zhao. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var basicInfoStackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var weatherCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var cityBasicInfoStackView: UIStackView!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var blackOverlayView: UIView!

    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherDiscriptionLabel: UILabel!

    var viewModel = ForecastViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.contents = UIImage(named: "background")?.cgImage
        weatherCollectionView.layer.cornerRadius = 10
        weatherCollectionView.backgroundColor =  UIColor(white: 1, alpha: 0.9)

        viewModel.fetchForcastOnLoad { (viewModels) in
            DispatchQueue.main.async {
                self.cityNameLabel.text = viewModels.first?.cityName
                self.temperatureLabel.text = viewModels.first?.averageTemp
                self.weatherDiscriptionLabel.text = viewModels.first?.weatherDescription
           }
            self.viewModel.fetchForecastIcon(url: (viewModels.first?.iconURL)!, completion: {(image) in
                self.weatherIconImageView.image = image
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        weatherCollectionView.translatesAutoresizingMaskIntoConstraints = false
        if scrollView.panGestureRecognizer.translation(in: scrollView.superview).y > 0
        {
            collectionViewTopConstraint.constant = 450
            basicInfoStackViewTopConstraint.constant = 150
            UIView.animate(withDuration: 0.3) {
                self.blackOverlayView.alpha = 0.2
                self.weatherIconImageView.alpha = 1
                self.weatherDiscriptionLabel.alpha = 1
                self.weatherCollectionView.layoutIfNeeded()
            }
        }
        else
        {
            collectionViewTopConstraint.constant = 240
            basicInfoStackViewTopConstraint.constant = 130
            UIView.animate(withDuration: 0.3) {
                self.blackOverlayView.alpha = 0.6
                self.weatherIconImageView.alpha = 0
                self.weatherDiscriptionLabel.alpha = 0
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



