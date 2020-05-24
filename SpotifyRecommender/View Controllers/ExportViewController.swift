//
//  ExportViewController.swift
//  SpotifyRecommender
//
//  Created by 90303054 on 5/18/20.
//  Copyright © 2020 90303054. All rights reserved.
//

import UIKit

class ExportViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    
    var trackids: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func handleCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createButtonPressed(_ sender: Any) {
        textField.isHidden = true
        label.isHidden = true
        button.isHidden = true
        spinner.startAnimating()
        guard let text = textField.text else { return }
        if trackids.count > 0 {
            fetchUserID { (id) in
                guard let id = id else { return }
                let playlist = PlaylistInput(name: text)
                self.createNewPlaylist(id: id, playlist: playlist) { (playlistid) in
                    guard let playlistid = playlistid else { return }
                    self.addSongs(id: playlistid) {
                        print("songs added")
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Playlist Export Complete!", message: "Would you like to open your playlist in the Spotify app?", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Open In App", style: .default, handler: { (action) in
                                let url = URL(string: "spotify:playlist:" + playlistid)!
                                if UIApplication.shared.canOpenURL(url) {
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }
                               self.dismiss(animated: true, completion: nil)
                            }))
                            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                                self.dismiss(animated: true, completion: nil)
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Network Requests
    
    func fetchUserID(completion: @escaping (String?) -> Void) {
        let defaults = UserDefaults.standard
        let url = URL(string: "https://api.spotify.com/v1/me")!
        var request = URLRequest(url: url)
        request.setValue("Bearer " + defaults.string(forKey: "accesstoken")!, forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
                let user = try JSONDecoder().decode(User.self, from: data)
                completion(user.id)
            } catch {
                print("error")
                completion(nil)
            }
        }.resume()
    }
    func createNewPlaylist(id: String, playlist: PlaylistInput, completion: @escaping (String?) -> Void) {
        let defaults = UserDefaults.standard
        let url = URL(string: "https://api.spotify.com/v1/users/\(id)/playlists")!
        var request = URLRequest(url: url)
        
        request.setValue("Bearer " + defaults.string(forKey: "accesstoken")!, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        do {
            let data = try JSONEncoder().encode(playlist)
            request.httpBody = data
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let response = response as? HTTPURLResponse, let data = data else { return }
                guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                    print("statusCode should be 2xx, but is \(response.statusCode)")
                    print("response = \(response)")
                    return
                }
                do {
                    let playlist = try JSONDecoder().decode(PlaylistOutput.self, from: data)
                    completion(playlist.id)
                } catch {
                    print("error decoding playlist id")
                    completion(nil)
                }
            }.resume()
        } catch {
            print("error encoding playlist")
            completion(nil)
        }
        
    }
    func addSongs(id: String, completion: @escaping () -> Void) {
        let defaults = UserDefaults.standard
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.spotify.com"
        components.path = "/v1/playlists/\(id)/tracks"
        let joinedIDS = trackids.joined(separator: ",")
        components.queryItems = [URLQueryItem(name: "uris", value: joinedIDS)]
        var request = URLRequest(url: components.url!)
        request.setValue("Bearer " + defaults.string(forKey: "accesstoken")!, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let response = response as? HTTPURLResponse else { return }
            guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                return
            }
            completion()
        }.resume()
    }
}
