//
//  FeedTopicView.swift
//  UnsplashApp
//
//  Created by Adrien CHENU on 1/24/24.
//

import SwiftUI

struct FeedTopicView: View {
    @State var isDataLoaded = false    
    @State var selectedPhoto: UnsplashModel?

    @StateObject var feedState = FeedState()
    @State var topic : UnsplashTopic
    
    let photoColumns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    func loadData() async {
        await feedState.fetchTopicFeed(id: topic.id)
        isDataLoaded = true
    }

    var body: some View {
        NavigationStack{
            VStack{
                Button(action: {
                    Task {
                        await loadData()
                    }
                }, label: {
                    Text("Load photos for topic")
                })
                
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
                            ForEach(feedState.topicFeed, id: \.id) { image in
                                NavigationLink(destination: DetailsPhotoView(photo: image)) {
                                    Button(action: {
                                        selectedPhoto = image
                                    }) {
                                        AsyncImage(url: URL(string: image.urls.small)) { image in
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
                }
                .navigationBarTitle(topic.title, displayMode: .large)
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
    FeedTopicView(
        topic: UnsplashTopic(
            id: "",
            slug: "",
            title: "MyTitle",
            description: "",
            coverPhoto: CoverPhoto(
                id: "",
                slug: "",
                urls: Urls(
                    raw: "",
                    full: "",
                    regular: "",
                    small: "",
                    thumb: "",
                    smallS3: ""
                )
            )
        )
    )
}
