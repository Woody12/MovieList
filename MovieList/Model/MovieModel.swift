//
//  MovieModel.swift
//  MovieList
//
//  Created by Woody Lee on 7/19/19.
//  Copyright © 2019 Woody Lee. All rights reserved.
//

import Foundation
import UIKit

struct MovieModel: Codable {
	
	enum CodingKeys: String, CodingKey {

		case title
		case poster_path
		case backdrop_path
		case overview
	}
	
	public init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		title = try values.decode(String.self, forKey: .title)
		poster_path = try values.decode(String?.self, forKey: .poster_path)
		backdrop_path = try values.decode(String?.self, forKey: .backdrop_path)
		overview = try values.decode(String.self, forKey: .overview)
	}
	
	let title: String
	let poster_path: String?
	let backdrop_path: String?
	let overview: String
	
	var posterImage: UIImage?
	var backdropImage: UIImage?
}
