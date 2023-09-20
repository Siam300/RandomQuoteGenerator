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
    @StateObject private var viewModel = QuoteViewModel(pictures: [
        aPicture(id: 0, name: "1", imageName: "1"),
        aPicture(id: 1, name: "2", imageName: "2"),
        aPicture(id: 2, name: "3", imageName: "3"),
        aPicture(id: 3, name: "4", imageName: "4"),
        aPicture(id: 4, name: "5", imageName: "5"),
        aPicture(id: 5, name: "6", imageName: "6"),
        aPicture(id: 6, name: "7", imageName: "7"),
        aPicture(id: 7, name: "8", imageName: "8"),
        aPicture(id: 8, name: "9", imageName: "9"),
        aPicture(id: 9, name: "10", imageName: "10"),
        aPicture(id: 10, name: "11", imageName: "11"),
        aPicture(id: 11, name: "12", imageName: "12"),
        aPicture(id: 12, name: "13", imageName: "12"),
        aPicture(id: 13, name: "14", imageName: "14"),
        aPicture(id: 14, name: "15", imageName: "15"),
        aPicture(id: 15, name: "16", imageName: "16"),
        aPicture(id: 16, name: "17", imageName: "17"),
        aPicture(id: 17, name: "18", imageName: "18"),
        aPicture(id: 18, name: "19", imageName: "19"),
    ])
    @State private var offset: CGSize = .zero
    @State private var random = 0
    
    var body: some View {
        ZStack {
            Color("bcolor")
                .edgesIgnoringSafeArea(.all)
            ZStack {
                quoteImage()
                Color("bcolor").opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                VStack(spacing: 20) {
                    Spacer()
                    if let quote = viewModel.quotes[safe: viewModel.currentIndex] {
                        quoteText(for: quote)
                        authorText(for: quote)
                    }
                    Spacer()
                }
            }
            .padding(.all)
            .offset(offset)
            .scaleEffect(getScaleAmmount())
            .rotationEffect(Angle(degrees: getRotationAmmount()))
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onChanged { value in
                        onDragGesture(value: value)
                    }
                    .onEnded { value in
                        offset = .zero
                    }
            )
            .onAppear {
                if viewModel.quotes.isEmpty {
                    viewModel.getData()
                }
            }
            VStack {
                Spacer()
                ButtonView(viewModel: viewModel, random: $random, withSwipeAnimation: withSwipeAnimation)
            }
        }
    }
    
    func quoteImage() -> some View {
        return Image(viewModel.pictures[self.random].imageName)
            .resizable()
            .scaledToFill()
            .frame(maxWidth: 320, maxHeight: 600)
            .aspectRatio(contentMode: .fill)
            .clipShape(RoundedRectangle(cornerRadius: 40))
    }
    
    func quoteText(for quote: Quote) -> some View {
        return Text(quote.content)
            .foregroundColor(Color.white)
            .font(Font.custom("LoveYaLikeASister-Regular", size: 32))
            .fontWeight(.bold)
            .frame(maxWidth: 320, maxHeight: 485)
            .padding(.all)
            .multilineTextAlignment(.center)
            .padding(.all)
    }
    
    func authorText(for quote: Quote) -> some View {
        return Text("- " + quote.author)
            .font(Font.custom("Courgette-Regular", size: 16))
            .foregroundColor(Color.white)
            .fontWeight(.heavy)
            .padding(.horizontal)
    }
    
    func onDragGesture(value: DragGesture.Value) {
        offset.width = value.translation.width
        
        if value.translation.width > 0 {
            viewModel.previousQuote()
            random = (random - 1 + viewModel.pictures.count) % viewModel.pictures.count
        } else {
            viewModel.nextQuote()
            random = (random + 1) % viewModel.pictures.count
        }
        
        offset = .zero
    }
    
    func withSwipeAnimation(forward: Bool) {
        withAnimation(.spring()) {
            offset = .zero
            if forward && random < viewModel.pictures.count - 1 {
                random += 1
                viewModel.nextQuote()
            } else if !forward && random > 0 {
                random -= 1
                viewModel.previousQuote()
            }
        }
    }
    
    func getScaleAmmount() -> CGFloat {
        let max = UIScreen.main.bounds.width / 2
        let currentAmmount = abs(offset.width)
        let persentage = currentAmmount / max
        return 1.0 - min(persentage, 0.6) * 0.5
    }
    
    func getRotationAmmount() -> Double {
        let max = UIScreen.main.bounds.width / 2
        let currentAmmount = offset.width
        let persentage = currentAmmount / max
        let persentageAsDouble = Double(persentage)
        let maxAngle: Double = 10
        return persentageAsDouble * maxAngle
    }
}

struct QuoteView_Previews: PreviewProvider {
    static var previews: some View {
        QuoteView()
    }
}


struct ButtonView: View {
    @ObservedObject var viewModel: QuoteViewModel
    @Binding var random: Int
    var withSwipeAnimation: (Bool) -> Void
    
    var body: some View {
        HStack {
            Button(action: {
                viewModel.previousQuote()
                random = viewModel.currentImageIndex
            }, label: {
                Image(systemName: "clock.arrow.circlepath")
                    .padding()
                    .font(.largeTitle)
                    .foregroundColor(.black)
            })
            
            
            Button(action: {
                withSwipeAnimation(true)
            }, label: {
                Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
                    .padding()
                    .font(.largeTitle)
                    .foregroundColor(.black)
            })
        }
    }
}
