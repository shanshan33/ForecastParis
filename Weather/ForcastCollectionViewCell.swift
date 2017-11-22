//
//  ForcastCollectionViewCell.swift
//  Weather
//
//  Created by Shanshan Zhao on 21/11/2017.
//  Copyright © 2017 Shanshan Zhao. All rights reserved.
//

import UIKit

class ForcastCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var weekdayLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var tempetureMaxLabel: UILabel!
    @IBOutlet weak var tempetureMinLabel: UILabel!
    
    
    public func configCell(viewModel:ForecastViewModel) {
        self.weatherDescriptionLabel.text = viewModel.weatherDescription
        
        viewModel.fetchForecastIcon(url: viewModel.iconURL!, completion: {(image) in
            self.weatherIconImageView.image = image
        })
        
        self.tempetureMaxLabel.text = viewModel.maxTemp
        self.tempetureMinLabel.text = viewModel.minTemp
        self.weekdayLabel.text = viewModel.weekday
        self.hourLabel.text = viewModel.weekday
    }
}
