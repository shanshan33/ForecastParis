//
//  ForecastViewModel.swift
//  Weather
//
//  Created by Shanshan Zhao on 21/11/2017.
//  Copyright © 2017 Shanshan Zhao. All rights reserved.
//

import Foundation
import UIKit

class ForecastViewModel {
    static let iconImagePattern = "http://openweathermap.org/img/w/%id%.png"
    let forecastAPI = ForecastAPI()
    var forcast: Forecast?
    
    var cityName: String = ""
    var currentTemperature: String = ""
    var lists: [List] = []

    func fetchForecastForParis(completionHandler: @escaping (_ city: City?,_ lists: [List]?, _ error: Error?) -> Void) {
        forecastAPI.fetchForecast("https://api.openweathermap.org/data/2.5/forecast?id=6455259&appid=00f7f80aa3f203c7b7eaf6a31ea64c08", withCompletion: { [weak self] (result) in
            switch result {
            case.success(let forecast):
                self?.forcast = forecast
                guard let city = self?.forcast?.city else { return }
                guard let lists = self?.forcast?.list else { return }
                completionHandler(city,lists, nil)
            case.failure(let error):
                completionHandler(nil, [], error?.localizedDescription as? Error)
            }
        })
    }
    
    func fetchForcastOnLoad(completion: @escaping (_ viewModel: ForecastViewModel) -> Void) {
        fetchForecastForParis(completionHandler: { (city, lists, error) in
            guard let name = city?.name, let temp = lists?.first?.temp?.averageTemp, let infos = lists else { return }
            self.cityName = name
            self.currentTemperature = self.tempToCelsius(kelvin: temp)
            self.lists = infos
            completion(self)
        })
    }
    
    func tempToCelsius(kelvin: Double) -> String {
        let celsius = kelvin - 273.16
        return String(format: "%.0fºC", celsius)
    }
    
    func fetchForecastIcon(imagePattern: String, weather: Weather, completion:@escaping (_ icon: UIImage) -> Void ) {
        let urlString = imagePattern.replacingOccurrences(of: "%id%", with: weather.icon)
        if let iconURL = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: iconURL) { data, _, error in
                if error != nil {
                    return
                }
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        completion(image)
                    }
                }
            }
            task.resume()
        }
    }
    
    
    
}
