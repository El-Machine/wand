//
//  NSHTTPCookie+Pipe.swift
//  Sample
//
//  Created by Alex Kozin on 09.02.2021.
//  Copyright © 2021 El Machine. All rights reserved.
//

import WebKit

extension HTTPCookie: Pipable {
    
}

@discardableResult
func |(piped: WKWebView, handler: @escaping ([HTTPCookie])->()) -> WKWebView {
    piped.configuration.websiteDataStore.httpCookieStore.getAllCookies(handler)
    return piped
}
