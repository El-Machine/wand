//
//  Repo.swift
//  Pipe
//
//  Created by Alex Kozin on 21.11.2022.
//

import Pipe

public extension GitHubAPI {

    struct Repo: Codable {

        let id: Int

        let name: String?
        let description: String?

        let watchers: Int?

    }

}

extension GitHubAPI.Repo: GitHubAPI.Model {

    public static var path: String {
        "repositories"
    }

}

public
extension Ask where T == GitHubAPI.Repo {

    static func get(handler: @escaping (GitHubAPI.Repo)->() ) -> Self {

        let ask = one(handler: handler)
        ask.onAttach = { pipe in

            let id: Int = pipe.get()!
            let path = (T.base ?? "") + "\(T.path)/\(id)"

            pipe.store(path)

        }

        return ask
    }

}



//public
//extension Array: Asking where Element == GitHubAPI.Repo {
//
//    static func get(handler: @escaping (T)->() ) -> Self {
//
//        let ask = Self.one(handler: handler)
//        ask.onAttach = { pipe in
//
//            let id: Int = pipe.get()!
//            let path = (T.base ?? "") + "\(T.path)/\(id)"
//
//            pipe.store(path)
//
//        }
//
//        return ask
//    }
//
//}



public
extension Ask where T == [GitHubAPI.Repo] {

    static func get(handler: @escaping (T)->() ) -> Self {

        let ask = Self.one(handler: handler)
        ask.onAttach = { pipe in

//            let id: Int = pipe.get()!
//            let path = (T.base ?? "") + "\(T.path)/\(id)"
//
//            pipe.store(path)

        }

        return ask
    }

}

//extension [Repo]: GitHubAPIModel,
//
//                  Rest.Model,
//                  Expectable,
//                  ExpectableLabeled,
//                  ExpectableWithout {
//
//    public static func get<P>(with piped: P, on pipe: Pipe) {
//
//        switch piped {
//
//                //api.github.com/repositories?q=ios
//            case let query as String:
//
//                let path = base + "repositories?q=" + query
//                pipe.put(path)
//
//                break
//
//                //api.github.com/repositories
//            default:
//
//                let path = base + "repositories"
//                pipe.put(path)
//
//                break
//
//        }
//
//    }
//
//}

