//
//  Character.swift
//  RickAndMorty
//
//  Created by Alpay Calalli on 20.10.25.
//

import Foundation

struct CharacterResponse: Codable {
   let info: CharacterResultInfo
   let results: [Character]
}

struct CharacterResultInfo: Codable {
   let count: Int
   let pages: Int
   let next: String?
   let prev: String?
}

struct Character: Codable, Identifiable, Hashable {
   let id: Int
   let name: String
   let status: String
   let species: String
   let type: String
   let gender: String
   let image: URL?
   let origin: Origin
   
   var isBookmarked: Bool = false
   
   enum CodingKeys: CodingKey {
      case id
      case name
      case status
      case species
      case type
      case gender
      case image
      case origin
   }

   struct Origin: Codable, Hashable {
      let name: String
      let url: String
   }
}
