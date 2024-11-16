//
//  SQLManager.swift
//  FreeMusicApp
//
//  Created by Алексей Кустов on 12.11.2024.
//

import Foundation
import SQLite

class SQLManager: ObservableObject {
    
    static let shared = SQLManager()  // Синглтон для глобального доступа
    var db: Connection?
    
    private init() {}  // Приватный инициализатор, чтобы не создать несколько экземпляров
    
    func setupDatabase() {
        do {
            // Получаем путь к папке Library/Application Support
            let libraryDirectory = try FileManager.default.url(for: .libraryDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            
            // Папка для вашего приложения
            let appSupportDirectory = libraryDirectory.appendingPathComponent("Application Support")
            
            // Проверка, существует ли директория
            let isDir = (try? appSupportDirectory.resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory ?? false
            if !isDir {
                try FileManager.default.createDirectory(at: appSupportDirectory, withIntermediateDirectories: true, attributes: nil)
                print("Directory created at: \(appSupportDirectory.path)")
            }
            
            // Путь к базе данных
            let fileURL = appSupportDirectory.appendingPathComponent("tracksDb.sqlite3")
            
            // Подключение к базе данных
            db = try Connection(fileURL.path)
            
            // Создание таблицы, если она еще не существует
            if let db = db {
                TrackTable.createTable(db: db)
                print("Database setup successful at: \(fileURL.path)")  // Для проверки пути
            } else {
                print("Failed to initialize the database.")
            }
            
        } catch {
            print("Error setting up database: \(error)")
        }
    }
    
    // Сохранение данных о треке
    func saveTrackMetadata(trackId: String, name: String, artistName: String, albumImage: String, audio: String, audioDownload: String) {
        guard let db = db else {
            print("Database not initialized")
            return
        }
        
        let insert = TrackTable.tracksTable.insert(
            TrackTable.id <- trackId,
            TrackTable.name <- name,
            TrackTable.artistName <- artistName,
            TrackTable.albumImage <- albumImage,
            TrackTable.audio <- audio,
            TrackTable.audioDownload <- audioDownload
        )
        
        do {
            try db.run(insert)
            print("Track saved to database")
        } catch {
            print("Error saving track metadata: \(error)")
        }
    }
    
    func deleteAllTracks() {
        guard let db = db else {
            print("Database not initialized")
            return
        }
        
        do {
            let delete = TrackTable.tracksTable.delete()
            try db.run(delete)
            print("All tracks deleted from database")
        } catch {
            print("Error deleting all tracks: \(error)")
        }
    }
}
