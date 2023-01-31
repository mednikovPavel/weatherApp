//
//  ViewController.swift
//  weatherApp
//
//  Created by Pavel Mednikov on 27/12/2022.
//

import UIKit
import CoreLocation
import CoreData

class ViewController: UIViewController {
    
 
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var items = [City]()
    
    
    
    var weatherManager = WeatherManager()
    var locationManager = CLLocationManager()
    
    
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 120, height: 150)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identefier)
        cv.backgroundColor = .clear
    
        return cv
        
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.frame = CGRect(x: 0, y: 540, width: view.bounds.width, height: 200)
       
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        locationManager.startUpdatingHeading()
        
        myTextField.delegate = self
        
        weatherManager.delegate = self
        
       
        
        view.addSubview(temperatureLabel)
        view.addSubview(cityLabel)
        view.addSubview(myTextField)
        view.addSubview(weatherImage)
        view.addSubview(button)
        view.addSubview(collectionView)

        configureConstreints()
        
        addButtonTarget()
       
        view.backgroundColor = UIColor(patternImage: UIImage(named: "blue")!)

        loadItems()
    }

    
    let temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "- C"
        label.font = .systemFont(ofSize: 100, weight: .ultraLight)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
        
    }()
    
    
    let cityLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.font = .systemFont(ofSize: 40, weight: .ultraLight)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
        
    }()
    
    
    let myTextField: UITextField = {
        let textField = UITextField()
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.placeholder = "put the city"
        textField.textColor = .black
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    
    let weatherImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "cloud")
        image.tintColor = .white
        image.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 80, weight: .ultraLight)
        image.preferredSymbolConfiguration = config
        
        return image
    }()
    
    let button: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .light)
        let boldDoc = UIImage(systemName: "plus", withConfiguration: config)
        button.setImage(boldDoc, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    
    func addButtonTarget(){
        button.addTarget(self, action: #selector(alertAction), for: .touchUpInside)
    }
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    
    
    
    @objc func alertAction(){
       
       
        var textField = UITextField()
       
        let alert = UIAlertController(title: "Add new city", message: "", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        let action = UIAlertAction(title: "Save", style: .default) { action in
            
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let newItem = City(context: context)
            newItem.cityName = textField.text!.capitalized
            let myIndexPath = IndexPath(item: self.items.count - 1, section: 0)

            self.collectionView.insertItems(at: [myIndexPath])
            
            self.items.append(newItem)
            
            self.saveItems()

       }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "put city"
            alertTextField.autocorrectionType = .no
            alertTextField.spellCheckingType = .no
            textField = alertTextField
            
           
        }
 
            alert.addAction(action)
        alert.addAction(cancelAction)
            present(alert, animated: true)
    }
    
    
    func saveItems(){
        do{
           try context.save()
        } catch{
            print(error)
        }
        self.collectionView.reloadData()
    }
    
    func loadItems(){
        let request: NSFetchRequest<City> = City.fetchRequest()
        do{
          items = try context.fetch(request)
        }catch{
            print("error loading items\(error)")
        }
    }
    


    
    
    func configureConstreints(){
        
        let temperatureLabelConstreints = [
        temperatureLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        temperatureLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 250)
        ]
        
        let cityLabelConstreints = [
            cityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cityLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 200)
        
        ]
        
        let myTextFieldConstreints = [
        
            myTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            myTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            myTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            myTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            myTextField.heightAnchor.constraint(equalToConstant: 30)
        ]
        
        let imageViewConstreints = [
        
            weatherImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            weatherImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 370)
        
        ]
        
        let buttonConstr = [
            button.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15),
            button.topAnchor.constraint(equalTo: view.topAnchor, constant: 60)
        
        ]
        
        NSLayoutConstraint.activate(temperatureLabelConstreints)
        NSLayoutConstraint.activate(cityLabelConstreints)
        NSLayoutConstraint.activate(myTextFieldConstreints)
        NSLayoutConstraint.activate(imageViewConstreints)
        NSLayoutConstraint.activate(buttonConstr)

  
    }
 
}


extension ViewController: UITextFieldDelegate {
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        myTextField.resignFirstResponder()

        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if myTextField.text != ""{
            return true
        } else{
            textField.placeholder = "Type something"

            return true
        }
    }
    
    
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {

        if let city = myTextField.text{
            weatherManager.featchWeather(cityName: city)
        }
        myTextField.text = ""
    }
}




extension ViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(weatherManager: WeatherManager, weatherModel: WeatherModel) {
        DispatchQueue.main.async {
            
            self.temperatureLabel.text = String(weatherModel.temperature) + "°"
            self.cityLabel.text = weatherModel.cityName
            self.weatherImage.image = UIImage(systemName: weatherModel.conditionName)
            
            }
        }
    }



extension ViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
            
        if let location = locations.last{
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            self.weatherManager.featchWeather( lat: lat, lon: lon)

           
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
       
    }
}


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
        
    }
    
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identefier, for: indexPath) as? CollectionViewCell else{
            return UICollectionViewCell()
        }
        cell.backgroundColor = .systemBackground.withAlphaComponent(0.06)
        cell.configure(city: items[indexPath.row].cityName!)


        
  
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ in
            let deleteAction = UIAction(title: "deleate", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) {  _ in
                self?.context.delete((self?.items[indexPath.row])!)
                self?.items.remove(at: indexPath.row)
                self?.saveItems()
              
            }
            return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [deleteAction])
        }
        return configuration
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let fName = items[indexPath.row].cityName{
            weatherManager.featchWeather(cityName: fName)
        }
    }
}












