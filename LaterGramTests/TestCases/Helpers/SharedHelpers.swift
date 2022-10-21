//
//  SharedHelpers.swift
//  LaterGramTests
//
//  Created by George Nyakundi on 21/10/2022.
//

import Foundation

func url(_ string: String = "https://dummy-url.com") -> URL {
    URL(string: string)!
}

func anyNSError() -> NSError {
    NSError(domain: "any error", code: 0)
}

