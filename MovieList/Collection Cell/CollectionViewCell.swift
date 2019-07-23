//
//  CollectionViewCell.swift
//  MovieList
//
//  Created by Woody Lee on 7/19/19.
//  Copyright © 2019 Woody Lee. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
	
	var movieImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFill
		return imageView
	}()
	
	override init(frame: CGRect) {
		
		super.init(frame: frame)
		addSubview(movieImageView)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		
		movieImageView.backgroundColor = .purple
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		NSLayoutConstraint.activate([
			movieImageView.topAnchor.constraint(equalTo: self.topAnchor),
			movieImageView.leftAnchor.constraint(equalTo: self.leftAnchor),
			movieImageView.rightAnchor.constraint(equalTo: self.rightAnchor),
			movieImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
		])
	}
}
