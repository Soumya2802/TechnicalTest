//
// Created by Alex Jackson on 01/03/2021.
//

struct Post: Equatable, Codable {
    let id: Int
    var title: String
    var body: String
    
}



struct PostCommentsDetails: Equatable, Codable{
   
    let postId: Int
    let id: Int
    var name: String
    var email: String
    var body: String
}

struct PostComments: Equatable, Codable {
    let postId: Int
    let id: Int
    var name: String
    var email: String
    var body: String

    
}

