//
//  CalendarView.swift
//  Meleque
//
//  Created by Sinan Dinç on 12/20/25.
//

import SwiftUI

struct CalendarView: View {
    
    @State private var date = Date()
    
    var body: some View {
        GeometryReader { geoProxy in
            NavigationStack {
                ScrollView(.vertical) {
                    VStack(spacing: 0){
                        HStack(spacing: 20){
                            ProgressView(
                                value: 0.90,
                                label: {
                                    Text("Ayın Tamamlanmasına Kalan Süre")
                                        .font(.caption)
                                },
                                currentValueLabel: { Text("90%")}
                            )
                            .progressViewStyle(BarProgressStyle(height: 20.0))
                            
                            ProgressView(
                                value: 0.95,
                                label: {
                                    Text("Yılın Tamamlanmasına Kalan Süre")
                                        .font(.caption)
                                },
                                currentValueLabel: { Text("95%")}
                            )
                            .progressViewStyle(BarProgressStyle(height: 20.0))
                        }
                        .padding()
                        .frame(
                            height: geoProxy.size.height * 0.2
                        )
                        .background(.gray.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        
                        DatePicker(
                            "Start Date",
                            selection: $date,
                            displayedComponents: [.date]
                        )
                        .datePickerStyle(.graphical)
                        .frame(
                            width: geoProxy.size.width,
                            height: geoProxy.size.height * 0.5
                        )
                        ZStack {
                            
                        }
                        .frame(
                            width: geoProxy.size.width,
                            height: geoProxy.size.height * 0.3
                        )
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

struct BarProgressStyle: ProgressViewStyle {

    var color: Color = .blue
    var height: Double = 20.0
    var labelFontStyle: Font = .body

    func makeBody(configuration: Configuration) -> some View {

        let progress = configuration.fractionCompleted ?? 0.0

        GeometryReader { geometry in
            
            VStack(alignment: .leading) {
                
                configuration.label
                    .font(labelFontStyle)
                
                RoundedRectangle(cornerRadius: 10.0)
                    .fill(Color(uiColor: .systemGray5))
                    .frame(height: height)
                    .frame(width: geometry.size.width)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 10.0)
                            .fill(color)
                            .frame(width: geometry.size.width * progress)
                            .overlay {
                                if let currentValueLabel = configuration.currentValueLabel {
                                    
                                    currentValueLabel
                                        .font(.headline)
                                        .foregroundColor(.white)
                                }
                            }
                    }
                
            }
        }
    }
}

#Preview {
    CalendarView()
}
