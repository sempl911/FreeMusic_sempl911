//  PlayURLMusic.swift
//  FreeMusicApp
//
//  Created by Алексей Кустов on 27.10.2024.


import Foundation
import AudioKit
import AVFoundation

protocol UrlMusicProtocol{
    func playOnlineMusic(urlString: String) async throws
}

class PlayURLMusic: ObservableObject, UrlMusicProtocol {
    
    private var audioPlayer: AVPlayer?
    
    func playOnlineMusic(urlString: String) async throws {
            do {
                guard let url = URL(string: urlString) else {
                    throw AudioPlayerError.invalidURL
                }
                
                audioPlayer = AVPlayer(url: url)
                await audioPlayer?.play()
                
            }catch {
                print("Ошибка воспроизведения музыки: \(error.localizedDescription)")
            }
        }
    
    func stopAudio(){
        audioPlayer?.pause()
    }
    
    enum AudioPlayerError: Error {
           case invalidURL
       }
}


