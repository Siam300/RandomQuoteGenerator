//
//  QouteView.swift
//  quoteGenerator
//
//  Created by Auto on 9/10/23.
//

import SwiftUI

extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

struct aPicture: Identifiable {
    var id: Int
    var name: String
    var imageName: String
}

struct QuoteView: View {
    @StateObject private var viewModel = QuoteViewModel()
    @State var random : Int = 0
    
    let pictures = [
        aPicture(id: 0, name: "1", imageName: "1"),
        aPicture(id: 1, name: "2", imageName: "2"),
        aPicture(id: 2, name: "3", imageName: "3"),
        aPicture(id: 3, name: "4", imageName: "4"),
        aPicture(id: 4, name: "5", imageName: "5"),
        aPicture(id: 5, name: "6", imageName: "6"),
    ]
    
    var body: some View {
        ZStack {
            Image(pictures[self.random].imageName)
                .resizable()
                .scaledToFit()
                .aspectRatio(contentMode: .fill)
                .clipped()
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 20) {
                if let quote = viewModel.quotes[safe: viewModel.currentIndex] {
                    Text(quote.content)
                        .frame(maxWidth: 340)
                        .padding(.all)
                        .background(Color.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.all)
                    Text("- " + quote.author)
                        .foregroundColor(.gray)
                        .fontWeight(.heavy)
                        .padding(.all)
                }
            }
            .padding(.all)
            .gesture(
                DragGesture(minimumDistance: 50)
                    .onEnded { value in
                        if value.translation.width < 0 {
                            viewModel.nextQuote()
                            self.random = Int.random(in: 0..<self.pictures.count)
                        } else if value.translation.width > 0 {
                            viewModel.previousQuote()
                            self.random = Int.random(in: 0..<self.pictures.count)
                        }
                    }
            )
            .onAppear {
                if viewModel.quotes.isEmpty {
                    viewModel.getData()
                }
            }
        }
    }
}

struct QuoteView_Previews: PreviewProvider {
    static var previews: some View {
        QuoteView()
    }
}
