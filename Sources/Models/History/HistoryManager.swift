//
//  HistoryManager.swift
//  FreeMusicApp
//
//  Created by Алексей Кустов on 04.11.2024.
//

import Foundation

class HistoryManager{
    
    struct HistorySong: Codable, Hashable {
        let id: String
        let artistName: String
        let songName: String
        let albumImg: String
        let audioLink:String
    }
    
    private let fileName = "history.json"
    private var maxSongs: Int = 10
    
    private var fileUrl: URL{
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent(fileName)
    }
    
    func saveSong(_ song: HistorySong) {
        var savedSongs = loadSongs()
        
        if !savedSongs.contains(where: { $0.id == song.id }) {
            
            if savedSongs.count >= maxSongs {
                savedSongs.removeFirst()
            }
            
            savedSongs.append(song)
            saveSongs(savedSongs)
        } else {
            print("Песня с id \(song.id) уже в истории.")
        }
    }
    
    func saveSongs(_ songs:[HistorySong]){
        do{
            let encoder = JSONEncoder()
            let data = try encoder.encode(songs)
            try data.write(to: fileUrl)
        }
        catch{
            print("Ошибка сохранения данных: \(error)")
        }
    }
    
    func loadSongs() -> [HistorySong] {
        do{
            let data = try Data(contentsOf: fileUrl)
            let decoder = JSONDecoder()
            return try decoder.decode([HistorySong].self, from: data)
        }catch{
            print("Ошибка загрузки данных: \(error)")
            return []
        }
    }
    
    func setMaxSongs(_ max: Int) {
        maxSongs = max
    }
    
    func clearHistory() {
        saveSongs([])
        print("История очищена.")
    }
}
