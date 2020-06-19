//
//  ViewController.swift
//  WeatherWithRealm
//
//  Created by Sergey on 6/17/20.
//  Copyright © 2020 Chsherbak Sergey. All rights reserved.
//

/* Icons were taken from https://icons8.com
 Sun icon was taken from (<a target="_blank" href="https://icons8.com/icons/set/sun-smiling">Sun Smiling icon</a> icon by <a target="_blank" href="https://icons8.com">Icons8</a>)
 Rain icon was taken from (<a target="_blank" href="https://icons8.com/icons/set/rain--v1">Rain icon</a> icon by <a target="_blank" href="https://icons8.com">Icons8</a>)
 Clouds icon was taken from (<a target="_blank" href="https://icons8.com/icons/set/clouds">Clouds icon</a> icon by <a target="_blank" href="https://icons8.com">Icons8</a>)
 Thermometr icon was taken from (<a target="_blank" href="https://icons8.com/icons/set/thermometer">Thermometer icon</a> icon by <a target="_blank" href="https://icons8.com">Icons8</a>)
*/
import UIKit
import Realm
import RealmSwift

class ViewController: UIViewController {
    
    //Creating IBOutlets
    @IBOutlet weak var cityNameLabel: UILabel!
    
    @IBOutlet weak var tempLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var rainLabel: UILabel!
    
    @IBOutlet weak var humidityLabel: UILabel!
    
    @IBOutlet weak var weatherImageView: UIImageView!
    
    //Creating images
    let sunImage = UIImage(named: "SunnyDay")
    let rainImage = UIImage(named: "Rain")
    let cloudsImage = UIImage(named: "Clouds")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Show the last saved data before it will be renewed
        if let weather = getSaved() {
            cityNameLabel.text = weather.name
            let newTemp = Int(weather.main!.temp)
            tempLabel.text = "\(newTemp)" + " °C"
            rainLabel.text = "Clouds: " + "\(String(describing: weather.clouds!.all))" + " %"
            humidityLabel.text = "Humidity: " + "\(String(describing: weather.main!.humidity))" + " %"
            descriptionLabel.text = weather.weather[0].weatherDescription.capitalizingFirstLetter()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        findTheWeather()
        delegate = self
        //Check weather description and show the right picture for it.
        if descriptionLabel.text == "Дождь" || descriptionLabel.text == "Гроза с дождем" || descriptionLabel.text == "Гроза с небольшим дождем" || descriptionLabel.text == "Небольшой дождь" || descriptionLabel.text == "Проливной дождь" {
            weatherImageView.image = rainImage
        } else if descriptionLabel.text == "Переменная облачность" {
            weatherImageView.image = cloudsImage
        } else {
            weatherImageView.image = sunImage
        }
    }
}

extension ViewController: WeatherDelegate{
    func givingDataBack() {
        //Show weather data at the moment
        cityNameLabel.text = cityName
        let newTemperature = Int(temperature!)
        tempLabel.text = String(newTemperature) + " °C"
        rainLabel.text = "Clouds: " + String(rain!) + " %"
        humidityLabel.text = "Humidity: " + String(humidity!) + " %"
        descriptionLabel.text = descript?.capitalizingFirstLetter()
    }
    
}

//Do extension for string to be able to capitalize first letter
extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
