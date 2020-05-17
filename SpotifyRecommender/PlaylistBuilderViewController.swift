//
//  PlaylistBuilderViewController.swift
//  SpotifyRecommender
//
//  Created by 90303054 on 5/5/20.
//  Copyright © 2020 90303054. All rights reserved.
//

import UIKit

class PlaylistBuilderViewController: UITableViewController {
    var availableGenres: [String]?
    var checkedGenres: [String] = []
    var selectedAttributes = AttributeTypes.shared.getSelectedAttributes()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.cellLayoutMarginsFollowReadableWidth = true
        fetchAvailableGenres { (genres) in
            guard let genres = genres else { return }
            self.availableGenres = genres
        }
        tableView.register(SliderTableViewCell.nib(), forCellReuseIdentifier: "SliderCell")
        self.navigationItem.leftBarButtonItem = editButtonItem
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return selectedAttributes.count
        }
        return super.tableView(tableView, numberOfRowsInSection: section)
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var sectionName = ""
        if checkedGenres.count > 0 && section == 0 {
            sectionName = "Selected Genres: \(checkedGenres.joined(separator: ", "))"
        }
        return sectionName
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SliderCell", for: indexPath) as! SliderTableViewCell
            cell.configure(with: selectedAttributes[indexPath.row].name , attribute: selectedAttributes[indexPath.row])
            return cell
        }
        return super.tableView(tableView, cellForRowAt: indexPath)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1{
            return 75
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 1{
            return true
        }
        return false
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let index = AttributeTypes.shared.values.firstIndex(where: {$0.name == selectedAttributes[indexPath.row].name}) else { return }
            AttributeTypes.shared.values[index].isSelected = false
            selectedAttributes = AttributeTypes.shared.getSelectedAttributes()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        tableView.setEditing(editing, animated: true)
    }
    
    
    // MARK: - Navigation
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "genreSegue" {
            if let destination = segue.destination as? GenreTableViewController {
                destination.genres = availableGenres
                destination.checkedGenres = checkedGenres
                destination.delegate = self
            }
        }
        if segue.identifier == "attributeSegue" {
            if let destination = segue.destination.children[0] as? AttributeTableViewController {
                destination.delegate = self
            }
        }
        if segue.identifier == "createSegue" {
            if let destination = segue.destination as? RecommendationViewController {
                destination.selectedGenres = checkedGenres
            }
        }
        
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "genreSegue" {
            guard availableGenres != nil else { return false }
        }
        if identifier == "createSegue" {
            if checkedGenres.count == 0 {
                let controller = UIAlertController(title: "Error", message: "Please select at least one genre!", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                controller.addAction(action)
                self.present(controller, animated: true)
                return false
            }
        }
        return true
    }
    
    // MARK: - URL Requests
    func fetchAvailableGenres(completion: @escaping ([String]?) -> Void){
        let defaults = UserDefaults.standard
        let url = URL(string: "https://api.spotify.com/v1/recommendations/available-genre-seeds")!
        var request = URLRequest(url: url)
        request.setValue("Bearer " + defaults.string(forKey: "accesstoken")!, forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
                let genreList = try JSONDecoder().decode([String: [String]].self, from: data)
                completion(genreList["genres"]!)
                
            } catch let error {
                print(error)
                completion(nil)
            }
        }.resume()
    }
}
extension PlaylistBuilderViewController: GenreDelegate, AttributeViewDelegate {
    func addedNewAttribute() {
        self.selectedAttributes = AttributeTypes.shared.getSelectedAttributes()
        self.tableView.reloadData()
    }
    
    func saveCheckedGenres(genreList: [String]) {
        self.checkedGenres = genreList
        self.tableView.reloadData()
    }
}

