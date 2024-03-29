//
//  DetailView.swift
//  Bookworm
//
//  Created by Paul Richardson on 23.08.2020.
//  Copyright © 2020 Paul Richardson. All rights reserved.
//

import SwiftUI
import CoreData

struct DetailView: View {
	
	@Environment(\.managedObjectContext) var moc
	@Environment(\.presentationMode) var presentationMode
	@State private var showingDeleteAlert = false
	
	let book: Book
	
	var formattedDate: String {
		if let date = book.date {
			let formatter = DateFormatter()
			formatter.dateStyle = .long
			return formatter.string(from: date)
		} else {
			return "Unknown Date"
		}
	}
	
	var body: some View {
		GeometryReader { geometry in
			VStack {
				ZStack(alignment: .bottomTrailing) {
					Image(self.book.genre ?? "Fantasy")
						.frame(maxWidth: geometry.size.width)
					
					Text(self.book.genre?.uppercased() ?? "FANTASY")
						.font(.caption)
						.fontWeight(.black)
						.padding(8)
						.foregroundColor(.white)
						.background(Color.black.opacity(0.75))
						.clipShape(Capsule())
						.offset(x: -5, y: -5)
				}
				
				Text(self.book.author ?? "Unknown author")
					.font(.title)
					.foregroundColor(.secondary)
				
				Text(self.book.review ?? "No review")
					.padding()
				
				RatingView(rating: .constant(Int(self.book.rating)))
					.font(.largeTitle)
				
				Text(self.formattedDate)
					.font(.subheadline)
					.padding()
				
				Spacer()
			}
		}
		.navigationBarTitle(Text(book.title ?? "Unknown Book"), displayMode: .inline)
		.navigationBarItems(trailing: Button(action: {
			self.showingDeleteAlert = true
		}) {
			Image(systemName: "trash")
		})
			.alert(isPresented: $showingDeleteAlert) {
				Alert(title: Text("Delete book"), message: Text("Are you sure?"), primaryButton: .destructive(Text("Delete")) {
					self.deleteBook()
					}, secondaryButton: .cancel()
				)
		}
	}
	
	func deleteBook() {
		moc.delete(book)
		try? moc.save()
		presentationMode.wrappedValue.dismiss()
	}
		
}

struct DetailView_Previews: PreviewProvider {
	static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
	
	static var previews: some View {
		let book = Book(context: moc)
		book.title = "Test book"
		book.author = "Test author"
		book.genre = "Fantasy"
		book.rating = 4
		book.review = "This was a great book; I really enjoyed it."
		return NavigationView {
			DetailView(book: book)
		}
	}
}
