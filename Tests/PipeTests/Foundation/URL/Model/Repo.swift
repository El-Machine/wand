//
//  Repo.swift
//  Pipe
//
//  Created by Alex Kozin on 21.11.2022.
//

import Pipe

struct Repo: GitHubAPIModel {

    var id: Int?

    var name: String?
    var description: String?

    var watchers: Int?

    static var path: String? {
        basePath + "/repositories"
    }

}
