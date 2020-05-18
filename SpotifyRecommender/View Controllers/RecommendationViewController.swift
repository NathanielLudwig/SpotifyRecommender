//
//  RecommendationViewController.swift
//  SpotifyRecommender
//
//  Created by 90303054 on 5/17/20.
//  Copyright © 2020 90303054. All rights reserved.
//

import UIKit

class RecommendationViewController: UITableViewController {
    
    var selectedGenres: [String] = []
    var tracks: [Track] = []
    var numberOfSongs = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.cellLayoutMarginsFollowReadableWidth = true
        fetchRecommendations(with: selectedGenres, attributes: AttributeTypes.shared.getSelectedAttributes()) { (recommendations) in
            guard let recommendations = recommendations else { return }
            self.updateUI(with: recommendations)
        }
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    func updateUI(with results: Recommendations) {
        DispatchQueue.main.async {
            self.tracks = results.tracks
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TrackTableViewCell
        if tracks[indexPath.row].album.images.count > 0 {
        fetchAlbumArt(with: tracks[indexPath.row].album.images[1].url) { (image) in
            guard let image = image else { return }
            DispatchQueue.main.async {
                cell.configure(with: self.tracks[indexPath.row], image: image)
            }
        }
        } else {
            cell.configure(with: self.tracks[indexPath.row], image: #imageLiteral(resourceName: "placeholderart"))
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 69
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Network Requests
    
    func fetchRecommendations(with genres: [String], attributes: [Attribute], completion: @escaping (Recommendations?) -> Void) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.spotify.com"
        components.path = "/v1/recommendations"
        let joinedGenres = selectedGenres.joined(separator: ",")
        components.queryItems = [URLQueryItem(name: "limit", value: "\(numberOfSongs)"), URLQueryItem(name: "seed_genres", value: joinedGenres)]
        for attribute in attributes {
            if attribute.name == "popularity" {
                let query = URLQueryItem(name: "target_\(attribute.name)", value: "\(Int(attribute.value))")
                components.queryItems?.append(query)
            } else {
                let query = URLQueryItem(name: "target_\(attribute.name)", value: "\(attribute.value)")
                components.queryItems?.append(query)
            }
        }
        let defaults = UserDefaults.standard
        var request = URLRequest(url: components.url!)
        request.setValue("Bearer " + defaults.string(forKey: "accesstoken")!, forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
                let recommendations = try JSONDecoder().decode(Recommendations.self, from: data)
                completion(recommendations)
            } catch {
                print("error")
                completion(nil)
            }
        }.resume()
        
    }
    func fetchAlbumArt(with url: String, completion: @escaping (UIImage?) -> Void) {
        let imageurl = URL(string: url)!
        URLSession.shared.dataTask(with: imageurl) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            } else {
                print("error fetching image")
                completion(nil)
            }
        }.resume()
    }
    
}
