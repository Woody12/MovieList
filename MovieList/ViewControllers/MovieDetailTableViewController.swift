//
//  MovieDetailTableViewController.swift
//  MovieList
//
//  Created by Woody Lee on 7/20/19.
//  Copyright © 2019 Woody Lee. All rights reserved.
//

import UIKit

class MovieDetailTableViewController: UITableViewController {
	
	@IBOutlet weak var backDropImageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var synopsisLabel: UILabel!
	
	public var movieTitle: String?
	public var backDropImage: UIImage?
	public var synopsis: String?
	
    override func viewDidLoad() {
        super.viewDidLoad()

		navigationItem.title = "Movie Details"
		tableView.backgroundColor = .black
		titleLabel.textColor = .white
		synopsisLabel.textColor = .white
		
		backDropImageView.image = backDropImage
		titleLabel.text = movieTitle
		synopsisLabel.text = synopsis
    }
}
