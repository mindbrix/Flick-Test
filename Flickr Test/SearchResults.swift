//
//  SearchResults.swift
//  Flickr Test
//
//  Created by Nigel Barber on 01/10/2018.
//  Copyright © 2018 Nigel Barber. All rights reserved.
//

import Foundation

struct SearchResults {
    let imageURL: URL
    let title: String
    let link: URL
    let dateTaken: Date
    let author: String
}

extension SearchResults {
    init?(title: String) {
        guard let url = URL(string: title) else {
            return nil
        }
        self.imageURL = url
        self.title = title
        self.link = url
        self.dateTaken = Date()
        self.author = title
    }
    
    init?(json: [String: Any]) {
        guard let media = json["media"] as? [String: Any] else {
            return nil
        }
        guard let m = media["m"] as? String else {
            return nil
        }
        guard let imageURL = URL(string: m) else {
            return nil
        }
        guard let title = json["title"] as? String else {
            return nil
        }
        guard let link = json["link"] as? String else {
            return nil
        }
        guard let linkURL = URL(string: link) else {
            return nil
        }
        guard let dateString = json["date_taken"] as? String else {
            return nil
        }
        guard let date = ISO8601DateFormatter().date(from: dateString) else {
            return nil
        }
        guard let author = json["author"] as? String else {
            return nil
        }
        self.imageURL = imageURL
        self.title = title
        self.link = linkURL
        self.dateTaken = date
        self.author = author
    }
}

extension SearchResults {
    static func urlSearchingFor(_ query: String) -> URL? {
        let splitQuery = query.components(separatedBy: " ")
        let joinedQuery = splitQuery.joined(separator: ",")
        let escapedQuery = joinedQuery.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
        return URL(string: "https://api.flickr.com/services/feeds/photos_public.gne?nojsoncallback=1&format=json&lang=en-us&tags=\(escapedQuery)")
    }
    
    static func results(matching query: String, completion: @escaping ([SearchResults]) -> Void) {
        if let url = urlSearchingFor(query) {
            URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, _ in
                var results: [SearchResults] = []
                if let data = data {
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if let items = json!["items"] as? [[String: Any]] {
                            results = items.compactMap { SearchResults(json: $0) }
                        }
                    }
                }
                DispatchQueue.main.async {
                    completion(results)
                }
                }.resume()
        }
    }
}
