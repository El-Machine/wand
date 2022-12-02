//
//  Repo.swift
//  Pipe
//
//  Created by Alex Kozin on 21.11.2022.
//

import Pipe

public extension GitHubAPI {

    struct Repo {

        let id: Int

        let name: String?
        let description: String?

        let watchers: Int?

    }

}

extension GitHubAPI.Repo: GitHubAPI.Model {

    public static func get<P, E>(_ expectation: Expect<E>, with piped: P, on pipe: Pipe) {

        if expectation is Expect<[Self]> {

            let path = base + "repositories"
            pipe.put(path)

        } else {

            if let id = piped as? Int {

                let path = base + "repositories/" + id|
                pipe.put(path)

            }

        }

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

