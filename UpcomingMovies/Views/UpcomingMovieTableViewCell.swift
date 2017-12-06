//
//  UpcomingMovieTableViewCell.swift
//  UpcomingMovies
//
//  Created by Abdullah Althobetey on 04/12/2017.
//  Copyright © 2017 Abdullah Althobetey. All rights reserved.
//

import UIKit

class UpcomingMovieTableViewCell: UITableViewCell
{
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var untilOrSinceLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    override func prepareForReuse()
    {
        posterImageView.image = #imageLiteral(resourceName: "default-image-small")
    }
    
}
