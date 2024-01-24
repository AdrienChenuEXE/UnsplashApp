//
//  DetailsPhotoView.swift
//  UnsplashApp
//
//  Created by Adrien CHENU on 1/24/24.
//

import SwiftUI

struct DetailsPhotoView: View {
    @State var photo: UnsplashModel

    // for picker selection and image resizing
    enum PickerSelection: Int {
        case regular = 0
        case full = 1
        case small = 2
    }
    @State private var selectedPickerItem: PickerSelection = .full
    @State private var imageURL: URL?
   
    // Sizes for different picker selections
    private let regularSize: CGFloat = 200
    private let fullSize: CGFloat = 400
    private let smallSize: CGFloat = 100
    @State private var imageSize: CGFloat = 400
    
    var body: some View {
        VStack {
            HStack {
                Text("Une image de")
                    .font(.headline)
                Link("@\(photo.user.username)", destination: URL(string: photo.user.links.html)!)
                    .font(.headline)

                if let profileImageURL = URL(string: photo.user.profileImage.medium) {
                    AsyncImage(url: profileImageURL) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                            .padding()
                    } placeholder: {
                        ProgressView()
                    }
                }
            }

            Picker(selection: $selectedPickerItem, label: Text("")) {
                Text("Regular").tag(PickerSelection.regular)
                Text("Full").tag(PickerSelection.full)
                Text("Small").tag(PickerSelection.small)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 20)
            .onChange(of: selectedPickerItem) { _ in
                switch selectedPickerItem {
                case .regular:
                    imageSize = regularSize
                    imageURL = URL(string: photo.urls.regular)
                case .full:
                    imageSize = fullSize
                    imageURL = URL(string: photo.urls.full)
                case .small:
                    imageSize = smallSize
                    imageURL = URL(string: photo.urls.small)
                }
            }

            Spacer()

            AsyncImage(url: imageURL ?? URL(string: photo.urls.full)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: imageSize, height: imageSize)
            } placeholder: {
                ProgressView()
            }

            Spacer()

            Button(action: {
                guard let imageUrl = imageURL else {
                    return
                }

                getImage(from: imageUrl) { (image) in
                    if let image = image {
                        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                    } else {
                        print("Failed to load image for saving")
                    }
                }
            }) {
                Label("Télécharger", systemImage: "arrow.up.square")
                    .font(.headline)
                    .padding()
                    .cornerRadius(10)
            }
        }
    }
}

func getImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
    URLSession.shared.dataTask(with: url) { (data, response, error) in
        if let data = data {
            // Convert data to UIImage
            if let image = UIImage(data: data) {
                // Call the completion handler with the image
                completion(image)
            } else {
                completion(nil)
            }
        } else {
            completion(nil)
        }
    }.resume()
}

/* DetailsPhotoView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsPhotoView(
            photo: UnsplashModel(
                id: "",
                slug: "",
                urls: Urls(
                    raw: "",
                    full: "https://images.unsplash.com/photo-1682686581264-c47e25e61d95?crop=entropy\\u0026cs=srgb\\u0026fm=jpg\\u0026ixid=M3w1NTc1NTR8MXwxfGFsbHwxfHx8fHx8Mnx8MTcwNjA5Mjk4MHw\\u0026ixlib=rb-4.0.3\\u0026q=85",
                    regular: "",
                    small: "",
                    thumb: "",
                    smallS3: ""
                ),
                user: User(
                    id: "",
                    name: "L'auteur",
                    username: "auteur",
                    links: Links(
                        html: ""
                    ),
                    profileImage: ProfileImage(
                        small: "",
                        medium: "",
                        large: ""
                    )
                )
            )
        )
    }
}
*/
