//
//  Repo.swift
//  Pipe
//
//  Created by Alex Kozin on 21.11.2022.
//

import Foundation

public extension GitHubAPI {

    struct Repo: Codable {

        let id: Int

        let name: String?
        let description: String?

        let watchers: Int?

    }

}
