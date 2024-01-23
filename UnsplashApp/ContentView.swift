//
//  ContentView.swift
//  UnsplashApp
//
//  Created by Adrien CHENU on 1/23/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var feedState = FeedState()

    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    var body: some View {
        NavigationView {
            VStack{
                Button(action: {
                    Task {
                        await feedState.fetchHomeFeed()
                    }
                }, label: {
                    Text("Load Data")
                })
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 8) {
                        ForEach(feedState.homeFeed ?? [], id: \.id) { imageUrl in
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
