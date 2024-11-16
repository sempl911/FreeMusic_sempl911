//
//  PlayerView.swift
//  FreeMusicApp
//
//  Created by Алексей Кустов on 26.10.2024.
//

import SwiftUI

struct PlayerView: View {
    
    @StateObject var playerControlsModel = PlayerControlsModel()
    @State var song: DataStructs.resultTitleData
    var songsTracks: [DataStructs.resultTitleData]
    
       var body: some View {
           VStack {
               showUrlImage(imageLink: song.album_image)
                   .padding()
               Text("Artist: \(song.artist_name)")
                   .font(.headline)
                   //.padding()
               
               Text("Song: \(song.name)")
                   .font(.subheadline)
                   .padding()

               Spacer()
                   .padding()
               FlashView()
               AnalyzerView(playerControlsModel: playerControlsModel)
               Spacer()
               PlayerControlsView(playerControlViewModel: playerControlsModel, currentSong: $song, songsTracks: songsTracks)
                   .padding(.bottom, 100)
           }
           .navigationBarTitleDisplayMode(.inline)
           .padding(.top, 20)
           .padding(.horizontal) 
           .background(Color.black.edgesIgnoringSafeArea(.all))
       }
    
    func showUrlImage(imageLink: String) -> some View {
        if let url = URL(string: imageLink) {
            return AnyView(
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .frame(width: 230, height: 230)
                        .aspectRatio(contentMode: .fill)
                        .cornerRadius(8)
                } placeholder: {
                    ProgressView()
                }
            )
        } else {
            return AnyView(
                Image(systemName: "music.note")
                    .resizable()
                    .frame(width: 300, height: 300)
            )
        }
    }
}

#Preview {
    PlayerView(song: DataStructs.resultTitleData(
            id: "1",
            name: "Sample Song",
            artist_name: "Sample Artist",
            album_image: "https://example.com/image.jpg",
            audiodownload_allowed: true,
            audio: "https://example.com/audio.mp3",
            audiodownload: "https://example.com/download.mp3"
    ), songsTracks: [])
}
