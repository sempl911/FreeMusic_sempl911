//
//  StartView.swift
//  FreeMusicApp
//
//  Created by Алексей Кустов on 03.11.2024.
//

import SwiftUI

struct StartView: View {
    
    let historyLoader = HistoryLoader()
    let startViewModel = StartViewModel()
    var sqlManager = SQLManager.shared
    
    @State private var historySongs: [HistoryManager.HistorySong] = []
    @State private var currentSong: DataStructs.resultTitleData? = nil
    @State private var songList: [DataStructs.resultTitleData] = []
    @State private var isPlayerActive = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Free online player")
                    .font(.largeTitle)
                    .bold()
                    .opacity(1)
                
                VStack {
                    HStack {
                        Spacer()
                        startViewModel.libraryTransitionButton(imageName: "RockLogo", text: "Rock", destination: GenreView(genre: "Rock"))
                        Spacer()
                        startViewModel.libraryTransitionButton(imageName: "ClassicLogo", text: "Classic", destination: GenreView(genre: "Classic"))
                        Spacer()
                    }
                }
                .padding(.top)
                
                VStack {
                    HStack {
                        Spacer()
                        startViewModel.libraryTransitionButton(imageName: "RnbLogo", text: "rnb", destination: GenreView(genre: "RNB"))
                        Spacer()
                        startViewModel.libraryTransitionButton(imageName: "ElectroLogo", text: "Electonic", destination: GenreView(genre: "electronic"))
                        Spacer()
                    }
                }
                
                NavigationLink(destination: LoadedSongsView()) {
                                   HStack {
                                       Image(systemName: "list.bullet.indent")
                                           .font(.title)
                                       Text("Loaded Tracks")
                                           .font(.title2)
                                   }
                                   .padding()
                                   .background(Color.blue)
                                   .foregroundColor(.white)
                                   .cornerRadius(10)
                               }
                               .padding(.top)
            }
        }
    }
}
struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
           // .previewDevice("iPhone 13")
    }
}


//MARK: - history view and load
/*
 VStack{
     Text("Last playing")
         .font(.headline)
     ZStack {
         RoundedRectangle(cornerRadius: 15)
             .strokeBorder(
                 AngularGradient(
                     gradient: Gradient(colors: [Color.gray, Color.gray, Color.gray]),
                     center: .center,
                     startAngle: .degrees(0),
                     endAngle: .degrees(360)
                 )
             )
             .background(Color.black)
             .frame(width: 300)//, height: 200)
         
         ScrollView {
             VStack(spacing: 10) {
                 
                 if historySongs.count <= 0{
                     Text("You haven't listened to any songs yet.")
                         .multilineTextAlignment(.center)
                         .frame(maxWidth: .infinity)
                         .padding()
                 }
                 else{
                     ForEach(historySongs, id: \.self) { song in
                         HStack{
                             startViewModel.showUrlImage(imageLink: song.albumImg)
                             StartViewModel.SongRow(artistName: song.artistName, songName: song.songName)
                             Button(action: {
                                 print("Player transition, song id \(song.id)")
                                 // to start view model!
                                 Task {
                                     do {
                                         let song = try await startViewModel.playFromHistory(song: song)
                                         let songs = try await startViewModel.getSongsForHistory(startSong: song, count: 20)
                                         
                                         await MainActor.run {
                                             self.currentSong = song
                                             self.songList = songs
                                             self.isPlayerActive = true
                                         }
                                     } catch {
                                         print("Error: \(error)")
                                     }
                                 }
                                 
                             }) {
                                 Image(systemName:"play")
                                     .resizable()
                                     .foregroundColor(.red)
                                     .padding(5)
                                     .frame(width: 30, height: 30, alignment: .center)
                             }
                             
                         }
                     }
                 }
             }
             .padding()
             .frame(width: 290)//, height: 200)
             .onAppear(){
                 //historyLoader.clearHistory()
                 historySongs = historyLoader.showHistory()
             }
         }
     }
     .padding()
     .padding(.top)
     Spacer()
     startViewModel.gradientButton
         .padding(.bottom, 30)
     
     NavigationLink(
         destination: Group {
             if let unwrappedSong = currentSong {
                 AnyView(PlayerView(song: unwrappedSong, songsTracks: songList))
             } else {
                 AnyView(Text("No song available").padding())
             }
         },
         isActive: $isPlayerActive
     ) {
         EmptyView()
     }
     
 }
 .padding()
 
}
 */
