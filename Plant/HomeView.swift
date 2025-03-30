//
//  HomeView.swift
//  Plant
//
//  Created by redding sauter on 3/10/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Query(sort: \Day.date) var days: [Day]
    @Query var user: [UserData]
    
    var body: some View {
        VStack(spacing: 20){
            Text("Home")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 40)
            
            Image(systemName: "tree")
                .imageScale(.large)
                .foregroundStyle(.green)
            
            Text("Have you had water today?")
                .font(.subheadline)
            
//            ProgressView(value: Double(days[0].intake), total: Double(days[0].goal))
//                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))
//                    .frame(width: 200)
            
//            Text("\(String(format: "%.1f", days[0].intake)) / \(String(format: "%.1f", days[0].goal)) \(user[0].unit == 1 ? "oz" : "l")")
//                .font(.subheadline)
//                .foregroundColor(.gray)

//            Button(action: {
//                days[0].updateIntake(amount:user[0].glassSize)
//            }) {
//                Text("Log a Glass of Water")
//                    .padding()
//                    .frame(width: 150)
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//            }
//            .padding(.top, 10)

            Spacer()
        }
        .padding()
    }
}
