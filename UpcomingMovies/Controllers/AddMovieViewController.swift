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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Properties
    
    var upcomingMovies = [Movie]()
    var genres: [[String: Any]]!
    var moviePosters = [UIImage?]()
    var currentPage = 1
    var totalPages: Int!
    
    // MARK: ViewController Methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        downloadUpcomingMovies()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow
        {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "AddMovieToMovieToAdd"
        {
            let movieToAddVC = segue.destination as! MovieToAddViewController
            let row = sender as! Int
            movieToAddVC.movie = upcomingMovies[row]
        }
    }
    
    // MARK: Helper Methods
    
    private func downloadUpcomingMovies()
    {
        activityIndicator.startAnimating()
        
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayFormattedString = dateFormatter.string(from: today)
        
        TheMovieDBAPIManager.getUpcomingMovies(page: currentPage, minReleaseDate: todayFormattedString) { (errorMessage, movies, totalPages) in
            
            if let error = errorMessage
            {
                DispatchQueue.main.async {
                    self.showAlertMessage(title: "Error", message: error)
                }
            }
            else
            {
                self.totalPages = totalPages
                self.currentPage += 1
                self.upcomingMovies.append(contentsOf: movies!)
                self.moviePosters.append(contentsOf: repeatElement(UIImage(named: "default-image-small"), count: movies!.count))
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    private func setCellPosterImage(for row: Int, cell: MovieToAddTableViewCell, path: String)
    {
        DispatchQueue.global(qos: .userInitiated).async {
        
            TheMovieDBAPIManager.downloadMoviePoster(size: .small, path: path, completion: { (posterImage, error) in
                
                if error == nil
                {
                    self.moviePosters[row] = posterImage
                    cell.posterImageView.image = posterImage
                }
                else
                {
                    self.showAlert(title: "Error downloading poster image", message: error!.localizedDescription)
                }
            })
        }
    }
    
    private func showAlertMessage(title: String?, message: String?)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

    // MARK: Actions
    
    @IBAction func goBack(_ sender: UIBarButtonItem)
    {
        let navigationController = presentingViewController as! UINavigationController
        let upcomingMoviesVC = navigationController.topViewController as! UpcomingMoviesViewController
        upcomingMoviesVC.tableView.reloadData()
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
        cell.posterImageView.image = moviePosters[indexPath.row]
        cell.movieNameLabel.text = movie.title
        
        cell.genresLabel.text = ""
        for genre in movie.genres
        {
            if cell.genresLabel.text == ""
            {
                cell.genresLabel.text?.append(genre)
            }
            else
            {
                cell.genresLabel.text?.append(" - \(genre)")
            }
        }
        
        if moviePosters[indexPath.row] == #imageLiteral(resourceName: "default-image-small")
        {
            setCellPosterImage(for: indexPath.row, cell: cell, path: movie.posterPath)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 90
    }
}

extension AddMovieViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        // Start downloading the next page of movies when the fifth cell, from bottom, is displayed, and if total pages not exceeded
        if indexPath.row == upcomingMovies.count - 5 && currentPage <= (totalPages ?? 0)
        {
            downloadUpcomingMovies()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        performSegue(withIdentifier: "AddMovieToMovieToAdd", sender: indexPath.row)
    }
    
}













