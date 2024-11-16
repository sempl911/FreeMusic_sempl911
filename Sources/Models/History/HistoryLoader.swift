//
//  HistoryLoader.swift
//  FreeMusicApp
//
//  Created by Алексей Кустов on 04.11.2024.
//

import Foundation

class HistoryLoader{
    
    let historyManager = HistoryManager()
    
    func showHistory() -> [HistoryManager.HistorySong]{
        
        let playedSongs = historyManager.loadSongs()
          
        if playedSongs.count > 0 {
            return playedSongs
        }
        else{
            print ("No data avialabel")
            return []
        }
    }
    
    func clearHistory() {
        historyManager.saveSongs([])
        print("История очищена.")
    }
}
