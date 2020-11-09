//
//  Parser.swift
//  SpecialTechniquesiOS
//
//  Created by Randika Wanninayaka on 11/9/2563 BE.
//

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
    
/* 1st step
    func parse(){
        guard let url = URL(string: "https://dl.dropboxusercontent.com/s/6nt7fkdt7ck0lue/hotels.json") else {return}
        URLSession.shared.dataTask(with: url) {
            data, response, error in
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            do{
                let results = try JSONDecoder().decode(WholeResponse.self, from: data!)
                print(results)
            }catch{
                print("json decoder has error")
            }
            
        }.resume()
        
    }
*/
}
