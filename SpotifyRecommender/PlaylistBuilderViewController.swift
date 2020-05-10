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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.cellLayoutMarginsFollowReadableWidth = true
        fetchAvailableGenres { (genres) in
        guard let genres = genres else { return }
        self.availableGenres = genres
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 || section == 1{
            return 1
        } else {
            return 0
        }
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    
    // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "genreSegue" {
            if let destination = segue.destination as? GenreTableViewController {
                destination.genres = availableGenres
            }
        }
        
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "genreSegue" {
            guard availableGenres != nil else { return false }
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
