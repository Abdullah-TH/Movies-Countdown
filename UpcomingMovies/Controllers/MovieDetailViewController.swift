//
//  MovieDetailViewController.swift
//  UpcomingMovies
//
//  Created by Abdullah Althobetey on 04/12/2017.
//  Copyright © 2017 Abdullah Althobetey. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController
{
    // MARK: Outlets
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var yearsLabel: UILabel!
    @IBOutlet weak var monthsLabel: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var secondsLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    // MARK: Properties
    
    var movie: Movie!
    var timer = Timer()
    
    // MARK: ViewController Methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            
            self.updateCountdownComponents()
        }
    }
    
    // MARK: Helper Methods
    
    private func updateCountdownComponents()
    {
        if let countdownComponents = movie.countdownComponents
        {
            yearsLabel.text = countdownComponents.years
            monthsLabel.text = countdownComponents.months
            daysLabel.text = countdownComponents.days
            hoursLabel.text = countdownComponents.hours
            minutesLabel.text = countdownComponents.minutes
            secondsLabel.text = countdownComponents.seconds
        }
        else
        {
            timer.invalidate() // movie allready released, no need to run the timer
        }
    }
    
    // MARK: Actions
    
    @IBAction func shareMovie(_ sender: UIBarButtonItem)
    {
    }
    
    @IBAction func deleteMovie(_ sender: UIBarButtonItem)
    {
    }
    
}





