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
    
    var upcomingMovies = [Movie]()
    var currentPage = 1
    var totalPages: Int!
    
    // MARK: ViewController Methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        TheMovieDBAPIManager.getUpcomingMovies(page: currentPage, minReleaseDate: "2017-12-01") { (error, movies, totalPages) in
            
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
                self.totalPages = totalPages
                self.currentPage += 1
                self.upcomingMovies.append(contentsOf: movies!)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    // MARK: Actions
    
    @IBAction func cancelAddMovie(_ sender: UIBarButtonItem)
    {
        dismiss(animated: true, completion: nil)
    }
}

extension AddMovieViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return upcomingMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieToAddCell", for: indexPath) as! MovieToAddTableViewCell
        let movie = upcomingMovies[indexPath.row]
        cell.movieNameLabel.text = movie.title
        return cell
    }
}

extension AddMovieViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        print("page: \(currentPage)")
        print("total pages: \(totalPages!)")
        
        if indexPath.row == upcomingMovies.count - 1 && currentPage <= totalPages
        {
            TheMovieDBAPIManager.getUpcomingMovies(page: currentPage, minReleaseDate: "2017-12-01") { (error, movies, totalPages) in
                
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
                    self.totalPages = totalPages
                    self.currentPage += 1
                    self.upcomingMovies.append(contentsOf: movies!)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
}













