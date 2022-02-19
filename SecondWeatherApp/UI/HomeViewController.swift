//
//  HomeViewController.swift
//  SecondWeatherApp
//
//  Created by Shakhzod Bektemirov on 2022/02/19.
//

import UIKit
import SnapKit
import CoreLocation


class HomeViewController: UIViewController {
    
    let networkManager = WeatherNetworkManager()
    
    let currentLocation: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "...Location"
        label.textAlignment = .center
        label.textColor = .label
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.font = UIFont.systemFont(ofSize:30, weight: .heavy)
        return label
    }()
    
    let currentTime: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "28 March 2020"
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 15, weight: .heavy)
        return label
    }()
    
    let currentTemperatureLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "°C"
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textColor = .label
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 60, weight: .heavy)
        return label
    }()
    
    let tempDescription: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "..."
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        return label
    }()
    let tempSymbol: UIImageView = {
       let img = UIImageView()
        img.image = UIImage(systemName: "cloud.fill")
        img.contentMode = .scaleAspectFit
       
        img.translatesAutoresizingMaskIntoConstraints = false
        img.tintColor = .gray
        return img
    }()
    

    let maxTemp: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "  °C"
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    let minTemp: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "  °C"
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textAlignment = .left
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    var locationManager = CLLocationManager()
    var currentLoc: CLLocation?
    var stackView : UIStackView!
    var latitude : CLLocationDegrees!
    var longitude: CLLocationDegrees!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        navSetUpView()
        privateSetupViews()
        layoutViews()
    }
    
    
    private func navSetUpView() {
          self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "plus.circle"), style: .done, target: self, action: #selector(handleAddPlaceButton)), UIBarButtonItem(image: UIImage(systemName: "thermometer"), style: .done, target: self, action: #selector(handleShowForecast)),UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"), style: .done, target: self, action: #selector(handleRefresh))]
    }
    
    
    
 
    
    //MARK: - Functions
    @objc func handleAddPlaceButton() {
        let alertController = UIAlertController(title: "Add City", message: "", preferredStyle: .alert)
         alertController.addTextField { (textField : UITextField!) -> Void in
             textField.placeholder = "City Name"
         }
         let saveAction = UIAlertAction(title: "Add", style: .default, handler: { alert -> Void in
             let firstTextField = alertController.textFields![0] as UITextField
             print("City Name: \(String(describing: firstTextField.text))")
            guard let cityname = firstTextField.text else { return }
            self.loadData(city: cityname)
         })
         let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action : UIAlertAction!) -> Void in
            print("Cancel")
         })
      

         alertController.addAction(saveAction)
         alertController.addAction(cancelAction)

         self.present(alertController, animated: true, completion: nil)
    }

    @objc func handleShowForecast() {
        self.navigationController?.pushViewController(ForeCastViewController(), animated: true)
    }
    
    @objc func handleRefresh() {
        let city = UserDefaults.standard.string(forKey: "SelectedCity") ?? ""
        loadData(city: city)
    }
    
}


extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        manager.delegate = nil
        let location = locations[0].coordinate
        latitude = location.latitude
        longitude = location.longitude
        print("Long", longitude.description)
        print("Lat", latitude.description)
        loadDataUsingCoordinates(lat: latitude.description, lon: longitude.description)
    }
    
    
    func loadDataUsingCoordinates(lat: String, lon: String) {
        networkManager.fetchCurrentLocationWeather(lat: lat, lon: lon) { (weather) in
             print("Current Temperature", weather.main.temp.kelvinToCeliusConverter())
             let formatter = DateFormatter()
             formatter.dateFormat = "dd MMM yyyy" //yyyy
             let stringDate = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(weather.dt)))
             
             DispatchQueue.main.async {
                 self.currentTemperatureLabel.text = (String(weather.main.temp.kelvinToCeliusConverter()) + "°C")
                 self.currentLocation.text = "\(weather.name ?? "") , \(weather.sys.country ?? "")"
                 self.tempDescription.text = weather.weather[0].description
                 self.currentTime.text = stringDate
                 self.minTemp.text = ("Min: " + String(weather.main.temp_min.kelvinToCeliusConverter()) + "°C" )
                 self.maxTemp.text = ("Max: " + String(weather.main.temp_max.kelvinToCeliusConverter()) + "°C" )
                 self.tempSymbol.loadImageFromURL(url: "http://openweathermap.org/img/wn/\(weather.weather[0].icon)@2x.png")
                UserDefaults.standard.set("\(weather.name ?? "")", forKey: "SelectedCity")
             }
        }
    }
    
    
    
    func loadData(city: String) {
        networkManager.fetchCurrentWeather(city: city) { (weather) in
             print("Current Temperature", weather.main.temp.kelvinToCeliusConverter())
             let formatter = DateFormatter()
             formatter.dateFormat = "dd MMM yyyy" //yyyy
             let stringDate = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(weather.dt)))
             
             DispatchQueue.main.async {
                 self.currentTemperatureLabel.text = (String(weather.main.temp.kelvinToCeliusConverter()) + "°C")
                 self.currentLocation.text = "\(weather.name ?? "") , \(weather.sys.country ?? "")"
                 self.tempDescription.text = weather.weather[0].description
                 self.currentTime.text = stringDate
                 self.minTemp.text = ("Min: " + String(weather.main.temp_min.kelvinToCeliusConverter()) + "°C" )
                 self.maxTemp.text = ("Max: " + String(weather.main.temp_max.kelvinToCeliusConverter()) + "°C" )
                 self.tempSymbol.loadImageFromURL(url: "http://openweathermap.org/img/wn/\(weather.weather[0].icon)@2x.png")
                 UserDefaults.standard.set("\(weather.name ?? "")", forKey: "SelectedCity")
             }
         }
    }
}

    



extension HomeViewController {
    
    func privateSetupViews() {
        view.addSubview(currentLocation)
        view.addSubview(currentTemperatureLabel)
        view.addSubview(tempSymbol)
        view.addSubview(tempDescription)
        view.addSubview(currentTime)
        view.addSubview(minTemp)
        view.addSubview(maxTemp)
    }
    
    
    private func layoutViews() {
        currentLocation.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalToSuperview().multipliedBy(0.2)
        }
        
        currentTime.snp.makeConstraints { make in
            make.top.equalTo(currentLocation.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalToSuperview().multipliedBy(0.05)
        }
        
        currentTemperatureLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(40)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalToSuperview().multipliedBy(0.2)
        }
        
        
        tempDescription.snp.makeConstraints { make in
            make.top.equalTo(currentTemperatureLabel.snp.bottom).offset(4)
            make.left.equalToSuperview().offset(40)
            make.width.equalTo(50)
            make.height.equalTo(30)
        }
        
        
        tempSymbol.snp.makeConstraints { make in
            make.top.equalTo(currentTemperatureLabel.snp.bottom).offset(4)
            make.left.equalTo(tempDescription.snp.right).offset(20)
            make.width.equalTo(50)
            make.height.equalTo(30)
        }
        
        
        maxTemp.snp.makeConstraints { make in
            make.top.equalTo(tempSymbol.snp.bottom).offset(40)
            make.left.equalTo(40)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        
        minTemp.snp.makeConstraints { make in
            make.top.equalTo(maxTemp.snp.bottom).offset(10)
            make.left.equalTo(40)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
    }
}
