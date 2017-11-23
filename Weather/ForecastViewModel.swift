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
    var daytime: String = ""
    var averageTemp: String = ""
    var maxTemp: String = ""
    var minTemp: String = ""
    var iconURL: URL?
    var weatherDescription: String?
    
    convenience init(cityName: String, weekday:String, daytime:String, averageTemp: String, maxTemp: String, minTemp: String, iconURL: URL?, weatherDescription: String? ) {
        self.init()
        self.cityName = cityName
        self.weekday = weekday
        self.daytime = daytime
        self.maxTemp = maxTemp
        self.minTemp = minTemp
        self.iconURL = iconURL
        self.averageTemp = averageTemp
        self.weatherDescription = weatherDescription
    }

    func fetchForecastForParis(completionHandler: @escaping (_ viewModels: [ForecastViewModel], _ error: Error?) -> Void) {
        var viewModels: [ForecastViewModel] = []
        forecastAPI.fetchForecast("https://api.openweathermap.org/data/2.5/forecast?id=6455259&appid=00f7f80aa3f203c7b7eaf6a31ea64c08", withCompletion: { (result) in
            switch result {
            case.success(let forecast):
                guard let name = forecast.city?.name, let lists = forecast.list else { return }
                for list in lists {
                    guard let average = list.temp?.averageTemp, let max = list.temp?.temp_max, let min = list.temp?.temp_min, let icon = list.weather?.first?.icon else { return }

                    let weekday = self.weekdayFormat(dateString: list.time)
                    let daytime = self.dayTimeFormat(dateString: list.time)
                    let averageTemp = self.tempToCelsius(kelvin: average)
                    let maxTemp = self.tempToCelsius(kelvin: max)
                    let minTemp = self.tempToCelsius(kelvin: min)
                    let weatherDescription = self.weatherBasicInfo(main: list.weather?.first?.mainInfo, info: list.weather?.first?.info)
                    let iconURL = self.createIconURL(imagePattern: ForecastViewModel.iconImagePattern, iconId: icon)
                    
                    let viewModel = ForecastViewModel(cityName: name, weekday: weekday, daytime:daytime, averageTemp: averageTemp, maxTemp: maxTemp, minTemp: minTemp, iconURL: iconURL, weatherDescription: weatherDescription)
                    viewModels.append(viewModel)
                }
                completionHandler(viewModels, nil)
            case.failure(let error):
                completionHandler([], error?.localizedDescription as? Error)
            }
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
    
    func weekdayFormat(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        let string = dateString.prefix(10)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var dayInWeek = ""
        if let todayDate = dateFormatter.date(from: String(string)){
            let secondDateFormatter = DateFormatter()
            secondDateFormatter.dateFormat  = "EEEE"//"EE" to get weekday style
            dayInWeek = secondDateFormatter.string(from: todayDate)
        }
        return dayInWeek
    }
    
    func dayTimeFormat(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var dayAndTime = ""
        if let date = dateFormatter.date(from: dateString) {
            let amFormatter = DateFormatter()
            amFormatter.dateFormat  = "MMM d, h a"
            dayAndTime = amFormatter.string(from: date)
        }
        return dayAndTime
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
