//
//  RequestTitle.swift
//  FreeMusicApp
//
//  Created by Алексей Кустов on 26.10.2024.
//

import Foundation

class RequestTitle : ObservableObject {
    
    let apiKeyJamendo: String = "721c0bf0"
    var titleData: [DataStructs.resultTitleData]?
    var resultsForSingleSong: [DataStructs.resultTitleData]?
    
    func requestStartSongs(startSongCount: Int, genre: String) async {
        guard let url = URL(string: "https://api.jamendo.com/v3.0/tracks?client_id=\(apiKeyJamendo)&format=json&limit=\(startSongCount)&tags=\(genre)") else {
            print("Wrong path")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodeData = try JSONDecoder().decode(DataStructs.resultTitle.self, from: data)
            titleData = decodeData.results // Save title songs
        } catch {
            print("Error: \(error)")
        }
    }
    
    func requestFromHistory(song: HistoryManager.HistorySong) async throws -> DataStructs.resultTitleData {
        guard let url = URL( string: "https://api.jamendo.com/v3.0/tracks?client_id=\(apiKeyJamendo)&id=\(song.id)")
        else {
            print ("Can't finde song in DB")
            throw URLError(.badURL)
        }
        
        do{
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodeData = try JSONDecoder().decode(DataStructs.resultTitle.self, from: data)
            
            resultsForSingleSong = decodeData.results
            
            guard let singleSong = decodeData.results.first else {
                print("No song found in results.")
                throw NSError(domain: "DataError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Song not found in results"])
            }
            print("selected song: " + singleSong.name)
            return singleSong
            
        }catch{
            print("Error: \(error)")
            throw error
        }
    }

    func requestSongsForHistory (startingSong:DataStructs.resultTitleData, count: Int) async throws -> [DataStructs.resultTitleData] {
        
        
        guard let startingSongId = Int(startingSong.id) else {
                print("Invalid song ID, cannot convert to integer.")
                throw URLError(.badURL)  // Или выберите соответствующую ошибку
            }
            
            // Рассчитываем диапазоны для загрузки песен
            let lowerId = max(startingSongId - 10, 0)  // не даем id стать отрицательным
            let upperId = startingSongId + 10
            
            // Формируем URL для загрузки песен до и после текущей
            guard let lowerUrl = URL(string: "https://api.jamendo.com/v3.0/tracks/?client_id=\(apiKeyJamendo)&id=\(lowerId)&limit=\(count)"),
                  let upperUrl = URL(string: "https://api.jamendo.com/v3.0/tracks/?client_id=\(apiKeyJamendo)&id=\(upperId)&limit=\(count)") else {
                print("Invalid URL")
                throw URLError(.badURL)
            }
            
            do {
                // Запрашиваем данные по обеим частям
                async let lowerData = URLSession.shared.data(from: lowerUrl)
                async let upperData = URLSession.shared.data(from: upperUrl)
                
                let (lowerResponse, _) = try await lowerData
                let (upperResponse, _) = try await upperData
                
                // Декодируем полученные данные
                let lowerDecodeData = try JSONDecoder().decode(DataStructs.resultTitle.self, from: lowerResponse)
                let upperDecodeData = try JSONDecoder().decode(DataStructs.resultTitle.self, from: upperResponse)
                
                // Объединяем полученные данные
                let allSongs = lowerDecodeData.results + upperDecodeData.results
                print("New gotten songs list count: \(allSongs.count)")
                return allSongs
            } catch {
                print("Error: \(error)")
                throw error
            }
        
//        guard let url = URL(string: "https://api.jamendo.com/v3.0/tracks/?client_id=\(apiKeyJamendo)&id=\(startingSong.id)&limit=\(count)") else {
//                print("Invalid URL")
//                throw URLError(.badURL)
//            }
//        
//        do {
//            let (data, _) = try await URLSession.shared.data(from: url)
//            let decodeData = try JSONDecoder().decode(DataStructs.resultTitle.self, from: data)
//            return decodeData.results // Save title songs
//        } catch {
//            print("Error: \(error)")
//            throw error
//        }
    }
}

