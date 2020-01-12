//
//  PlaceDetailsViewController.swift
//  PlaceItSheHacks
//
//  Place It on 2020-01-11.
//  Copyright © 2020 Place It. All rights reserved.
//

import UIKit

class PlaceDetailsViewController: UIViewController {
    
    
    @IBOutlet weak var lblPlaceName: UILabel!
    @IBOutlet weak var lblPlaceRating: UILabel!
    @IBOutlet weak var lblPlacePhoneNumber: UILabel!


    var place = ""
    var website = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(place)
        
        let trimmed = place.replacingOccurrences(of: " ", with: "")
        //let noNewline = trimmed.replacingOccurrences(of: "\n", with: "")
        print(trimmed)
        
        load(placeName: trimmed)
        
    }
    
    func load(placeName: String){
        
        print(placeName)
        
     
        
        let url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input="+placeName+"&inputtype=textquery&fields=place_id,geometry&key=AIzaSyAcqikzGwsFMQtRitbbbWcjc-QrRXKSQFU"
        guard let placeURL = URL(string: url)else{
            return
        }
        
        print(placeURL)
        
        let dataTask = URLSession.shared.dataTask(with: placeURL){
            (data: Data?, response: URLResponse?, error: Error?) in
            
            if let error = error{
                print("Error: \n\(error)")
            }else{
                    if let jsonData = data{
                        
                        if let jsonObj = try?JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? NSDictionary{
                            
                            if let candidate = jsonObj.value(forKey: "candidates") as? NSArray {

                                for obj in candidate {
                                    
                                    if let dict = obj as? NSDictionary {
                                        
                                        if let place_id = dict.value(forKey: "place_id") as? String {
                                            
                                            print(place_id)
                                            
                                            self.getDetails(placeDetails: place_id)
                                            

                                        }
                                    }
                                }
                            }
                        }
                    }else{
                        print("Unable to get JSON data")
                    }
                }
            }
        dataTask.resume()
    }
    
    func getDetails(placeDetails: String){
        
        print(placeDetails)
        
        guard let spaceURL = URL(string: "https://maps.googleapis.com/maps/api/place/details/json?place_id="+placeDetails+"&fields=name,rating,formatted_phone_number,website&key=AIzaSyAcqikzGwsFMQtRitbbbWcjc-QrRXKSQFU")else{
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: spaceURL){
            (data: Data?, response: URLResponse?, error: Error?) in
            
            if let error = error{
                print("Error: \n\(error)")
            }else{

                    if let jsonData = data{
                        
                        if let jsonObj = try?JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? NSDictionary{
                            
                            if let result = jsonObj.value(forKey: "result") as? NSDictionary {
                                
                                print("Here")
                   
                                DispatchQueue.main.async {
                                    
                                    if let name = result.value(forKey: "name") as? String {
                                                                     
                                        self.lblPlaceName.text = name

                                    }
                                    
                                    if let rating = result.value(forKey: "rating") as?  Double {
                                        
                                        let ratingFormat = Int(rating)
                                        
                                        self.lblPlaceRating.text = String(ratingFormat)
                                        

                                    }
                                    
                                    if let formatted_phone_number = result.value(forKey: "formatted_phone_number") as? String {
                                                                     
                                        self.lblPlacePhoneNumber.text = formatted_phone_number

                                    }
                                    
                                    if let website = result.value(forKey: "website") as? String {
                                                                     
                                     
                                        self.website = website

                                    }
                                    
                                    
                                }
                                
                                
                                
                            }
                        }
                    }else{
                        print("Unable to get JSON data")
                    }
                }
            }
        dataTask.resume()
    }
    
    
    @IBAction func goToWebsite(_ sender: Any) {
        
        print(website)
        
        
        let url = URL(string: website)!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            //If you want handle the completion block than
            UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                 print("Open url : \(success)")
            })
        }
        
    }
    

}
