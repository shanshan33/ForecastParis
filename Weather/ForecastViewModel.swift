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

    var cityName: String = ""
    var weekday: String = ""
    var averageTemp: String = ""
    var maxTemp: String = ""
    var minTemp: String = ""
    var iconURL: URL?
    var weatherDescription: String?
    var weatherShortDescription: String?
    

    func fetchForecastForParis(completionHandler: @escaping (_ city: City?,_ lists: [List]?, _ error: Error?) -> Void) {
        forecastAPI.fetchForecast("https://api.openweathermap.org/data/2.5/forecast?id=6455259&appid=00f7f80aa3f203c7b7eaf6a31ea64c08", withCompletion: { (result) in
            switch result {
            case.success(let forecast):
                guard let city = forecast.city else { return }
                guard let lists = forecast.list else { return }
                completionHandler(city,lists, nil)
            case.failure(let error):
                completionHandler(nil, [], error?.localizedDescription as? Error)
            }
        })
    }
    
    func fetchForcastOnLoad(completion: @escaping (_ viewModels: [ForecastViewModel]) -> Void) {
        var viewModels: [ForecastViewModel] = []
        fetchForecastForParis(completionHandler: { (city, lists, error) in
            guard let name = city?.name,let infos = lists else { return }
            self.cityName = name
            for list in infos {
                self.weekday = list.time //= self.getDayOfTheWeek(dateString: list.time)
                self.averageTemp = self.tempToCelsius(kelvin: (list.temp?.averageTemp)!)
                self.maxTemp = self.tempToCelsius(kelvin: (list.temp?.temp_max)!)
                self.minTemp = self.tempToCelsius(kelvin: (list.temp?.temp_min)!)
                
                self.weatherDescription = self.weatherBasicInfo(main: list.weather?.first?.mainInfo, info: list.weather?.first?.info)
                self.iconURL = self.createIconURL(imagePattern: ForecastViewModel.iconImagePattern, iconId: (list.weather?.first?.icon)!)
                viewModels.append(self)
            }
            completion(viewModels)
        })
    }
    
    func tempToCelsius(kelvin: Double) -> String {
        let celsius = kelvin - 273.16
        return String(format: "%.0f°", celsius)
    }
    
    func weatherBasicInfo(main: String?, info: String?) -> String? {
        guard let main = main, let info = info else { return nil }
        return  main + ", " + info
    }
    
    func getDayOfTheWeek(dateString: String) -> String {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"    //"2017-11-22 18:00:00"
//        formatter.timeZone = TimeZone(abbreviation: "GMT+0:00") //Current time zone
        let date = formatter.date(from: dateString)
        return formatter.weekdaySymbols[Calendar.current.component(.weekday, from: date!)]

    }

    func createIconURL(imagePattern: String, iconId: String) -> URL? {
        let urlString = imagePattern.replacingOccurrences(of: "%id%", with: iconId)
        guard let iconURL = URL(string: urlString) else { return nil }
        return iconURL
    }

    func fetchForecastIcon(url:URL, completion:@escaping (_ icon: UIImage) -> Void ) {
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
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
