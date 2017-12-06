//
//  MovieToAddViewController.swift
//  UpcomingMovies
//
//  Created by Abdullah Althobetey on 04/12/2017.
//  Copyright © 2017 Abdullah Althobetey. All rights reserved.
//

import UIKit

class MovieToAddViewController: UIViewController
{
    // MARK: Outlets
    
    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var movieGenresLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var overviewTextView: UITextView!
    
    // MARK: Properties
    
    var movie: Movie!
    
    // MARK: ViewController Methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        movieGenresLabel.text = "" // to remove interface builder default text
        for genre in movie.genres
        {
            if movieGenresLabel.text == ""
            {
                movieGenresLabel.text?.append(genre)
            }
            else
            {
                movieGenresLabel.text?.append(" - \(genre)")
            }
        }
        
        movieNameLabel.text = movie.title
        releaseDateLabel.text = "Releasing " + movie.releaseDateString
        overviewTextView.text = movie.overview
        setMoviePosterImage(path: movie.posterPath)
        
        if overviewTextView.text == ""
        {
            overviewTextView.text = "No description available."
            overviewTextView.textColor = UIColor.gray
        }
    }
    
    // MARK: Helper Methods
    
    private func setMoviePosterImage(path: String)
    {
        TheMovieDBAPIManager.downloadMoviePoster(size: .large, path: movie.posterPath) { (posterImage) in
            
            self.moviePosterImageView.image = posterImage
        }
    }
    
    // MARK: Actions

    @IBAction func addMovie(_ sender: UIButton)
    {
        Movie.userMovies.append(movie)
        
        let alertController = UIAlertController(title: nil, message: "\(movie.title) sucessfully added to your list!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}








