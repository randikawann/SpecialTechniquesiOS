//
//  Codable1ViewController.swift
//  SpecialTechniquesiOS
//
//  Created by Randika Wanninayaka on 11/6/2563 BE.
//

//Advanced JSON response retrieving with Codables

/**
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
       "id": 2,
       "title": "Optional intermediate orchestration",
       "description": "Quia unde officiis ut eum quibusdam. Nihil modi omnis aperiam vitae suscipit. Esse ex voluptatem ratione officiis voluptatem adipisci doloremque. Saepe similique libero et dolor corporis rerum. Ut deleniti provident sed praesentium sit voluptas soluta.",
       "address": "719 Darrick Plains Suite 428\nNorth Christineshire, ID 91341",
       "postcode": "06445-4404",
       "phoneNumber": "103-350-9440x83127",
       "latitude": "-84.165738",
       "longitude": "62.221246",
       "image": {
         "small": "http://lorempixel.com/200/200/cats/2/",
         "medium": "http://lorempixel.com/400/400/cats/2/",
         "large": "http://lorempixel.com/800/800/cats/2/"
       }
     },
 }
 */


import UIKit

struct WholeResponse: Codable {
    var status: Int?
    var data: [Profile]
}
struct Profile: Codable{
    var id: Int? = 0
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

class Codable1ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        print("Codable1ViewController")
        // Do any additional setup after loading the view.
        
        loadData()
    }
    

    private func loadData(){
        
        //URL session based fetch data
        guard let url = URL(string: "https://dl.dropboxusercontent.com/s/6nt7fkdt7ck0lue/hotels.json") else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//        guard let dataResponse = data,
//                  error == nil else {
//                  print(error?.localizedDescription ?? "Response Error")
//                  return }
            do{
                let wholeResponce = try JSONDecoder().decode(WholeResponse.self, from: data!)
                print(wholeResponce)
                print(wholeResponce.data[1].latitude ?? "")
            }catch let parsingError {
                print("Error seriolizing json: ", parsingError)
            }
        }
        task.resume()
    }

}
