//
//  GenreViewModel.swift
//  FreeMusicApp
//
//  Created by Алексей Кустов on 11.11.2024.
//

import Foundation

class GenreViewModel:ObservableObject{
    weak var songLoader : SongLoader?
    var sqlManager = SQLManager.shared
    var requestTitle = RequestTitle()
    weak var trackChanger : TrackChanger?
    var startSongs : [DataStructs.resultTitleData] = []
    var genre: String = ""
    
    func requestOnStartSongs(genre: String) async throws -> [DataStructs.resultTitleData]{
        
        await requestTitle.requestStartSongs(startSongCount: 40, genre: genre)
        
        if let songs = requestTitle.titleData {
            startSongs = songs
            trackChanger?.saveTracks(startSongs)
            startSongs = ShufleSongs(startSongs: startSongs)
            return startSongs
        } else {
            return []
        }
    }
    
    func ShufleSongs(startSongs: [DataStructs.resultTitleData]) -> [DataStructs.resultTitleData]{
        return startSongs.shuffled()
    }
    
    func downloadSong(currentSong: DataStructs.resultTitleData) {
                
        if let url = URL(string: currentSong.audiodownload) {
            songLoader?.downloadSong(from: url, fileName: currentSong.name)

            guard let db = sqlManager.db else {
                print("Database is not available")
                return
            }
            
            // Сохраняем данные о треке
            sqlManager.saveTrackMetadata(
                trackId: currentSong.id,
                name: currentSong.name,
                artistName: currentSong.artist_name,
                albumImage: currentSong.album_image,
                audio: currentSong.audio,
                audioDownload: currentSong.audiodownload
            )

        } else {
            print("Invalid URL string: \(currentSong.audiodownload)")
        }
    }

}
