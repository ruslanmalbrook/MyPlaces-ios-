//
//  ViewController.swift
//  MyPlaces
//
//  Created by Ruslan Malbrook on 08.06.2021.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let rowHeight: CGFloat = 85
    
    let restaurantNames = [
        "Burger Heroes", "Kitchen", "Bonsai", "Дастархан",
        "Индокитай", "X.O", "Балкан Гриль", "Sherlock Holmes",
        "Speak Easy", "Morris Pub", "Вкусные истории",
        "Классик", "Love&Life", "Шок", "Бочка"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cell") as! CustomTableViewCell
        
        cell.nameLabel.text = restaurantNames[indexPath.row]
        cell.imageOfCell.image = UIImage(named: restaurantNames[indexPath.row])
        cell.imageOfCell.layer.cornerRadius = cell.imageOfCell.frame.size.height / 2
        cell.imageOfCell.clipsToBounds = true
        
        return cell
    }
    
    //MARK: - Table View Delegate

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
}

