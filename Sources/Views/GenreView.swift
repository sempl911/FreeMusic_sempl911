//
//  GenreView.swift
//  FreeMusicApp
//
//  Created by Алексей Кустов on 11.11.2024.
//

import SwiftUI

struct GenreView: View {
    var genre:String
    let genreViewModel = GenreViewModel()
    @State var songs: [DataStructs.resultTitleData] = []
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack {
            
            Text("\(genre) style")
                .font(.title)
            
                   List(songs, id: \.id) { song in
                       NavigationLink(destination: PlayerView(song: song, songsTracks: songs)) {
                           SingleItemView(song: song)
                       }
                       .swipeActions {
                               Button(role: .destructive) {
                                   // Remove action
                                   print("\(song.name) удалён")
                               } label: {
                                   Label("Remove", systemImage: "trash")
                               }

                               Button {
                                   // Download action
                                   genreViewModel.downloadSong(currentSong: song)
                                   print("\(song.name) добавлен в избранное")
                               } label: {
                                   Label("Load", systemImage: "square.and.arrow.down")
                               }
                               .tint(.green) // Color favorite
                           }
                   }
               }
               .onAppear {
                   Task {
                       do {
                           // Получаем песни по жанру
                           songs = try await genreViewModel.requestOnStartSongs(genre: genre)
                       } catch {
                           print("Ошибка загрузки песен: \(error)")
                       }
                   }
               }
           }
       }

#Preview {
    GenreView(genre: "Rock")
}
