//
//  UnsplashAPI.swift
//  UnsplashApp
//
//  Created by Adrien CHENU on 1/23/24.
//

import Foundation

// Construit un objet URLComponents avec la base de l'API Unsplash
// Et un query item "client_id" avec la clé d'API retrouvé depuis PListManager
func unsplashApiBaseUrl() -> URLComponents {
    // Création de l'URLComponents avec les parties nécessaires
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "api.unsplash.com"
    urlComponents.path = "/photos"
    
    // Ajout du query item "client_id"
    let clientIdQueryItem = URLQueryItem(name: "client_id", value: ConfigurationManager.instance.plistDictionnary.clientId)
    urlComponents.queryItems = [clientIdQueryItem]

    return urlComponents
}

// Par défaut orderBy = "popular" et perPage = 10 -> Lisez la documentation de l'API pour comprendre les paramètres, vous pouvez aussi en ajouter d'autres si vous le souhaitez
func feedUrl(orderBy: String = "popular", perPage: Int = 10) -> URL? {
    var components = unsplashApiBaseUrl()  // Utilise la fonction précédemment définie pour la base de l'URL

    // Ajoute les paramètres spécifiques au feed
    let orderByQueryItem = URLQueryItem(name: "order_by", value: orderBy)
    let perPageQueryItem = URLQueryItem(name: "per_page", value: String(perPage))
    
    // Ajoute les query items au URLComponents
    components.queryItems?.append(orderByQueryItem)
    components.queryItems?.append(perPageQueryItem)

    // Crée l'URL à partir des URLComponents
    return components.url
}

