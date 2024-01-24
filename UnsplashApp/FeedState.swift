//
//  FeedState.swift
//  UnsplashApp
//
//  Created by Adrien CHENU on 1/23/24.
//

import Foundation

class FeedState : ObservableObject{
    @Published var homeFeed: [UnsplashModel] = []
    @Published var homeTopics: [UnsplashTopic] = []
    @Published var topicFeed: [UnsplashModel] = []

    // Fetch home feed doit utiliser la fonction feedUrl de UnsplashAPI
    // Puis assigner le résultat de l'appel réseau à la variable homeFeed
    func fetchHomeFeed() async {
        // Obtient l'URL pour le feed en utilisant la fonction feedUrl
        guard let feedUrl = feedUrl() else {
            // TODO : gerer erreur : URL invalide
            return
        }
        
        DispatchQueue.main.async {
            self.homeFeed = []
        }
        
        do {
            let request = URLRequest(url: feedUrl)
            let (data, _) = try await URLSession.shared.data(for: request)
            let deserializedData = try JSONDecoder().decode([UnsplashModel].self, from: data)
            
            await DispatchQueue.main.async {
                self.homeFeed = deserializedData
            }
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
    
    func fetchHomeTopics() async {
        // Obtient l'URL pour le feed en utilisant la fonction feedUrl
        guard let feedUrl = feedUrl(path: "/topics") else {
            // TODO : gerer erreur : URL invalide
            return
        }

        do {
            let request = URLRequest(url: feedUrl)
            let (data, _) = try await URLSession.shared.data(for: request)
            let deserializedData = try JSONDecoder().decode([UnsplashTopic].self, from: data)
            
            await DispatchQueue.main.async {
                self.homeTopics = deserializedData
            }
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
    
    func fetchTopicFeed(id idTopic: String) async {
            let url = feedUrl(path: "/topics/\(idTopic)/photos")!

            DispatchQueue.main.async {
                self.topicFeed = []
            }
            
            do {
                let request = URLRequest(url: url)
                let (data, _) = try await URLSession.shared.data(for: request)
                let deserializedData = try JSONDecoder().decode([UnsplashModel].self, from: data)
                
                await DispatchQueue.main.async {
                    self.topicFeed = deserializedData
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
}
