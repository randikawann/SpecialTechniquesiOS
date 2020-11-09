//
//  ViewController.swift
//  SpecialTechniquesiOS
//
//  Created by Randika Wanninayaka on 11/6/2563 BE.
//

// Choose this as main view controller

import UIKit

extension UserViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profile.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = usertableview.dequeueReusableCell(withIdentifier: "usertableviewcell", for: indexPath)
        cell.textLabel?.text = profile[indexPath.row].title
        return cell
    }
    
    
}

class UserViewController: UIViewController {

    @IBOutlet weak var usertableview: UITableView!
    
    var profile = [Profile]()
    let parser = Parser()
    override func viewDidLoad() {
        super.viewDidLoad()

        usertableview.delegate = self
        usertableview.dataSource = self
        parser.parse{
            data in
            self.profile = data
            
            DispatchQueue.main.async {
                self.usertableview.reloadData()
            }
        }
    }
}

