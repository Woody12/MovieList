//
//  WebService.swift
//  MovieList
//
//  Created by Woody Lee on 7/19/19.
//  Copyright © 2019 Woody Lee. All rights reserved.
//

import Foundation

enum NetworkError: Error {
	case DataReadFail
	case PopulateFail
}

struct Resource<T: Codable> {
	var urlString: String
	var method: String
}

class WebService {
	
	private let key = "b951b1d96d646c39ac7525f88a9833d7"
	
	public func loadMovie<T>(resource: Resource<T>, completion: @escaping (Result<T, NetworkError>) -> Void) {
		
		let postData = Data(base64Encoded: "{}".data(using: .utf8)!)
		let url = resource.urlString + key
	
		var request = URLRequest(url: URL(string: url)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
		
		request.httpMethod = resource.method
		request.httpBody = postData
		
		// Invoke the Web service
		URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
			
			// Check for error
			guard let data = data,
				let jsonData = try? (JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers) as? [String: Any]),
				let jsonMovieData = jsonData["results"],
				let jsonMovieObject = try? JSONSerialization.data(withJSONObject: jsonMovieData, options: .prettyPrinted)
			else {
				completion(.failure(.DataReadFail))
				return
			}
			
			// Populate to Model
			if let newModel: T = try? JSONDecoder().decode(T.self, from: jsonMovieObject) {
				// Populate to model structure
				completion(.success(newModel))
			} else {
				completion(.failure(.PopulateFail))
			}
			
		}).resume()
	}
}


