//
//  CalendarView.swift
//  Meleque
//
//  Created by Sinan Dinç on 12/20/25.
//
import SwiftUI

// MARK: - Models
struct CalendarEvent: Identifiable {
    let id = UUID()
    let title: String
    let date: Date
    let color: Color
    let category: EventCategory
    var isCompleted: Bool = false
}

enum EventCategory: String, CaseIterable {
    case work = "İş"
    case personal = "Kişisel"
    case meeting = "Toplantı"
    case reminder = "Hatırlatıcı"
    
    var icon: String {
        switch self {
        case .work: return "briefcase.fill"
        case .personal: return "person.fill"
        case .meeting: return "person.3.fill"
        case .reminder: return "bell.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .work: return .blue
        case .personal: return .green
        case .meeting: return .orange
        case .reminder: return .purple
        }
    }
}

// MARK: - CalendarView
struct CalendarView: View {
    @State private var selectedDate = Date()
    @State private var showingAddEvent = false
    @State private var events: [CalendarEvent] = CalendarEvent.sampleEvents
    
    private var monthProgress: Double {
        let calendar = Calendar.current
        let day = Double(calendar.component(.day, from: Date()))
        let daysInMonth = Double(calendar.range(of: .day, in: .month, for: Date())?.count ?? 30)
        return day / daysInMonth
    }
    
    private var yearProgress: Double {
        let calendar = Calendar.current
        let dayOfYear = Double(calendar.ordinality(of: .day, in: .year, for: Date()) ?? 1)
        let daysInYear = calendar.range(of: .day, in: .year, for: Date())?.count ?? 365
        return dayOfYear / Double(daysInYear)
    }
    
    private var selectedDateEvents: [CalendarEvent] {
        events.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geoProxy in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 20) {
                        // Progress Section
                        ProgressSection(
                            monthProgress: monthProgress,
                            yearProgress: yearProgress
                        )
                        .frame(height: geoProxy.size.height * 0.18)
                        .padding(.horizontal)
                        
                        // Calendar Picker
                        DatePicker(
                            "Tarih Seçin",
                            selection: $selectedDate,
                            displayedComponents: [.date]
                        )
                        .datePickerStyle(.graphical)
                        .padding(.horizontal)
                        .tint(.blue)
                        
                        // Events Section
                        EventsSection(
                            events: selectedDateEvents,
                            selectedDate: selectedDate,
                            onToggleComplete: { event in
                                toggleEventCompletion(event)
                            },
                            onDelete: { event in
                                deleteEvent(event)
                            }
                        )
                        .frame(minHeight: geoProxy.size.height * 0.3)
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Takvim")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddEvent = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }
            }
            .sheet(isPresented: $showingAddEvent) {
                AddEventView(selectedDate: selectedDate) { newEvent in
                    events.append(newEvent)
                }
            }
        }
    }
    
    private func toggleEventCompletion(_ event: CalendarEvent) {
        if let index = events.firstIndex(where: { $0.id == event.id }) {
            events[index].isCompleted.toggle()
        }
    }
    
    private func deleteEvent(_ event: CalendarEvent) {
        events.removeAll { $0.id == event.id }
    }
}

// MARK: - Progress Section
struct ProgressSection: View {
    let monthProgress: Double
    let yearProgress: Double
    
    var body: some View {
        HStack(spacing: 15) {
            ProgressCard(
                title: "Ay İlerlemesi",
                progress: monthProgress,
                color: .blue,
                icon: "calendar"
            )
            
            ProgressCard(
                title: "Yıl İlerlemesi",
                progress: yearProgress,
                color: .green,
                icon: "calendar.badge.clock"
            )
        }
    }
}

// MARK: - Progress Card
struct ProgressCard: View {
    let title: String
    let progress: Double
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
                
                Spacer()
                
                Text("\(Int(progress * 100))%")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(color)
            }
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ProgressView(value: progress)
                .progressViewStyle(BarProgressStyle(color: color, height: 8))
        }
        .padding()
        .background(color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

// MARK: - Events Section
struct EventsSection: View {
    let events: [CalendarEvent]
    let selectedDate: Date
    let onToggleComplete: (CalendarEvent) -> Void
    let onDelete: (CalendarEvent) -> Void
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM YYYY"
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Etkinlikler")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                Text(dateFormatter.string(from: selectedDate))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if events.isEmpty {
                EmptyEventsView()
            } else {
                ForEach(events) { event in
                    EventCard(
                        event: event,
                        onToggleComplete: { onToggleComplete(event) },
                        onDelete: { onDelete(event) }
                    )
                }
            }
        }
    }
}

