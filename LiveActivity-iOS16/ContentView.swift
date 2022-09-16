//
//  ContentView.swift
//  LiveActivity-iOS16
//
//  Created by LiYanan2004 on 2022/8/2.
//

import SwiftUI
import ActivityKit
import WidgetKit

struct ContentView: View {
    @State var count = 0
    var body: some View {
        VStack(spacing: 20) {
            Button(action: startLiveActivity) {
                Label("Start Live Activity", systemImage: "plus")
            }
            .tint(.green)
            
            Button(action: updateLiveActivity) {
                Label("Update Live Activity", systemImage: "plus")
            }
            .tint(.yellow)
            
            Button(action: endLiveActivity) {
                Label("End Live Activity", systemImage: "plus")
            }
            .tint(.red)
        }
        .buttonStyle(.bordered)
        .buttonBorderShape(.capsule)
        .controlSize(.large)
        .onAppear {
            startLiveActivity()
        }
    }
    
    func startLiveActivity() {
        if #available(iOS 16.1, *) {
            Task {
                let attribute = ActivityAttribute()
                let state = ActivityAttribute.ContentState()
                do {
                    let activity = try Activity<ActivityAttribute>.request(attributes: attribute, contentState: state, pushType: nil)
                    print(activity.id)
                    DispatchQueue.main.async {
                        count += 1
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func updateLiveActivity() {
        if #available(iOS 16.1, *) {
            if let activity = Activity<ActivityAttribute>.activities.first {
                let state = ActivityAttribute.ContentState(count: count)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    Task {
                        await activity.update(using: state)
                        DispatchQueue.main.async {
                            count += 1
                        }
                    }
                }
            }
        }
    }
    
    func endLiveActivity() {
        if #available(iOS 16.1, *) {
            let activities = Activity<ActivityAttribute>.activities
            activities.forEach { activity in
                Task {
                    await activity.end(using: nil, dismissalPolicy: .immediate)
                    DispatchQueue.main.async {
                        count = 0
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
