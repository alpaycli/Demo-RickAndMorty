//
//  BookmarkManager.swift
//  RickAndMorty
//
//  Created by Alpay Calalli on 21.10.25.
//

import Foundation

actor BookmarkManager {
   var bookmarks: [Character] = []
   
   func isBookmarked(character: Character) -> Bool {
      bookmarks.contains(character)
   }
   
   @discardableResult
   func toggle(_ character: Character) -> Bool {
      if isBookmarked(character: character) {
         removeBookmark(character)
         return false
      } else {
         bookmark(character)
         return true
      }
   }
   
   private func bookmark(_ character: Character) {
      bookmarks.append(character)
   }
   
   private func removeBookmark(_ character: Character) {
      bookmarks.removeAll(where: { $0.id == character.id })
   }
}
