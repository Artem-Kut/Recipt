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
            HStack {
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
                .frame(width: 90, height: 90)
                .clipShape(.rect(cornerRadius: 10))
                Text(name)
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0))
                Spacer()
            }
        }
        .listRowSeparator(.hidden)
    }
}

#Preview {
    ReceiptCellView(url: "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg",
                   name: "Apam Balik")
}
