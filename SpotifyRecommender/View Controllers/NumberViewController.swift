//
//  NumberViewController.swift
//  SpotifyRecommender
//
//  Created by 90303054 on 5/17/20.
//  Copyright © 2020 90303054. All rights reserved.
//

import UIKit

protocol NumberDelegate {
    func savedNumber(num: Int)
}
class NumberViewController: UITableViewController {
    var delegate: NumberDelegate?
    var selectedNumber: Int?
    let songNumberOptions: [Int] = [5, 10, 20, 30, 40, 50]
    override func viewDidLoad() {
        self.tableView.cellLayoutMarginsFollowReadableWidth = true
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songNumberOptions.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(songNumberOptions[indexPath.row])"
        if songNumberOptions[indexPath.row] == selectedNumber {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedNumber = songNumberOptions[indexPath.row]
        delegate?.savedNumber(num: songNumberOptions[indexPath.row])
        tableView.reloadData()
    }
    

}
