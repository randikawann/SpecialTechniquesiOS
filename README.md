


# SpecialTechniquesiOS

Basic Concepts of iOS developement included in this repo.

## master
  meged from 02mvvm
  
## 01codable
  added codable struct to the URLSession fetch data. it is very easy to handle json response
  
  Model class code - Profile.swift
  ```
import Foundation

struct WholeResponse: Codable {
    var status: Int?
    var data: [Profile]
}
struct Profile: Codable{
    var id: Int?
    var title: String?
    var description: String?
    var address: String?
    var postcode:String?
    var phoneNumber: String?
    var latitude: String?
    var longitude: String?
    var image: Images?
}

struct Images: Codable {
    var small: String?
    var medium: String?
    var large: String?
}

```
Parser.swift class

```
import Foundation

struct Parser {
    
    func parse(comp: @escaping ([Profile])->()){
        guard let url = URL(string: "https://dl.dropboxusercontent.com/s/6nt7fkdt7ck0lue/hotels.json") else {return}
        URLSession.shared.dataTask(with: url) {
            data, response, error in
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            do{
                let results = try JSONDecoder().decode(WholeResponse.self, from: data!)
//                print(results)
                comp(results.data)
            }catch{
                print("json decoder has error")
            }
            
        }.resume()
        
    }
```
 
## 02mvvm
  Model, View, View Model architecture. 
  <img src = "branchscreenshot/02mvvm1.png"  height="300" />  <img src = "branchscreenshot/02mvvm2.png"  height="300" />
  <img src = "branchscreenshot/02mvvm3.png"  height="300" />  <img src = "branchscreenshot/02mvvm4.png"  height="300" />
  <img src = "branchscreenshot/02mvvm5.png"  height="300" />




