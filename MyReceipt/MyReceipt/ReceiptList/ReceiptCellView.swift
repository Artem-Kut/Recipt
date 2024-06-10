//
//  ReceiptCellView.swift
//  MyReceipt
//
//  Created by Artem Kutasevych on 6/10/24.
//

import SwiftUI

struct ReceiptCellView: View {
    @State var url: String
    @State var name: String
    var body: some View {
        HStack {
            Spacer()
            VStack {
                AsyncImage(url: URL(string: url)) { phase in
                    switch phase {
                    case .failure:
                        Image(systemName: "photo")
                            .font(.largeTitle)
                    case .success(let image):
                        image
                            .resizable()
                    default:
                        ProgressView()
                    }
                }
                .frame(width: 256, height: 256)
                .clipShape(.rect(cornerRadius: 25))
                .padding(EdgeInsets(top: 25, leading: 25, bottom: 0, trailing: 25))
                Text(name)
                    .padding(EdgeInsets(top: 5, leading: 25, bottom: 25, trailing: 25))
            }
            Spacer()
        }
        .listRowSeparator(.hidden)
        .background(Color.brown)
        .clipShape(.rect(cornerRadius: 25))
    }
}

#Preview {
    ReceiptCellView(url: "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg",
                   name: "Apam Balik")
}
