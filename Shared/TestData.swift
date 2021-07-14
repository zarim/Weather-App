//
//  TestData.swift
//  weather-app
//
//  Created by Zari McFadden on 6/2/21.
//

import Foundation

struct Address: Codable {
    var street: String
    var suite: String
    var city: String
}
struct U: Codable {
    var id: Int
    var name: String
    var address: Address
}

class Test {
    
    func getData() {
        let url = URL(string: "https://jsonplaceholder.typicode.com/users")!

        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                let users = try? JSONDecoder().decode([U].self, from: data)
                print(users!)
            }
            
        }.resume()
    }
}
