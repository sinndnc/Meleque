//
//  CalendarView.swift
//  Meleque
//
//  Created by Sinan Dinç on 12/20/25.
//

import SwiftUI

struct CalendarView: View {
    var body: some View {
        GeometryReader { geoProxy in
            NavigationStack {
                ScrollView(.vertical) {
                    VStack{
                        HStack(spacing: 20){
                            ProgressView("Ayın Bitimine Kalan Süre", value: 0.5)
                            ProgressView("Yılın Bitimine Kalan Süre", value: 0.5)
                        }
                        .padding()
                        .frame(
                            height: geoProxy.size.height * 0.1
                        )
                        .background(.gray.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        
                        ScrollView(.horizontal) {
                            LazyHGrid(rows: [
                                GridItem(.fixed(30)),
                                GridItem(.fixed(30)),
                                GridItem(.fixed(30))
                            ], alignment: .top, spacing: 10) {
                                ForEach(0..<30, id: \.self) { column in
                                    Text("\(column)")
                                        .frame(width: 30)
                                        .frame(maxHeight: .infinity)
                                        .background(Color.gray.opacity(0.2))
                                        .border(Color.gray)
                                }
                            }
                            .padding()
                        }
                        .frame(
                            width: geoProxy.size.width,
                            height: geoProxy.size.height * 0.2
                        )
                        .background(.gray.opacity(0.2))
                        ScrollView(.horizontal) {
                            LazyHGrid(rows: [
                                GridItem(.fixed(100)),
                                GridItem(.fixed(100)),
                                GridItem(.fixed(100))
                            ], alignment: .top, spacing: 10) {
                                ForEach(0..<100, id: \.self) { column in
                                    Text("\(column)")
                                        .frame(width: 100)
                                        .frame(maxHeight: .infinity)
                                        .background(Color.gray.opacity(0.2))
                                        .border(Color.gray)
                                }
                            }.padding()
                        }
                        .frame(
                            height: geoProxy.size.height * 0.7
                        )
                        .background(.gray.opacity(0.2))
                    }
                    .frame(
                        width: geoProxy.size.width,
                        height: geoProxy.size.height
                    )
                }
                .navigationTitle("Calendar")
            }
        }
    }
}

#Preview {
    CalendarView()
}
