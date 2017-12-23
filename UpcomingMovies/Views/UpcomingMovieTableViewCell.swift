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
    @IBOutlet weak var countDownBackgroundView: UIView!
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var countDownLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var untilOrSinceLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    override func prepareForReuse()
    {
        super.prepareForReuse()
        posterImageView.image = #imageLiteral(resourceName: "default-image-small")
        untilOrSinceLabel.isHidden = false
        countDownLabelTopConstraint.constant = 8
    }
    
}
