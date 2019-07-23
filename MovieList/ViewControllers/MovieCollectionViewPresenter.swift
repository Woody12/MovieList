//
//  MovieCollectionViewPresenter.swift
//  MovieList
//
//  Created by Woody Lee on 7/19/19.
//  Copyright © 2019 Woody Lee. All rights reserved.
//

import Foundation
import UIKit

class MovieCollectionViewPresenter {
	
	public var movieCollectionVC: MovieCollectionViewProtocol?
	
	private let dataReadFailMsg = "Error loading data."
	private let populateFailMsg = "Error populating data perhaps due to network issue."
	
	private let imageURL = "https://image.tmdb.org/t/p/original/"
	private let filterMovieURL = "https://api.themoviedb.org/3/search/movie?language=en-US&page=1&include_adult=false&query="
	
	private let showMovieURL = "https://api.themoviedb.org/3/movie/now_playing?page=1&language=en-US"
	
	private let apiParam = "&api_key="
	
	private var movieModels: [MovieModel]?
	
	init(_ movieVC: MovieCollectionViewProtocol?) {
		movieCollectionVC = movieVC
		
		// Load data to model
		retrieveLatestMovies()
	}
	
	public func numberOfMovies() -> Int {
		return movieModels?.count ?? 0
	}
	
	public func showMoviePoster(indexPath: IndexPath) -> UIImage? {
		
		// Show image if already downloaded else invoke asynch call
		if let posterImage = movieModels?[indexPath.row].posterImage {
			return posterImage
		}else {
			
			// Invoke Asynchronous Call
			if let posterPath = movieModels?[indexPath.row].poster_path {
				
				let moviePath = imageURL + posterPath
				DispatchQueue.global().async { [weak self] in
					if let data = try? Data(contentsOf: URL(string: moviePath)!) {
						if let image = UIImage(data: data),
							self?.movieModels?.count ?? 0 > indexPath.row {
							
							DispatchQueue.main.async {
								self?.movieModels?[indexPath.row].posterImage = image
								self?.movieCollectionVC?.displayMovies(at: indexPath)
							}
						}
					}
				}
			}
			
			// Get Backdrop Image
			if let backDropPath = movieModels?[indexPath.row].backdrop_path {
				
				let backdropImagePath = imageURL + backDropPath
				DispatchQueue.global().async { [weak self] in
					if let data = try? Data(contentsOf: URL(string: backdropImagePath)!) {
						if let image = UIImage(data: data),
							self?.movieModels?.count ?? 0 > indexPath.row {
								DispatchQueue.main.async {
									self?.movieModels?[indexPath.row].backdropImage = image
								}
							}
					}
				}
			}
			
			return nil
		}
	}
	
	public func showMovieTitle(index: Int) -> String? {
		return movieModels?[index].title
	}
	
	public func showMovieBackdrop(index: Int) -> UIImage? {
		return movieModels?[index].backdropImage
	}
	
	public func showMovieSynopsis(index: Int) -> String? {
		return movieModels?[index].overview
	}
}

extension MovieCollectionViewPresenter {
	
	public func retrieveLatestMovies() {
		
		let resource: Resource<[MovieModel]> = Resource(urlString: showMovieURL + apiParam, method: "GET")
		
		WebService().loadMovie(resource: resource) { [weak self] (result: Result<[MovieModel], NetworkError>) in
			
			switch result {
			case .failure(let reason):
				
				let errorMsg = ((reason == .DataReadFail) ? self?.dataReadFailMsg : self?.populateFailMsg)
				
				DispatchQueue.main.async {
					self?.movieCollectionVC?.displayError(message: errorMsg)
				}
				
			case .success(let movieData):
				
				// Create persistent storage
				self?.movieModels = movieData
				
				DispatchQueue.main.async {
					
					// Invoke display movies
					self?.movieCollectionVC?.displayMovies()
				}
			}
		}
	}
	
	public func filterMovies(_ query: String) {
		
		let queryEncoded = query.lowercased().addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
		let movieURL = filterMovieURL + queryEncoded + apiParam
		let resource: Resource<[MovieModel]> = Resource(urlString: movieURL, method: "GET")
		
		WebService().loadMovie(resource: resource) { [weak self] (result: Result<[MovieModel], NetworkError>) in
			
			switch result {
			case .failure( _):
				
				// No movie found so do nothing
				print("Nothing to do")
				
			case .success(let movieData):
				
				// Create persistent storage & replace old models
				self?.movieModels = movieData
				
				DispatchQueue.main.async {
					
					// Invoke display movies
					self?.movieCollectionVC?.displayMovies()
				}
			}
		}
	}
}
