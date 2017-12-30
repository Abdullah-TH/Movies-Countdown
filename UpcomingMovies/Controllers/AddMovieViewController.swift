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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    
    // MARK: Properties
    
    var refreshControl = UIRefreshControl()
    var currentPage = 1
    var totalPages: Int!
    
    // MARK: ViewController Methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if Movie.moviesToAdd.count == 0
        {
            downloadUpcomingMovies()
        }
        else
        {
            activityIndicator?.removeFromSuperview()
        }
        
        refreshControl.addTarget(self, action: #selector(updateDownloadingMovies), for: .valueChanged)
        tableView.refreshControl = refreshControl
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
            movieToAddVC.movie = Movie.moviesToAdd[row]
        }
    }
    
    // MARK: Helper Methods
    
    private func downloadUpcomingMovies()
    {
        DispatchQueue.main.async {
            self.activityIndicator?.startAnimating()
        }
        
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayFormattedString = dateFormatter.string(from: today)
        
        TheMovieDBAPIManager.getUpcomingMovies(page: currentPage, minReleaseDate: todayFormattedString) { (errorMessage, movies, totalPages) in
            
            if let error = errorMessage
            {
                DispatchQueue.main.async {
                    self.activityIndicator?.stopAnimating()
                    self.refreshControl.endRefreshing()
                    self.showAlert(title: "Error", message: error)
                }
            }
            else
            {
                self.totalPages = totalPages
                self.currentPage += 1
                Movie.moviesToAdd.append(contentsOf: movies!)
                
                if  self.currentPage <= (totalPages ?? 0)
                {
                    self.downloadUpcomingMovies()
                }
                else
                {
                    DispatchQueue.main.async {
                        self.activityIndicator?.removeFromSuperview()
                        self.refreshControl.endRefreshing()
                        self.currentPage = 1
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    @objc private func updateDownloadingMovies()
    {
        Movie.moviesToAdd.removeAll()
        tableView.reloadData()
        downloadUpcomingMovies()
    }
    
    private func setCellPosterImage(for row: Int, cell: MovieToAddTableViewCell, path: String)
    {
        DispatchQueue.global(qos: .userInitiated).async {
        
            TheMovieDBAPIManager.downloadMoviePoster(size: .small, path: path, completion: { (posterImage, error) in
                
                if error == nil
                {
                    Movie.moviesToAdd[row].poster = posterImage
                    //cell.posterImageView.image = posterImage
                    let cell = self.tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? MovieToAddTableViewCell
                    cell?.posterImageView.image = posterImage
                    
                }
                else
                {
                    self.showAlert(title: "Error downloading poster image", message: error!.localizedDescription)
                }
            })
        }
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
        return Movie.moviesToAdd.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieToAddCell", for: indexPath) as! MovieToAddTableViewCell
        let movie = Movie.moviesToAdd[indexPath.row]
        cell.posterImageView.image = movie.poster
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
        
        if movie.poster == #imageLiteral(resourceName: "default-image-small")
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        performSegue(withIdentifier: "AddMovieToMovieToAdd", sender: indexPath.row)
    }
}













