#  MVVM Lesson 1
MVVM define Model, View, View Model. This architecture basically help to maintain code base in properway. Here This section i am discuss about how you can use MVVM patten in iOS develpment. This application used web API with Codable model, URLSession and JSONdecoder used.

Fistly move on to the Constent.swift file. Whole constant include in this.
```
struct EndPoint{
    static let strUrl = "https://dl.dropboxusercontent.com/s/6nt7fkdt7ck0lue/hotels.json"
}
```
Next, The response of particular url shows in below 

```
{
  "status": 200,
  "data": [
    {
      "id": 1,
      "title": "Down-sized 4thgeneration leverage",
      "description": "Distinctio voluptas ea aliquid consequatur. Rerum cupiditate earum repudiandae non quis a. Rem omnis iste et est repellat sapiente. Dolorum temporibus eos perspiciatis quo laborum unde soluta.",
      "address": "2755 Raul Estate\nWest Ervin, AZ 14265-2763",
      "postcode": "42503-7193",
      "phoneNumber": "387-842-0455x71431",
      "latitude": "-60.964344",
      "longitude": "-12.024244",
      "image": {
        "small": "http://lorempixel.com/200/200/cats/1/",
        "medium": "http://lorempixel.com/400/400/cats/1/",
        "large": "http://lorempixel.com/800/800/cats/1/"
      }
    },
    {
      "id": 2, .....
```
According to the json respose, I built codable model class. Profile.swift

```
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
Next it should added API Handler for handle all the response in swift. APIHandler.swift

```
class APIHandler {
 
    typealias completionBlock = ([Profile]) -> ()
    
    func getDataFromApi(url url2: String, completionBlock : @escaping completionBlock){
        guard let url = URL(string: url2) else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let _ = data,
                  error == nil else {
                  print(error?.localizedDescription ?? "Response Error")
                  return }
            do{
                let results = try JSONDecoder().decode(WholeResponse.self, from: data!)
                
                //pass value to view model
                completionBlock(results.data)
                
                
             } catch let parsingError {
                let nilarray = [Profile]()
                completionBlock(nilarray)
                print("Error", parsingError)
           }
            
        }
        task.resume()
    }
}

```
THis is another API handler with header file access. it is from another project. It added to study about header file conscept
..........................................................
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
            request.setValue("6ed-incorrect value", forHTTPHeaderField: "x-rapidapi-key")
            request.setValue("us-restaurant-incorrect value", forHTTPHeaderField: "x-rapidapi-host")
        
        
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
.........................................

describe of above code snipt: This process is basically in parallel processing.. mean of that is process going on background. Not in main thread. That is why it need to completionBlock when process is completed it should response. @escaping annotation  must need to show that must escape after process complete.

View model use to added all buisness process from the View controller class. That is why it should handle all buisness logic and show in the view controller. My view model of this project is ListViewViewModel.swift
```
class ListViewViewModel {
    
    var apiHandler = APIHandler()
    var wholeresults : [Profile]?
    
    typealias completionBlock = ([Profile]) -> ()
    
    
    func getdatafromApIHandler(withurl: String, completionBlock: @escaping completionBlock){
        
        apiHandler.getDataFromApi(url: withurl, completionBlock: { [weak self] (arrProfile) in
            self?.wholeresults = arrProfile
            completionBlock(arrProfile)
        })
        
    }
    
    func getnumberOfRowsInSection() -> Int{
        
        return wholeresults?.count ?? 0
    }
    
    func getUserAtIndex(index: Int) -> Profile {
        
        return wholeresults?[index] ?? Profile()
    }
}

```
This view model basically bind with view controller. It use listviewviewcontroller.swift it is table load page.. Here some code snipt in that:
1. cell identifier and object which created from view model.

```
var cellidentifier = "listviewidentifier"
    
var listviewviewmodel = ListViewViewModel()
    
```
2. call viewmodel from viewcontroller
```
override func viewDidLoad() {
        super.viewDidLoad()

//viewmodelacceess
        listviewviewmodel.getdatafromApIHandler(withurl: EndPoint.strUrl){_ in
            
            DispatchQueue.main.async { [weak self] in
                self?.listTableVIew.reloadData()
            }
        }
        //set table view to view
        self.listTableVIew.dataSource = self
        self.listTableVIew.delegate = self
        
}
```
3.  override functions from UITableViewDataSource, UITableViewDelegate 

```
extension ListViewViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        
        return listviewviewmodel.getnumberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //get make row
        guard let cell = listTableVIew.dequeueReusableCell(withIdentifier: cellidentifier) as? ListViewTableViewCell else {
            return ListViewTableViewCell()
        }
        
//        cell.listViewImage.image =
        cell.listViewTitle.text = listviewviewmodel.getUserAtIndex(index: indexPath.row).title
        cell.listViewAddress.text = listviewviewmodel.getUserAtIndex(index: indexPath.row).address
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailsViewController = storyboard?.instantiateViewController(withIdentifier: "detailsViewController") as! DetailsViewController
        
        detailsViewController.detailslargeimg = listviewviewmodel.getUserAtIndex(index: indexPath.row).image?.large
        detailsViewController.fullprofile = listviewviewmodel.getUserAtIndex(index: indexPath.row)
        
        self.navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
    
}

```

I think that you had some idea about the MVVM patten.. I will provide another tutorail about this topic. If you had questions related to this please drop a mail to randikawann@gmail.com

### Thank you.
