//
//  BookmarkManager.swift
//  RickAndMorty
//
//  Created by Alpay Calalli on 21.10.25.
//

import Foundation

protocol BookmarkManagable {
   @discardableResult
   func toggle(_ character: Character) -> Bool
   
   func getBookmarks() -> [Character]
}

/*actor*/ class BookmarkManager: BookmarkManagable {
   private var bookmarks: [Character] = []
   
   @discardableResult
   func toggle(_ character: Character) -> Bool {
      if character.isBookmarked {
         removeBookmark(character)
         return false
      } else {
         bookmark(character)
         return true
      }
   }
   
   func getBookmarks() -> [Character] {
      bookmarks
   }
   
   private func bookmark(_ character: Character) {
      bookmarks.append(character)
   }
   
   private func removeBookmark(_ character: Character) {
      bookmarks.removeAll(where: { $0.id == character.id })
   }
}
