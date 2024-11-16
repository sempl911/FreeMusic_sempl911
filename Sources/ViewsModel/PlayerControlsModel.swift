//
//  PlayerControls.swift
//  FreeMusicApp
//
//  Created by Алексей Кустов on 27.10.2024.
//

import Foundation
import SwiftUI
class PlayerControlsModel: ObservableObject {
    
    let historyManager = HistoryManager()
    var playerURLMusic = PlayURLMusic()
    @Published var isPlaying: Bool = false
    
    func playOnlineMusic(urlString: String, currentSong: DataStructs.resultTitleData) async throws {
        
        if isPlaying {
            stopOnlineMusic()
        } else
                {
            do
            {
                try await playerURLMusic.playOnlineMusic(urlString: urlString)
                DispatchQueue.main.async {
                               self.isPlaying = true
                           }
                saveInHistory(currentSong: currentSong)
            }
        }
        
    }
    
    func stopOnlineMusic() {
        playerURLMusic.stopAudio()
        DispatchQueue.main.async {
            self.isPlaying = false
                   }
    }
    
    func saveInHistory(currentSong: DataStructs.resultTitleData){
        let historyFomatSong = HistoryManager.HistorySong(id: currentSong.id, artistName: currentSong.artist_name, songName: currentSong.name, albumImg: currentSong.album_image, audioLink: currentSong.audio)
            
            historyManager.saveSong(historyFomatSong)
       // print("song \(historyFomatSong.songName) was saved")
    }
}
