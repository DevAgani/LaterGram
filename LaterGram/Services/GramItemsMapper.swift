//
//  GramItemsMapper.swift
//  LaterGram
//
//  Created by George Nyakundi on 21/10/2022.
//

import Foundation


final class GramItemsMapper {
    private struct Root: Decodable {
        let data: [Item]
        
        var items: [ImageItem] {
            return data.map { $0.image }
        }
    }
    
    /// Internal type matching the API response
    ///  In the event that the API response change, the internal representation will not be affected
    private struct Item: Decodable {
        let id: String
        let media_type: String
        let media_url: URL
        let username: String
        let timestamp: Date
        
        var image: ImageItem {
            return ImageItem(id: id,
                             type: media_type,
                             url: media_url,
                             username: username,
                             timestamp: timestamp
            )
        }
    }
    
    private static var OK_200: Int {
        return 200
    }
    
    static func map(_ data: Data, from response: HTTPURLResponse) -> LaterGramLoader.Result {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        guard response.statusCode == OK_200,
                let root = try? decoder.decode(Root.self, from: data) else {
            return .failure(RemoteLaterGramLoader.Error.invalidData)
        }
        
        return .success(root.items)
    }
}
