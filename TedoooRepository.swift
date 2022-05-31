import Foundation

struct User {
    let username: String
    let avatar: String?
}

struct Post {
    let id: String
    let user: User
    let text: String
    var images: [String]
    var didLike: Bool
    var comments: Int
    var likes: Int
    let date: Date
}

struct Comment {
    let id: String
    let user: User
    let text: String
    let date: Date
}

struct FeedResponse {
    let hasMore: Bool
    let posts: [Post]
}

struct CommentResponse {
    let hasMore: Bool
    let comments: [Comment]
}

class TedoooApi {
    
    private let users: [User] = [
        .init(username: "Avram", avatar: nil),
        .init(username: "Yossi", avatar: "https://i.pravatar.cc/300?a=yossi"),
        .init(username: "Dina", avatar: "https://i.pravatar.cc/300?a=dina"),
        .init(username: "Tal", avatar: nil),
        .init(username: "Alex", avatar: "https://i.pravatar.cc/300?a=alex"),
    ]
    
    private func randomInt(min: Int, max: Int) -> Int {
        return Int.random(in: min..<max)
    }
    
    private func randomUser() -> User {
        return users[randomInt(min: 0, max: users.count)]
    }
    
    private func randomPost() -> Post {
        let diffInterval: TimeInterval = TimeInterval(randomInt(min: 0, max: 3600 * 24 * 30))
        return .init(id: UUID().uuidString, user: self.randomUser(), text: UUID().uuidString, images: (0...randomInt(min: 1, max: 5)).map({ _ in
            "https://i.pravatar.cc/300?a=\(UUID().uuidString)"
        }), didLike: randomInt(min: 0, max: 2) == 0, comments: randomInt(min: 0, max: 10), likes: randomInt(min: 1, max: 10), date: Date(timeIntervalSinceNow: -diffInterval))
    }
    
    func getFeed(maxId: String?, completion: @escaping (Result<FeedResponse, Error>) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            completion(.success(.init(hasMore: self.randomInt(min: 0, max: 5) != 4, posts: (1...10).map({ _ in
                self.randomPost()
            }))))
        }
    }
    
    func getComments(postId: String, maxId: String?, completion: @escaping (Result<CommentResponse, Error>) -> ()) {

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            completion(.success(.init(hasMore: self.randomInt(min: 0, max: 5) != 4, comments: (0...10).map({ _ in
                let diffInterval: TimeInterval = TimeInterval(self.randomInt(min: 0, max: 3600 * 24 * 30))
                return Comment(id: UUID().uuidString, user: self.randomUser(), text: UUID().uuidString, date: Date(timeIntervalSinceNow: -diffInterval))
            }))))
        }
    }
    
}

class TedoooRepository {
    
    static let shared = TedoooApi()
    
}
