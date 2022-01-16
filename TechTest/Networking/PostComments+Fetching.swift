//
//  PostComments+Fetching.swift
//  TechTest
//
//  Created by Soumya Ammu on 1/11/22.
//

import Foundation


extension PostComments{
    static func loadComments(withID postID: Int, completion: @escaping (Result<[PostComments], Error>) -> Void) {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts/\(postID)/comments/")!
        
        print(url)
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }

            do {
                let data = data ?? Data()
                let postComments = try JSONDecoder().decode([PostComments].self, from: data)
                print(postComments)
                completion(.success(postComments))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}
