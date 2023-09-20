//
//  QouteViewModel.swift
//  quoteGenerator
//
//  Created by Auto on 9/10/23.
//

import SwiftUI
import Foundation

class QuoteViewModel: ObservableObject {
    @Published var quotes: [Quote] = []
    @Published var currentIndex: Int = 0
    @Published var isError = false
    @Published var currentImageName: String = ""
    @Published var currentImageIndex: Int = 0
    
    var pictures: [aPicture]
    
    init(pictures: [aPicture]) {
        self.pictures = pictures
        getData()
    }
    
    func getData() {
        guard let url = URL(string: "https://api.quotable.io/random") else { return }
        
        //        var request = URLRequest(url: url)
        //        request.httpMethod = "GET"
        //        request.setValue("f8d176fd89msh7a6bf029fa427d2p17fe09jsn2fe715e0c853", forHTTPHeaderField: "X-RapidAPI-Key")
        //        request.setValue("yusufnb-quotes-v1.p.rapidapi.com", forHTTPHeaderField: "X-RapidAPI-Host")
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url) { [weak self] (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("Network error: \(error)")
                    self?.isError = true
                } else if let data = data {
                    do {
                        let decodedData = try JSONDecoder().decode(Quote.self, from: data)
                        self?.quotes.append(decodedData)
                    } catch {
                        print("JSON parsing error: \(error)")
                    }
                }
            }
        }
        dataTask.resume()
    }
    
//    func getRandomImage(completion: @escaping (URL?) -> Void) {
//            guard let url = URL(string: "https://random.responsiveimages.io/") else {
//                completion(nil)
//                return
//            }
//
//            let session = URLSession.shared
//            let dataTask = session.dataTask(with: url) { (data, response, error) in
//                if let data = data,
//                   let urlString = String(data: data, encoding: .utf8),
//                   let imageUrl = URL(string: urlString) {
//                    completion(imageUrl)
//                } else {
//                    completion(nil)
//                }
//            }
//
//            dataTask.resume()
//        }
    
    func nextQuote() {
            if currentIndex < quotes.count - 1 {
                currentIndex += 1
                currentImageIndex = (currentImageIndex + 1) % pictures.count
            } else {
                getData()
            }
        }
    
    func previousQuote() {
            if currentIndex > 0 {
                currentIndex -= 1
                currentImageIndex = (currentImageIndex - 1 + pictures.count) % pictures.count 
            }
        }
}

