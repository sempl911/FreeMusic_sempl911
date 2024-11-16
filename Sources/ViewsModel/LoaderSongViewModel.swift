//
//  LoaderSongViewModel.swift
//  FreeMusicApp
//
//  Created by Алексей Кустов on 12.11.2024.
//

import Foundation
import SQLite

class LoaderSongViewModel: ObservableObject{
        
    let songLoader = SongLoader()
    var sqlManager = SQLManager.shared
    
    func onAppierLoadSong() -> [DataStructs.resultTitleData]{
                
        guard let db = sqlManager.db else {
               print("Database connection is nil")
               return []
           }
        let trackCount = getTrackCount(db: db)
            print("Total tracks in database: \(trackCount)")
        
        print("Downloaded songs: \(songLoader.loadAllTracks(db: db).count)")

        return songLoader.loadAllTracks(db: db)
    }
    
    func getTrackCount(db: Connection) -> Int {
        let query = TrackTable.tracksTable
        do {
            let count = try db.scalar(query.count)
            return count
        } catch {
            print("Error counting records: \(error)")
            return 0
        }
    }
}