// MARK: - Empty Events View
struct EmptyEventsView: View {
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: "calendar.badge.exclamationmark")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("Bu tarihte etkinlik yok")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text("Yeni etkinlik eklemek için + butonuna dokunun")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
}

// MARK: - Event Card
struct EventCard: View {
    let event: CalendarEvent
    let onToggleComplete: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 15) {
            // Category Icon
            ZStack {
                Circle()
                    .fill(event.category.color.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: event.category.icon)
                    .foregroundColor(event.category.color)
                    .font(.title3)
            }
            
            // Event Info
            VStack(alignment: .leading, spacing: 5) {
                Text(event.title)
                    .font(.headline)
                    .strikethrough(event.isCompleted)
                    .foregroundColor(event.isCompleted ? .secondary : .primary)
                
                HStack {
                    Text(event.category.rawValue)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(event.category.color.opacity(0.2))
                        .foregroundColor(event.category.color)
                        .clipShape(Capsule())
                    
                    if event.isCompleted {
                        Text("Tamamlandı")
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                }
            }
            
            Spacer()
            
            // Actions
            HStack(spacing: 15) {
                Button(action: onToggleComplete) {
                    Image(systemName: event.isCompleted ? "checkmark.circle.fill" : "circle")
                        .font(.title3)
                        .foregroundColor(event.isCompleted ? .green : .gray)
                }
                
                Button(action: onDelete) {
                    Image(systemName: "trash.fill")
                        .font(.title3)
                        .foregroundColor(.red)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

// MARK: - Add Event View
struct AddEventView: View {
    @Environment(\.dismiss) var dismiss
    let selectedDate: Date
    let onSave: (CalendarEvent) -> Void
    
    @State private var eventTitle = ""
    @State private var selectedCategory: EventCategory = .personal
    @State private var eventDate: Date
    
    init(selectedDate: Date, onSave: @escaping (CalendarEvent) -> Void) {
        self.selectedDate = selectedDate
        self.onSave = onSave
        _eventDate = State(initialValue: selectedDate)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Etkinlik Bilgileri") {
                    TextField("Etkinlik Adı", text: $eventTitle)
                    
                    Picker("Kategori", selection: $selectedCategory) {
                        ForEach(EventCategory.allCases, id: \.self) { category in
                            HStack {
                                Image(systemName: category.icon)
                                Text(category.rawValue)
                            }
                            .tag(category)
                        }
                    }
                    
                    DatePicker("Tarih", selection: $eventDate, displayedComponents: [.date, .hourAndMinute])
                }
            }
            .navigationTitle("Yeni Etkinlik")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("İptal") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Kaydet") {
                        let newEvent = CalendarEvent(
                            title: eventTitle,
                            date: eventDate,
                            color: selectedCategory.color,
                            category: selectedCategory
                        )
                        onSave(newEvent)
                        dismiss()
                    }
                    .disabled(eventTitle.isEmpty)
                }
            }
        }
    }
}

// MARK: - Bar Progress Style
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

// MARK: - Sample Data Extension
extension CalendarEvent {
    static var sampleEvents: [CalendarEvent] {
        let today = Date()
        let calendar = Calendar.current
        
        return [
            CalendarEvent(
                title: "Proje Toplantısı",
                date: today,
                color: .orange,
                category: .meeting
            ),
            CalendarEvent(
                title: "Rapor Hazırla",
                date: today,
                color: .blue,
                category: .work
            ),
            CalendarEvent(
                title: "Doktor Randevusu",
                date: calendar.date(byAdding: .day, value: 1, to: today) ?? today,
                color: .green,
                category: .personal
            ),
            CalendarEvent(
                title: "Alışveriş Yap",
                date: calendar.date(byAdding: .day, value: 2, to: today) ?? today,
                color: .purple,
                category: .reminder,
                isCompleted: true
            )
        ]
    }
}

// MARK: - Preview
#Preview {
    CalendarView()
}
