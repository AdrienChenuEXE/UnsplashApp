//
//  ContentView.swift
//  UnsplashApp
//
//  Created by Adrien CHENU on 1/23/24.
//

import SwiftUI


struct ContentView: View {
    @State var selectedPhoto: UnsplashModel?
    @State var isDataLoaded = false
    @StateObject var feedState = FeedState()
    
    let photoColumns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    let topicsRows = [
        GridItem(.flexible())
    ]
    
    func loadData() async {
        await feedState.fetchHomeFeed()
        await feedState.fetchHomeTopics()
        isDataLoaded = true
    }
    
    
    var body: some View {
        NavigationStack{
            VStack {
                Button(action: {
                    Task {
                        await loadData()
                    }
                }, label: {
                    Text("Load...")
                })
                HStack{
                    ScrollView(.horizontal) {
                        LazyHGrid(rows: topicsRows, spacing: 30) {
                            if !isDataLoaded {
                                ForEach(0..<10, id: \.self) { _ in
                                    VStack(alignment: .center) {
                                        Rectangle()
                                            .foregroundColor(.gray)
                                            .aspectRatio(contentMode: .fill)
                                            .shadow(radius: 5)
                                            .opacity(0.3)
                                            .frame(width: 100, height: 60)
                                            .cornerRadius(12)
                                        Rectangle()
                                            .foregroundColor(.gray)
                                            .aspectRatio(contentMode: .fill)
                                            .shadow(radius: 5)
                                            .opacity(0.5)
                                            .frame(width: 70, height: 15)
                                            .cornerRadius(3)
                                    }
                                }
                            } else {
                                ForEach(feedState.homeTopics, id: \.id) { topic in
                                    NavigationLink(destination: FeedTopicView(topic: topic)) {
                                        VStack(alignment: .center) {
                                            AsyncImage(url: URL(string: topic.coverPhoto.urls.small)) { image in
                                                image
                                                    .centerCropped()
                                                    .aspectRatio(contentMode: .fill)
                                                    .cornerRadius(12)
                                                    .shadow(radius: 5)
                                            } placeholder: {
                                                ProgressView()
                                            }
                                            .frame(width: 100, height: 60)
                                            .cornerRadius(12)

                                            Text(topic.title)
                                                .foregroundColor(.blue)
                                                .font(.caption)
                                                .multilineTextAlignment(.center)
                                                .padding(4)
                                        }
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                        .padding(.horizontal, 15)
                    }
                }.padding(.vertical, 0)
                ScrollView {
                    LazyVGrid(columns: photoColumns, spacing: 8) {
                        if !isDataLoaded {
                            ForEach(0..<12, id: \.self) { _ in
                                Rectangle()
                                    .foregroundColor(.gray)
                                    .aspectRatio(contentMode: .fill)
                                    .cornerRadius(12)
                                    .shadow(radius: 5)
                                    .opacity(0.3)
                            }
                        } else {
                            ForEach(feedState.homeFeed, id: \.id) { imageUrl in
                                Button(action: {
                                    selectedPhoto = imageUrl
                                }) {
                                    AsyncImage(url: URL(string: imageUrl.urls.small)) { image in
                                        image
                                            .centerCropped()
                                            .aspectRatio(contentMode: .fill)
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .cornerRadius(12)
                                    .shadow(radius: 5)
                                }
                            }
                        }
                    }
                }
                .navigationBarTitle("Feed", displayMode: .large)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal, 20)
            }
        }
        .sheet(item: $selectedPhoto) { photo in
            DetailsPhotoView(photo: photo)
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
