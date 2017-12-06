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
        
        movieGenresLabel.text = ""
        movieNameLabel.text = movie.title
        releaseDateLabel.text = "Releasing " + movie.releaseDateString
        overviewTextView.text = movie.overview
        downloadMoviePosterImage(path: movie.posterPath)
        
        if overviewTextView.text == ""
        {
            overviewTextView.text = "No description available."
            overviewTextView.textColor = UIColor.gray
        }
    }
    
    // MARK: Helper Methods
    
    private func downloadMoviePosterImage(path: String)
    {
        DispatchQueue.global(qos: .userInitiated).async {
            let posterBaseURL = URL(string: "https://image.tmdb.org/t/p/w300/")
            let posterURL = posterBaseURL?.appendingPathComponent(self.movie.posterPath)
            let posterData = try! Data(contentsOf: posterURL!)
            let posterImage = UIImage(data: posterData)
            DispatchQueue.main.async {
                self.moviePosterImageView.image = posterImage
            }
        }
    }
    
    // MARK: Actions

    @IBAction func addMovie(_ sender: UIButton)
    {
    }
}








