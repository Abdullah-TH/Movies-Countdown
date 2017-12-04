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
    
    // MARK: ViewController Methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    // MARK: Actions
    
    @IBAction func shareMovie(_ sender: UIBarButtonItem)
    {
    }
    
    @IBAction func deleteMovie(_ sender: UIBarButtonItem)
    {
    }
    
}





