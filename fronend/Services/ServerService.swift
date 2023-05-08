//
//  ServerService.swift
//  fronend
//
//  Created by Yosi Faroh Zada on 08/05/2023.
//

import Foundation

enum ServerError: Error {
    case invalidUsername
    case invalidUrl
    case invalidPayload
    case network
    case data
}

struct ServerResponse: Codable {
    let success: Bool
}

final class ServerService {
    private let baseUrl = "http://localhost:3000/"
    
    static let shared = ServerService()
    private init() {}
    
    func getPostImageUrl(post:Post) -> URL {
        URL(string: "\(baseUrl)\(post.imgUrl)")!
    }
    
    func getPostUrl(post:Post) -> String {
        "\(baseUrl)\(post.id)"
    }
    
    func getPosts(userPosts: Bool, username: String?, completion: @escaping (Result<[Post], ServerError>) -> ()) {
        guard let username = username else {
            completion(.failure(.invalidUsername))
            return
        }
        let urlString = "\(baseUrl)posts?userPosts=\(userPosts)&username=\(username)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidUrl))
            return
        }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, err in
            guard let data = data, err == nil else {
                completion(.failure(.network))
                return
            }
            
            do {
                let posts = try JSONDecoder().decode([Post].self, from: data)
                completion(.success(posts))
            } catch {
                print(error.localizedDescription)
                completion(.failure(.data))
            }
        }.resume()
    }
    
    func postNewPost(postPayload: PostUpload, completion: @escaping (Result<Post, ServerError>) -> ()) {
        guard let url = URL(string: "\(baseUrl)posts") else {
            completion(.failure(.invalidUrl))
            return
        }
        
        guard let jsonData = try? JSONEncoder().encode(postPayload) else {
            completion(.failure(.invalidPayload))
            return
        }
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request as URLRequest) { data, _, err in
            guard let data = data, err == nil else {
                completion(.failure(.network))
                return
            }
            
            do {
                let post = try JSONDecoder().decode(Post.self, from: data)
                completion(.success(post))
            } catch {
                print(error.localizedDescription)
                completion(.failure(.data))
            }
        }.resume()
    }
    
    func deletePost(postPayload: Post, completion: @escaping (Result<Bool, ServerError>) -> ()) {
        guard let url = URL(string: "\(baseUrl)posts") else {
            completion(.failure(.invalidUrl))
            return
        }
        
        guard let jsonData = try? JSONEncoder().encode(postPayload) else {
            completion(.failure(.invalidPayload))
            return
        }
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request as URLRequest) { data, _, err in
            guard let data = data, err == nil else {
                completion(.failure(.network))
                return
            }
            
            do {
                let serverResponse = try JSONDecoder().decode(ServerResponse.self, from: data)
                completion(.success(serverResponse.success))
            } catch {
                print(error.localizedDescription)
                completion(.failure(.data))
            }
        }.resume()
    }
    
    func updatePost(postPayload: PostEdit, completion: @escaping (Result<Bool, ServerError>) -> ()) {
        guard let url = URL(string: "\(baseUrl)posts") else {
            completion(.failure(.invalidUrl))
            return
        }
        
        guard let jsonData = try? JSONEncoder().encode(postPayload) else {
            completion(.failure(.invalidPayload))
            return
        }
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "put"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request as URLRequest) { data, _, err in
            guard let data = data, err == nil else {
                completion(.failure(.network))
                return
            }
            
            do {
                let serverResponse = try JSONDecoder().decode(ServerResponse.self, from: data)
                completion(.success(serverResponse.success))
            } catch {
                print(error.localizedDescription)
                completion(.failure(.data))
            }
        }.resume()
    }
}
