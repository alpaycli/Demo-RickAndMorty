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
//   let origin: String
   
//   enum Status: String, Codable {
//      case alive = "Alive"
//      case dead = "Dead"
//      case unknown = "unknown"
//   }
//   
//   enum Gender: String, Codable {
//      case female = ""
//      case male = "Male"
//      case genderless = "Genderless"
//      case unknown = "unknown"
//   }
}
