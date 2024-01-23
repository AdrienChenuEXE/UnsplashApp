//
//  ContentView.swift
//  UnsplashApp
//
//  Created by Adrien CHENU on 1/23/24.
//

import SwiftUI

struct ContentView: View {
    // Déclaration d'une variable d'état, une fois remplie, elle va modifier la vue
    @State var imageList: [UnsplashModel] = []
    
    // Déclaration d'une fonction asynchrone
    func loadData() async {
        // Créez une URL avec la clé d'API
        let url = URL(string: "https://api.unsplash.com/photos?client_id=\(ConfigurationManager.instance.plistDictionnary.clientId)")!
        
        do {
            // Créez une requête avec cette URL
            let request = URLRequest(url: url)
            
            // Faites l'appel réseau
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Transformez les données en JSON
            let deserializedData = try JSONDecoder().decode([UnsplashModel].self, from: data)
            
            // Mettez à jour l'état de la vue
            imageList = deserializedData
            
        } catch {
            print("Error: \(error)")
        }
    }
    
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    var body: some View {
        NavigationView {
            VStack{
                Button(action: {
                    Task {
                        await loadData()
                    }
                }, label: {
                    Text("Load Data")
                })
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 8) {
                        ForEach(imageList, id: \.id) { imageUrl in
                            AsyncImage(url: URL(string: imageUrl.urls.small)) { image in
                                image
                                    .centerCropped()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                ProgressView()
                            }
                            .shadow(radius: 5)
                        }
                    }
                }
                .navigationBarTitle("Feed", displayMode: .large)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal, 20)
            }
        }
    }
}

#Preview {
    ContentView()
}

extension Image {
    func centerCropped() -> some View {
        GeometryReader { geo in
            self
                .resizable()
                .scaledToFill()
                .frame(width: geo.size.width, height: geo.size.height)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .clipped()
        }
    }
}
