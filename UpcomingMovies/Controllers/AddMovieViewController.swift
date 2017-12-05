//
//  AddMovieViewController.swift
//  UpcomingMovies
//
//  Created by Abdullah Althobetey on 04/12/2017.
//  Copyright © 2017 Abdullah Althobetey. All rights reserved.
//

import UIKit

class AddMovieViewController: UIViewController
{
    // MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Properties
    
    var upcomingMovies: [Movie]?
    
    // MARK: ViewController Methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        TheMovieDBAPIManager.getUpcomingMovies(page: 1, minReleaseDate: "2017-12-01") { (error, movies) in
            
            if let error = error
            {
                let alertController = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okAction)
                DispatchQueue.main.async {
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            else
            {
                self.upcomingMovies = movies
                self.tableView.reloadData()
            }
        }
    }

    // MARK: Methods
    
    @IBAction func cancelAddMovie(_ sender: UIBarButtonItem)
    {
        dismiss(animated: true, completion: nil)
    }
}

extension AddMovieViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return upcomingMovies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieToAddCell", for: indexPath) as! MovieToAddTableViewCell
        let movie = upcomingMovies![indexPath.row]
        cell.movieNameLabel.text = movie.title
        return cell
    }
}













