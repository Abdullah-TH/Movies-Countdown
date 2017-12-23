//
//  MovieInfoViewController.swift
//  UpcomingMovies
//
//  Created by Abdullah Althobetey on 23/12/2017.
//  Copyright © 2017 Abdullah Althobetey. All rights reserved.
//

import UIKit

class MovieInfoViewController: UIViewController
{
    // MARK: Outlets
    
    @IBOutlet weak var movieTitleLable: UILabel!
    @IBOutlet weak var movieGenresLabel: UILabel!
    @IBOutlet weak var releaseDateLable: UILabel!
    @IBOutlet weak var overviewTextView: UITextView!
    
    // MARK: Properties
    
    var userMovie: UserMovie!
    
    // MARK: ViewController Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        movieTitleLable.text = userMovie.title
        releaseDateLable.text = "\(userMovie.allreadyReleased ? "Released" : "Releasing") \(userMovie.prettyDateString)"
        overviewTextView.text = userMovie.overview == "" ? "No description avilable." : userMovie.overview
        
        for genre in userMovie.genres
        {
            if movieGenresLabel.text == ""
            {
                movieGenresLabel.text?.append(genre as! String)
            }
            else
            {
                movieGenresLabel.text?.append(" - \(genre as! String)")
            }
        }
    }
    
    // MARK: Actions
    
    @IBAction func goBack(_ sender: UIButton)
    {
        dismiss(animated: true, completion: nil)
    }
}

















