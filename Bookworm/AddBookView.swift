//
//  AddBookView.swift
//  Bookworm
//
//  Created by Paul Richardson on 22.08.2020.
//  Copyright © 2020 Paul Richardson. All rights reserved.
//

import SwiftUI

struct AddBookView: View {
	
	@Environment(\.managedObjectContext) var moc
	@Environment(\.presentationMode) var presentationMode
	
	@State private var title = ""
	@State private var author = ""
	@State private var rating = 3
	@State private var genre = ""
	@State private var review = ""
	
	private var isValid: Bool {
		if title.isEmpty || author.isEmpty || genre.isEmpty {
			return false
		}
		return true
	}
	
	let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]
	
	var body: some View {
		NavigationView {
			Form {
				Section {
					TextField("Name of book", text: $title)
					TextField("Author's name", text: $author)
					
					Picker("Genre", selection: $genre) {
						ForEach(genres, id: \.self) {
							Text($0)
						}
					}
					
				}
				
				Section {
					RatingView(rating: $rating)
					TextField("Write a review", text: $review)
				}
				
				Section {
					Button("Save") {
						let newBook = Book(context: self.moc)
						newBook.title = self.title
						newBook.author = self.author
						newBook.rating = Int16(self.rating)
						newBook.genre = self.genre
						newBook.review = self.review
						newBook.date = Date()
						
						try? self.moc.save()
						
						self.presentationMode.wrappedValue.dismiss()
						
					}
					.disabled(isValid == false)
				}
			}
		.navigationBarTitle("Add book")
		}
	}
}

struct AddBookView_Previews: PreviewProvider {
	static var previews: some View {
		AddBookView()
	}
}
