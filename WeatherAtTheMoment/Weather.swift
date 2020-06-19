//
//  Weather.swift
//  WeatherWithRealm
//
//  Created by Sergey on 6/17/20.
//  Copyright © 2020 Chsherbak Sergey. All rights reserved.
//

import Foundation
import Realm
import RealmSwift


//Creating protocol to give data back to the ViewController after parsing JSON
protocol WeatherDelegate {
    func givingDataBack()
}

// MARK: - Creating model of JSON and then rewrite it so it could work with Realm

// - Welcome
class Welcome: Object, Decodable {
    var weather = List<Weather>()
    @objc dynamic var main: Main? = Main()
    @objc dynamic var clouds: Clouds? = Clouds()
    @objc dynamic var name = ""
    
    private enum CodingKeys: String, CodingKey {
        case weatherList = "weather"
        case main
        case clouds
        case name
    }
    
    public required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.clouds = try container.decode(Clouds.self, forKey: .clouds)
        self.main = try container.decode(Main.self, forKey: .main)
        let weathers = try container.decodeIfPresent([Weather].self, forKey: .weatherList) ?? [Weather]()
        weather.append(objectsIn: weathers)
    }
}

// - Clouds
class Clouds: Object, Decodable {
    @objc dynamic var all = 0
}

// - Main
class Main: Object, Decodable {
    @objc dynamic var temp = 0.0
    @objc dynamic var humidity = 0

    enum CodingKeys: String, CodingKey {
        case temp
        case humidity
    }
}

// - Weather
class Weather: Object, Decodable {
    @objc dynamic var weatherDescription = ""

    enum CodingKeys: String, CodingKey {
        case weatherDescription = "description"
    }
}

// MARK: - Parse JSON and give the value that will be handled by labels in ViewController

//Creating delegate and realm properties
var delegate: WeatherDelegate?
let realm = try! Realm()

//Variables that take data from JSON
var cityName: String?
var temperature: Double?
var rain: Int?
var humidity: Int?
var descript: String?

//Creating method to show last saved data
func getSaved() -> Welcome? {
    return realm.objects(Welcome.self).last
}

//Parsing JSON and save it into realm
func findTheWeather() {
let urlString = "https://api.openweathermap.org/data/2.5/weather?q=Moscow&units=metric&lang=ru&appid=bb5870c97a4ad3c98de1d6db5599b3b1"
let url = URL(string: urlString)!
URLSession.shared.dataTask(with: url) { (data, responce, error) in
    guard let data = data else {return}
    DispatchQueue.main.async {
        do {
            try realm.write{
            let weather = try JSONDecoder().decode(Welcome.self, from: data)
                    cityName = weather.name
                    temperature = weather.main?.temp
                    rain = weather.clouds?.all
                    humidity = weather.main?.humidity
                    descript = weather.weather[0].weatherDescription
                    delegate?.givingDataBack()
                let userModel = Welcome(value: weather)
                realm.add(userModel)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
  }.resume()
}

