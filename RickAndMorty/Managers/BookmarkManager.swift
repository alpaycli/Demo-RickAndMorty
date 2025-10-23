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
         bookmark(character)
         return true
      } else {
         removeBookmark(character)
         return false
      }
   }
   
   func getBookmarks() -> [Character] {
      print(bookmarks.map({ $0.isBookmarked }))
      return bookmarks
   }
   
   private func bookmark(_ character: Character) {
      bookmarks.append(character)
   }
   
   private func removeBookmark(_ character: Character) {
      bookmarks.removeAll(where: { $0.id == character.id })
   }
}
