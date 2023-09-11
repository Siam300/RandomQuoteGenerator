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

struct QuoteView: View {
    @StateObject private var viewModel = QuoteViewModel()
    
    var body: some View {
        VStack {
            if let quote = viewModel.quotes[safe: viewModel.currentIndex] {
                Text(quote.content)
                    .padding()
                Text("- " + quote.author)
                    .padding()
                    .foregroundColor(.gray)
            }
        }
        .gesture(
            DragGesture(minimumDistance: 50)
                .onEnded { value in
                    if value.translation.width < 0 {
                        viewModel.nextQuote()
                    } else if value.translation.width > 0 {
                        viewModel.previousQuote()
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

struct QuoteView_Previews: PreviewProvider {
    static var previews: some View {
        QuoteView()
    }
}
