# SpecialTechniquesiOS

Basic Concepts of iOS developement included in this repo. 

Every branches have individual code snippet in branch Readme.md file  
  
# MVVM Lesson 1
### Go to branch and studying.....

I think that you had some idea about the MVVM patten.. I will provide another tutorail about this topic. If you had questions related to this please drop a mail to randikawann@gmail.com

### Thank you.


## master
  meged from 02mvvm
  
## 01codable branch
  added codable struct to the URLSession fetch data. it is very easy to handle json response
  
 
## 02mvvm branch
  MVVM is the concept of design paten. It basically has Model, View, View Model architecture.
  
  
# Save Any Codable objects in Local Storage
It is helpfull to save fetching json data in local memory

DataManager.swift

```
import Foundation

public class DataManager{
    
    //get document directly
    static fileprivate func getDocumentDirectly() -> URL{
        
        if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            return url
        }
        else{
            fatalError("unable to access document directry")
        }
        
    }
    
    // save any kind of data
    static func save <T:Encodable> ( object:T, with fileName: String){
        let url = getDocumentDirectly().appendingPathComponent(fileName)
        
        let encoder = JSONEncoder()
        do{
            let data = try encoder.encode(object)
            
            if FileManager.default.fileExists(atPath: url.path) {
                try FileManager.default.removeItem(at: url)
            }
            print("item save in localy sucessfully daa is \(data)")
            FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
        }catch {
            fatalError(error.localizedDescription)
        }
    }
    
    // Load any kind of data
    static func load <T: Decodable> ( fileName: String, with type:T.Type) -> T {
        let url = getDocumentDirectly().appendingPathComponent(fileName)
        
        if !FileManager.default.fileExists(atPath: url.path) {
            fatalError("Url not found as path \(url.path)")
        }
        
        if let data = FileManager.default.contents(atPath: url.path){
            do{
                let model = try JSONDecoder().decode(type, from: data)
                print("load item from localy successfully.. model is \(model)")
                return model
            }catch{
                fatalError(error.localizedDescription)
            }
        }else{
            fatalError("Data unavailable \(url.path)")
        }
        
    }
    
    //Load data from  a file
    
    //Load all files of the directly
    
    //delete the file
}

```
use RestaurantViewModel.swift for save objects and load objects

```
//
//  RestaurantViewModel.swift
//  USRestaurantMenus
//
//  Created by Randika Wanninayaka on 11/26/2020 .
//

import Foundation


var apiHandler = APIHandler()
var totalRestaurant = [Restaurant]()

var totalRestaurant2 = [Restaurant]()

typealias completionBlock = ([Restaurant]) -> ()

class RestaurantViewModel {
    
    func getdatafromApIHandler(withurl: String, completionBlock: @escaping completionBlock){
        
        apiHandler.getDataFromApi(url: withurl, completionBlock: { [weak self] (arrProfile) in
            totalRestaurant = arrProfile
            completionBlock(arrProfile)
        })
        
    }
    
    //thos down functions for local storage
    func saveItemLocal(){
        print("item save in localy")
        DataManager.save(object: totalRestaurant, with: "RestaurantDetails")
    }
    
    func deleteItemLocal(){
//        DataManager.delete("RestaurantDetails")
    }
    
    
    func loadItemLocal(){
        print("load item from localy")
        totalRestaurant2 = DataManager.load(fileName: "RestaurantDetails", with: [Restaurant].self)
        
        print("load item from localy complete value \(totalRestaurant2[0].restaurant_name)")
    }
    
    func markAsComplete(){
//        self.completed = true
//        DataManager.save(object: restaurantresults, with: "RestaurantDetails")
    }
}

```
## Extra topic those for more clearance
APIHandler.swft to fetch data
```
//
//  APIHandler.swift
//  USRestaurantMenus
//
//  Created by Randika Wanninayaka on 11/26/2020 .
//

import Foundation

class APIHandler {
 
    typealias completionBlock = ([Restaurant]) -> ()
    
    func getDataFromApi(url url2: String, completionBlock : @escaping completionBlock){
        guard let url = URL(string: url2) else {return}
        
        //there is no header file
//        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        
        // for the header value
        var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("your_api_key_in_x-rapidapi-key", forHTTPHeaderField: "x-rapidapi-key")
            request.setValue("your_host_in_x-rapidapi-host", forHTTPHeaderField: "x-rapidapi-host")
        
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let _ = data,
                  error == nil else {
                  print(error?.localizedDescription ?? "Response Error")
                  return }
            do{
                let results = try JSONDecoder().decode(Result.self, from: data!)
                
                
//                print("results in url session \(results.result)")
                
                //pass value to view model
                completionBlock(results.result?.data ?? [Restaurant]())
                
                
             } catch let parsingError {
                let nilarray = [Restaurant]()
                completionBlock(nilarray)
                print("Error", parsingError)
           }
            
        }
        task.resume()
    }
}

```
RestaurantViewController.swift file some code

```
   
    
    
    func getDataFromAPI(){
        //viewmodelacceess
        restaurantviewmodel.getdatafromApIHandler(withurl: EndPoint.strUrl){_ in
            
            DispatchQueue.main.async { [weak self] in
                print("complete the request")
                self?.restaurantviewmodel.saveItemLocal()
            }
        }
    }
    
    func getDataFromLocal(){
        restaurantviewmodel.loadItemLocal()
    }

```

Restaurant.swift class with codable

```
import Foundation


struct Result: Codable {
    var result: TotalResults?
}

struct TotalResults: Codable{
    var totalresult: Int?
    var data: [Restaurant]?
    var numResults: Int?
    

    
}
struct Restaurant: Codable {
    var geo: Geo?
    var hours: String?
    var address: Address?
    var restaurant_phone: String?
    var restaurant_id: Double?
    var price_range: String?
//    var cuisines:
    var restaurant_name: String?
}

struct Address: Codable {
    var city: String?
    var formatted: String?
    var street: String?
    var state:String?
    var postal_code: String?
}
struct Geo: Codable {
    var lon: Double?
    var lat: Double?
}

```
