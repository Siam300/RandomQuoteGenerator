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
    @State var offset: CGSize = .zero
    
    let pictures = [
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
    ]
    
    var body: some View {
        ZStack {
            Color("bcolor")
                .edgesIgnoringSafeArea(.all)
            
            Image(pictures[self.random].imageName)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: 320, maxHeight: 600)
                .aspectRatio(contentMode: .fill)
                .clipShape(RoundedRectangle(cornerRadius: 40))
                .offset(offset)
                .scaleEffect(getScaleAmmount())
                .rotationEffect(Angle(degrees: getRotationAmmount()))
            
            Color("bcolor").opacity(0.4)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Spacer()
                if let quote = viewModel.quotes[safe: viewModel.currentIndex] {
                    Text(quote.content)
                        .foregroundColor(Color.white)
                        .font(.largeTitle)
                        .frame(width: 250)
                        .padding(.all)
                        //.background(Color.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.all)
                    
                    Text("- " + quote.author)
                        .foregroundColor(Color.white)
                        .fontWeight(.heavy)
                        .padding(.horizontal)
                        //.background(Color.white.opacity(0.8))
                }
                Spacer()
                Button(action: {
                    withSwipeAnimation(forward: true)
                }, label: {
                    Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.black)
                })

            }
            .padding(.all)
            .offset(offset)
            .scaleEffect(getScaleAmmount())
            .rotationEffect(Angle(degrees: getRotationAmmount()))
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onChanged { value in
                        offset.width = value.translation.width
                    }
                    .onEnded{ value in
                        offset = .zero
                        let gestureThreshold: CGFloat = 50
                        if abs(value.translation.width) > gestureThreshold {
                            if value.translation.width > 0 {
                                viewModel.previousQuote()
                            } else {
                                viewModel.nextQuote()
                            }
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
    
    func withSwipeAnimation(forward: Bool) {
        withAnimation(.spring()) {
            offset = .zero
            if forward && random < pictures.count - 1 {
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
