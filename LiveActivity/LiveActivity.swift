//
//  LiveActivity.swift
//  LiveActivity
//
//  Created by LiYanan2004 on 2022/8/2.
//

import WidgetKit
import SwiftUI
import ActivityKit

struct LockScreenActivity : View {
    var state: ActivityAttribute.ContentState

    var body: some View {
        HStack {
            Text("Timer")
            rectangle(count: state.count)
            Text("Count: \(state.count)").contentTransition(.numericText())
            Text(state.time, style: .timer)
                .multilineTextAlignment(.trailing)
        }
        .font(.largeTitle)
        .scenePadding()
    }
    
    func rectangle(count: Int) -> some View {
        VStack {
            if count < 1 {
                Circle().frame(maxWidth: .infinity, alignment: .trailing)
                    .transition(.push(from: .leading))
            } else {
                Circle().frame(maxWidth: .infinity, alignment: .leading)
                    .transition(.push(from: .leading))
            }
            RoundedRectangle(cornerRadius: 10)
                .fill(count < 1 ? .green : .red)
                .frame(width: count < 1 ? 80 : 100)
        }
    }
}

@main
@available(iOS 16.1, *)
struct LiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ActivityAttribute.self) { context in
            LockScreenActivity(state: context.state)
                .activityBackgroundTint(Color.cyan)
        } dynamicIsland: { context in
            timerIsland(state: context.state)
        }
    }
    
    func timerIsland(state: ActivityAttribute.ContentState) -> DynamicIsland {
        DynamicIsland {
            DynamicIslandExpandedRegion(.leading, priority: 10) {
                HStack(alignment: .bottom) {
                    Button {
                        
                    } label: {
                        Image(systemName: "pause")
                    }
                    .foregroundStyle(.tint)
                    .frame(width: 50, height: 50)
                    .background(.tint.opacity(0.2), in: Circle())
                    .tint(.orange)
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .foregroundStyle(.tint)
                    .frame(width: 50, height: 50)
                    .background(.tint.opacity(0.2), in: Circle())
                    .tint(.white)
                    
                    Spacer()
                    
                    Text("Timer").font(.headline)
                }
                .buttonStyle(.plain)
                .foregroundStyle(.orange)
                .fontWeight(.heavy)
            }
            
            DynamicIslandExpandedRegion(.trailing) {
                Text(state.time, style: .timer)
                    .foregroundStyle(.orange)
                    .multilineTextAlignment(.trailing)
                    .font(.system(size: 48))
                    .frame(height: 50)
                    .frame(maxWidth: 100)
                    .activityBackgroundTint(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2470588235))) // No Effect, maybe a bug in iOS 16.1 beta 1.
            }
        } compactLeading: {
            Image(systemName: "timer").font(.headline.bold())
                .foregroundColor(.orange)
        } compactTrailing: {
            Text(state.time, style: .timer)
                .multilineTextAlignment(.trailing)
                .frame(maxWidth: 40)
                .foregroundColor(.orange)
        } minimal: {
            Image(systemName: "timer").font(.headline.bold())
                .foregroundColor(.orange)
        }
        .keylineTint(.orange) // <- No effect, maybe it's a bug in iOS 16.1 beta 1.
    }
}
