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
        
        func fetchRandomUser(userAmount: Int, _ searchParameters: [String]) async throws -> Response {
            let url = URL(string: "https://randomuser.me/api/?inc=name,picture,\(searchParameters.joined(separator: ","))&results=\(userAmount)")
            

            let (data, response) = try await URLSession.shared.data(from: url!)
            
            print()
            print()
            print(String(data: data, encoding: .utf8)!)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw RandomAPIController.RandomApiError.userNotFound // fixed error: use fully qualified error name
            }
            
            let jsonDecoder = JSONDecoder()
            let person = try jsonDecoder.decode(Response.self, from: data)
            print(person)
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


