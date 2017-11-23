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
    @IBOutlet weak var weatherCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var cityBasicInfoStackView: UIStackView!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var blackOverlayView: UIView!

    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherDiscriptionLabel: UILabel!

    var viewModel = ForecastViewModel()
    var forecastViewModels : [ForecastViewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.contents = UIImage(named: "background")?.cgImage
        weatherCollectionView.layer.cornerRadius = 12
        weatherCollectionView.backgroundColor =  UIColor(white: 1, alpha: 1)

        viewModel.fetchForecastForParis { (viewModels, error) in
            self.forecastViewModels = viewModels
            DispatchQueue.main.async {
                self.cityNameLabel.text = viewModels.first?.cityName
                self.weatherDiscriptionLabel.text = viewModels.first?.weatherDescription
                self.temperatureLabel.text = viewModels.first?.averageTemp
                self.weatherCollectionView.reloadData()
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

/* Animation scroll */
extension ViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        weatherCollectionView.translatesAutoresizingMaskIntoConstraints = false
        if scrollView.panGestureRecognizer.translation(in: scrollView.superview).y > 0
        {
            collectionViewTopConstraint.constant = 450
            basicInfoStackViewTopConstraint.constant = 150
            UIView.animate(withDuration: 0.3) {
                self.blackOverlayView.alpha = 0.25
                self.weatherIconImageView.alpha = 1
                self.temperatureLabel.alpha = 1
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
                self.temperatureLabel.alpha = 0
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String,at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: "Header",
                                                                         for: indexPath) as! CollectionReusableHeaderView
        return headerView
    }
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



