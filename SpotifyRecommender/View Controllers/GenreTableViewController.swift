//
//  GenreTableViewController.swift
//  SpotifyRecommender
//
//  Created by 90303054 on 5/5/20.
//  Copyright © 2020 90303054. All rights reserved.
//

import UIKit

protocol GenreDelegate {
    func saveCheckedGenres(genreList: [String])
}
class GenreTableViewController: UITableViewController {

    var genres: [String]?
    var checkedGenres: [String] = [] {
        didSet{
            delegate?.saveCheckedGenres(genreList: checkedGenres)
        }
    }
    var delegate: GenreDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.cellLayoutMarginsFollowReadableWidth = true
        
    }

    @IBAction func deleteButtonPressed(_ sender: Any) {
        checkedGenres = []
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let genres = genres else { return 0 }
        return genres.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "genre", for: indexPath)
        cell.textLabel?.text = genres?[indexPath.row].capitalizingFirstLetter()
        var checked = false
        for genre in checkedGenres {
            if genre == genres?[indexPath.row] {
                checked = true
            }
        }
        if checked {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath), let genre = genres?[indexPath.row] {
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
                checkedGenres.removeAll { $0 == genre }
            } else{
                if checkedGenres.count < 5 {
                cell.accessoryType = .checkmark
                checkedGenres.append(genre)
                } else {
                    let controller = UIAlertController(title: "Error", message: "You can only select up to 5 genres!", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    controller.addAction(action)
                    self.present(controller, animated: true)
                }
            }
        }
        
    }
    
    // MARK: - Navigation
     
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PlaylistBuilderViewController {
            destination.checkedGenres = checkedGenres
        }
    }
    

}
