//
//  AttributeTableViewController.swift
//  SpotifyRecommender
//
//  Created by 90303054 on 5/13/20.
//  Copyright © 2020 90303054. All rights reserved.
//

import UIKit
protocol AttributeViewDelegate {
    func addedNewAttribute()
}
class AttributeTableViewController: UITableViewController {
    var unselectedAttributes: [Attribute] = AttributeTypes.shared.getUnselectedAttributes()
    var delegate: AttributeViewDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        unselectedAttributes = AttributeTypes.shared.getUnselectedAttributes()
        tableView.reloadData()
    }
    
    @IBAction func handleCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return unselectedAttributes.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = unselectedAttributes[indexPath.row].name.capitalizingFirstLetter()
        cell.detailTextLabel?.text = unselectedAttributes[indexPath.row].description
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let index = AttributeTypes.shared.values.firstIndex(where: {$0.name == unselectedAttributes[indexPath.row].name}) else { return }
        AttributeTypes.shared.values[index].isSelected = true
        delegate?.addedNewAttribute()
        self.dismiss(animated: true, completion: nil)
    }
    
}
