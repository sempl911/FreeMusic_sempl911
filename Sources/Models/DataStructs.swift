//
//  DataStructs.swift
//  FreeMusicApp
//
//  Created by Алексей Кустов on 26.10.2024.
//

import Foundation

class DataStructs{
    struct resultTitle:Codable{
        let results: [resultTitleData]
    }
    struct singleResult:Codable{
        let singleResult: resultTitleData
    }
    struct resultTitleData:Codable, Equatable {
        let id: String
        let name: String
        let artist_name: String
        let album_image: String
        let audiodownload_allowed: Bool
        let audio: String
        let audiodownload: String
    }
}
