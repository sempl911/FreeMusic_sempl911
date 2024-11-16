//
//  SongDownloader.swift
//  FreeMusicApp
//
//  Created by Алексей Кустов on 12.11.2024.
//

import Foundation
import SQLite
import SwiftUI

class SongLoader {
    
    func downloadSong(from url: URL, fileName: String) {
        do {
                // Получаем путь к папке Documents
                let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                
                // Получаем имя приложения из Info.plist
                if let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String {
                    let appFolder = documentDirectory.appendingPathComponent(appName)
                    
                    if !FileManager.default.fileExists(atPath: appFolder.path) {
                        try FileManager.default.createDirectory(at: appFolder, withIntermediateDirectories: true, attributes: nil)
                    }
                    
                    let destination = appFolder.appendingPathComponent(fileName)
                    
                    if FileManager.default.fileExists(atPath: destination.path) {
                        print("File already exists at: \(destination)")
                        return // Файл уже существует, не загружаем
                    }
                    
                    // Скачиваем файл и сохраняем в папке с названием приложения
                    let task = URLSession.shared.downloadTask(with: url) { localURL, _, error in
                        if let localURL = localURL {
                            do {
                                try FileManager.default.moveItem(at: localURL, to: destination)
                                print("File saved to: \(destination)")
                            } catch {
                                print("Error saving file: \(error)")
                            }
                        }
                    }
                    task.resume()
                }
            } catch {
                print("Error setting up download directory: \(error)")
            }
    }

    
    func loadTrackById(trackId: String, db: Connection) -> String? {
        let query = TrackTable.tracksTable.filter(TrackTable.id == trackId)
        do {
            if let track = try db.pluck(query) {
                return track[TrackTable.audio]
            }
        } catch {
            print("Error fetching track by ID: \(error)")
        }
        return nil
    }
    
    func loadAllTracks(db: Connection) -> [DataStructs.resultTitleData] {
        var allTracks: [DataStructs.resultTitleData] = []
        let query = TrackTable.tracksTable
        
        do {
            for track in try db.prepare(query) {
                let song = DataStructs.resultTitleData(
                    id: track[TrackTable.id],
                    name: track[TrackTable.name],
                    artist_name: track[TrackTable.artistName],
                    album_image: track[TrackTable.albumImage],
                    audiodownload_allowed: true,
                    audio: track[TrackTable.audio],
                    audiodownload: track[TrackTable.audioDownload]
                )
                allTracks.append(song)
            }
        } catch {
            print("Error fetching all tracks: \(error)")
        }
        
        return allTracks
    }
}
