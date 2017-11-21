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
    let forecastAPI: ForecastAPI
    var forcast: Forecast?
//    let cityName: String
//    let currentWeatherIcon: UIImage
//    let temperatureAverage: String
//    let temperatureMaxMin: String
    
    
    init(forecastAPI: ForecastAPI, forcast:Forecast) {
        self.forecastAPI = forecastAPI
        self.forcast = forcast
    }
    
    func fetchForecastForParis(completionHandler: @escaping (_ lists: [List], _ error: Error?) -> Void) {
        forecastAPI.fetchForecast("https://api.openweathermap.org/data/2.5/forecast?id=6455259&appid=00f7f80aa3f203c7b7eaf6a31ea64c08", withCompletion: { [weak self] (result) in
            switch result {
            case.success(let forecast):
                self?.forcast = forecast
                guard let lists = self?.forcast?.list else { return }
                completionHandler(lists, nil)
            case.failure(let error):
                completionHandler([], error?.localizedDescription as? Error)
            }
        })
    }
    
    func fetchForcastOnLoad() {
        fetchForecastForParis(completionHandler: {_,_ in })
    }
    
    func cityForForecast() -> String? {
        guard let city = forcast?.city?.name else { return nil }
        return city
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
