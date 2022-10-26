//
//  LaterGramTokenService.swift
//  LaterGram
//
//  Created by George Nyakundi on 21/10/2022.
//

import Foundation

/// Implementation of `TokenService` that uses a local file
public class LaterGramTokenService: TokenService {
    private let fileName: String
    private let fileExt: String
    private let bundle: Bundle
    
    public init(fromFile fileName: String = "config",
                withExtension fileExt: String = "json",
                bundle: Bundle = Bundle(for: LaterGramTokenService.self)) {
        self.fileName = fileName
        self.fileExt = fileExt
        self.bundle = bundle
    }
    
    public enum Error: Swift.Error {
        case fileNotFound
        case corruptedFile
    }
    
    struct Token: Decodable {
        let access_token: String
    }
    
    /// Returns a token
    /// - Parameter completion: `Result<String, Error>`
    public func getToken(completion: @escaping GetTokenCompletion) {
        let decoder = JSONDecoder()
        guard let url = bundle.url(forResource: fileName, withExtension: fileExt) else {
            completion(.failure(LaterGramTokenService.Error.fileNotFound))
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let token = try decoder.decode(Token.self, from: data)
            completion(.success(token.access_token))
        } catch {
            completion(.failure(LaterGramTokenService.Error.corruptedFile))
        }
    }
}
