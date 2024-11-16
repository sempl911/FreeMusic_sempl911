//
//  TrackTable.swift
//  FreeMusicApp
//
//  Created by Алексей Кустов on 12.11.2024.
//

import SQLite

class TrackTable{
    static let tracksTable = Table("tracks")
    
    static let id = Expression<String>("id")
    static let name = Expression<String>("name")
    static let artistName = Expression<String>("artist_name")
    static let albumImage = Expression<String>("album_image")
    static let audio = Expression<String>("audio")
    static let audioDownload = Expression<String>("audiodownload")
    
    static func createTable(db: Connection) {
        do {
            try db.run(tracksTable.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
                t.column(name)
                t.column(artistName)
                t.column(albumImage)
                t.column(audio)
                t.column(audioDownload)
            })
            print("Table created or already exists.")
        } catch {
            print("Error creating table: \(error)")
        }
    }
}
