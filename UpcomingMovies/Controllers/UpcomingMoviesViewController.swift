//
//  ViewController.swift
//  UpcomingMovies
//
//  Created by Abdullah Althobetey on 04/12/2017.
//  Copyright © 2017 Abdullah Althobetey. All rights reserved.
//

import UIKit

class UpcomingMoviesViewController: UIViewController
{
    // MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: ViewController Methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: Helper Methods
    
    private func setCellPosterImage(cell: UpcomingMovieTableViewCell, path: String)
    {
        DispatchQueue.global(qos: .userInitiated).async {
            
            TheMovieDBAPIManager.downloadMoviePoster(size: .small, path: path, completion: { (posterImage) in
                
                cell.posterImageView.image = posterImage
            })
        }
    }

    // MARK: Actions
    
    @IBAction func goToSettings(_ sender: UIBarButtonItem)
    {
    }
}

extension UpcomingMoviesViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return Movie.userMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpcomingMovieCell", for: indexPath) as! UpcomingMovieTableViewCell
        let movie = Movie.userMovies[indexPath.row]
        cell.movieNameLabel.text = movie.title
        setCellPosterImage(cell: cell, path: movie.posterPath)
        return cell
    }
}

extension UpcomingMoviesViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 90
    }
}








