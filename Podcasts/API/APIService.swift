//
//  APIService.swift
//  Podcasts
//
//  Created by Artem Ekimov on 09.09.2021.
//

import Foundation
import Alamofire
import FeedKit

class APIService {
    
    //singleton
    static let shared = APIService()
    
    func fetchEpisodes(feedUrl: String, completionHandler: @escaping ([Episode]) -> Void) {
        guard let url = URL(string: feedUrl) else { return }
        
        DispatchQueue.global(qos: .background).async {
            let parser = FeedParser(URL: url)
            parser.parseAsync { result in
      
                switch result {
                case .success(let feed):

                    switch feed {
                    case let .rss(feed):
                        let episodes = feed.toEpisodes()
                        completionHandler(episodes)
                        break
                    default:
                        print("Some other type of feed.")
                    }
                    
                case .failure(let error):
                    print("Failed to parse feed", error)
                }
            }
        }
    }
 
    func fetchPodcasts(searchText: String, completionHandler: @escaping ([Podcast]) -> Void) {
        print("Searching for podcast")
        
        let url = "https://itunes.apple.com/search"
        let parameters = ["term": searchText, "media": "podcast"]
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            if let error = dataResponse.error {
                print(error)
                return
            }
            guard let data = dataResponse.data else { return }
            
            do {
                let searchResult = try JSONDecoder().decode(SearchResults.self, from: data)
                print(searchResult.resultCount)
                completionHandler(searchResult.results)
                
//                self.podcasts = searchResult.results
//                self.tableView.reloadData()
          
            } catch let decodeErr {
                print("Failed to decode: \(decodeErr)")
            }
            
        }
    }
    
    struct SearchResults: Codable {
        let resultCount: Int
        let results: [Podcast]
    }
    
}
    
