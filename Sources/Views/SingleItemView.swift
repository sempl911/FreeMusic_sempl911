//
//  SingleItemView.swift
//  FreeMusicApp
//
//  Created by Алексей Кустов on 26.10.2024.
//

import SwiftUI

struct SingleItemView: View {
    
    let song: DataStructs.resultTitleData

        var body: some View {
            HStack {
                if let url = URL(string: song.album_image) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .frame(width: 80, height: 80)
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        ProgressView()
                    }
                } else {
                    Image(systemName: "music.note")
                        .resizable()
                        .frame(width: 80, height: 80)
                }

                VStack(alignment: .leading) {
                    Text(song.artist_name)
                        .font(.headline)
                        .fontWeight(.bold)

                    Text(song.name)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .padding()
        }
}

struct SingleItemView_Previews: PreviewProvider {
    static var previews: some View {
        let mockSong = DataStructs.resultTitleData(
            id: "123",
            name: "same song",
            artist_name: "Sample Artist",
            album_image: "Sample Album",
            audiodownload_allowed: true,
            audio: "Some path", audiodownload: "Path to download"
        )
            SingleItemView(song: mockSong)
    }
}
