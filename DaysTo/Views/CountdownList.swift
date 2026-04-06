//
//  CountdownList.swift
//  DaysTo
//
//  Created by Killian Mathias on 06/04/2026.
//

import SwiftUI
import SwiftData

struct CountdownList: View {
    @Query var countdowns : [Countdown]
    @Environment(\.modelContext) var modelContext
    var body: some View {
        List{
            ForEach(countdowns){ countdown in
                VStack{
                    Text(countdown.name)
                        .font(.headline)
                    Text(countdown.date.formatted(date:.long, time: .shortened))
                }
               
            }
            .onDelete(perform: deleteDestinations)
        }
        .toolbar{
            Button("Add Countdown", action : addCountdown)
        }
    }
    
    func addCountdown(){
        let one = Countdown(name: "One")
        let two = Countdown(name: "Two")
        let three = Countdown(name: "Three")
        
        modelContext.insert(one)
        modelContext.insert(two)
        modelContext.insert(three)
    }
    
    func deleteDestinations(_ indexSet : IndexSet){
        for index in indexSet{
            let countdown = countdowns[index]
            modelContext.delete(countdown)
        }
    }
}

#Preview {
    CountdownList()
}
