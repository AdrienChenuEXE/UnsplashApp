//
//  FeedState.swift
//  UnsplashApp
//
//  Created by Adrien CHENU on 1/23/24.
//

import Foundation

class FeedState : ObservableObject{
    @Published var homeFeed: [UnsplashModel]?

    // Fetch home feed doit utiliser la fonction feedUrl de UnsplashAPI
    // Puis assigner le résultat de l'appel réseau à la variable homeFeed
    func fetchHomeFeed() async {
        // Obtient l'URL pour le feed en utilisant la fonction feedUrl
        guard let feedUrl = feedUrl() else {
            // TODO : gerer erreur : URL invalide
            return
        }

        do {
            // Effectue la requête réseau
            let (data, _) = try await URLSession.shared.data(from: feedUrl)

            // Décode les données reçues en tant que tableau d'UnsplashPhoto
            let decoder = JSONDecoder()
            let result = try decoder.decode([UnsplashModel].self, from: data)

            // Assigner le résultat à la variable homeFeed
            homeFeed = result
        } catch {
            print("Erreur lors de la récupération du feed : \(error)")
        }
    }
}
