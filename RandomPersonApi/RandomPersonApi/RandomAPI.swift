//
//  RandomAPI.swift
//  RandomPersonApi
//
//  Created by Zander Ewell on 2/27/23.
//

import Foundation
import UIKit

class RandomAPI {
    enum GetError: Error, LocalizedError {
        case failedToLoadData
    }
    
    class RandomAPIController {
        
        func fetchRandomUser() async throws -> Response {
            let urlComponents = URLComponents(string: "https://randomuser.me/api/")
            
            let (data, response) = try await URLSession.shared.data(from: (urlComponents?.url)!)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw RandomAPIController.RandomApiError.userNotFound // fixed error: use fully qualified error name
            }
            
            let jsonDecoder = JSONDecoder()
            let person = try jsonDecoder.decode(Response.self, from: data)
            return person // fixed error: use value without parentheses
        }
        
        func randomImage(from url: URL) async throws -> UIImage {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw RandomAPIController.RandomApiError.userNotFound // fixed error: use fully qualified error name
            }
            guard let image = UIImage(data: data) else {
                throw RandomAPIController.RandomApiError.userNotFound // fixed error: use fully qualified error name
            }
            return image
        }
        
        enum RandomApiError: Error, LocalizedError {
            case userNotFound
        }
    }
    
}



//class RandomApiController {
//
//    func fetchRandomUsers(completion: @escaping (Result<[RandomUser], Error>) -> Void) {
//        let url = URL(string: "https://randomuser.me/api/")!
//
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            guard let data = data else {
//                completion(.failure(error ?? NSError(domain: "Unknown error", code: 0, userInfo: nil)))
//                return
//            }
//
//            do {
//                let decoder = JSONDecoder()
//                let response = try decoder.decode(Response.self, from: data)
//                completion(.success(response.results))
//            } catch {
//                completion(.failure(error))
//            }
//        }
//
//        task.resume()
//    }
//}


 
