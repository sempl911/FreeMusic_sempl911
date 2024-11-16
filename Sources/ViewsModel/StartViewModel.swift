//
//  StartViewModel.swift
//  FreeMusicApp
//
//  Created by Алексей Кустов on 04.11.2024.
//

import Foundation
import SwiftUI

class StartViewModel : Observable {
    
    weak var requestTitle : RequestTitle?
    
    enum SongError: Error {
        case invalidSongID
    }
    
    func showUrlImage(imageLink: String) -> some View {
        if let url = URL(string: imageLink) {
            return AnyView(
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .frame(width: 50, height: 50)
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
    @MainActor
    func playFromHistory(song:HistoryManager.HistorySong) async throws -> DataStructs.resultTitleData {
        guard let requestTitle = requestTitle else {
                    print("Error: requestTitle is nil")
                    throw SongError.invalidSongID
                }
                
                do {
                    let songToPlay = try await requestTitle.requestFromHistory(song: song)
                    return songToPlay
                } catch {
                    print("Error: Incorrect ID or failed request, check RequestTitle")
                    throw SongError.invalidSongID
            }
    }
    @MainActor
    func getSongsForHistory(startSong: DataStructs.resultTitleData, count: Int) async throws -> [DataStructs.resultTitleData] {
        guard let requestTitle = requestTitle else {
            print("Error: requestTitle is nil")
            throw SongError.invalidSongID
        }
        
        guard let songsForHistory = try? await requestTitle.requestSongsForHistory(startingSong: startSong, count: count) else {
            print("Can't receive songs")
            throw URLError(.badURL)
        }
        
        print("Loaded songs count: \(songsForHistory.count)")
        return songsForHistory
    }
    
    var gradientButton: some View {
        Button(action: {
            print("Красивая кнопка нажата")
        }) {
            Text("Just Play")
                .font(.title)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.gray, Color.black]),
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .cornerRadius(15)
        .shadow(color: .gray.opacity(0.3), radius: 10, x: 0, y: 5)
        .padding(.horizontal, 20)
    }
    
    func libraryTransitionButton<Destination: View>(imageName: String, text: String, destination: Destination) -> some View {
        NavigationLink(destination: destination) {
               ZStack(alignment: .bottom) {
                   Image(imageName)
                       .resizable()
                       .scaledToFit()
                       .frame(width: 170, height: 140)
                       .cornerRadius(30)
                   
                   // Наложение текста на изображение
                   Text(text)
                       .foregroundColor(Color.white)
                       .bold()
                       .font(.title3)
                       .padding()
                       .background(
                           Color.black.opacity(0.6) // Добавляет полупрозрачный фон под текстом
                               .cornerRadius(10)
                               .padding(.horizontal, 5)
                       )
                       .padding(.bottom, 10) // Отступ текста от нижней границы изображения
               }
           }
    }
    
    
    struct SongRow: View {
        
        var artistName: String
        var songName: String
        
        var body: some View {
            HStack{
                
                VStack(alignment: .leading) {
                    Text(artistName) // Имя артиста
                        .foregroundColor(.white)
                        .font(.headline)
                    Text(songName.prefix(10) + (songName.count > 10 ? "..." : ""))
                        .foregroundColor(.gray)
                        .font(.subheadline)
                }
                .padding(.leading, 10)
                
                Spacer()
                
            }
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
            .frame(maxWidth: .infinity)
        }
    }
}
