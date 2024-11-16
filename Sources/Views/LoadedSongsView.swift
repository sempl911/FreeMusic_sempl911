//
//  LoadedSongsView.swift
//  FreeMusicApp
//
//  Created by Алексей Кустов on 12.11.2024.
//

import SwiftUI

struct LoadedSongsView: View {
   
    let loaderSongViewModel = LoaderSongViewModel()
    @State var allSongs: [DataStructs.resultTitleData] = []
    var body: some View {
        VStack {
            List(allSongs, id: \.id) { song in
                NavigationLink(destination: PlayerView(song: song, songsTracks: allSongs)) {
                    SingleItemView(song: song)
                }
            }
        }
        .onAppear {
            allSongs = loaderSongViewModel.onAppierLoadSong()
        }
    }
}

#Preview {
    LoadedSongsView()
}
