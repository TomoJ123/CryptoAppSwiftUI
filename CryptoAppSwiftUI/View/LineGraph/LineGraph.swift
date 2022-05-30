//
//  LineGraph.swift
//  CryptoAppSwiftUI
//
//  Created by Tomislav Jurić-Arambašić on 23.04.2022..
//

import SwiftUI

struct LineGraph: View {
    
    var data: [Double]
    var profit: Bool = false
    
    @State var currentPlot = ""
    @State var offset: CGSize = .zero
    @State var showPlot = false
    @State var translation: CGFloat = 0
    
    // Animating Graph
    @State var graphProgress: CGFloat = 0
    
    var body: some View {
        
        GeometryReader { proxy in
            
            let height = proxy.size.height
            let width = (proxy.size.width) / CGFloat(data.count - 1)

            let maxPoint = (data.max() ?? 0)
            let minPoint = data.min() ?? 0
            
            let points = data.enumerated().compactMap { item -> CGPoint in
                
                // progress and multiplying with height
                // Making to show from minimum amount
                let progress = (item.element - minPoint) / (maxPoint - minPoint)
                
                let pathHeight = progress * (height - 50)
                
                // width
                let pathWidth = width * CGFloat(item.offset)
                
                return CGPoint(x: pathWidth, y: -pathHeight + height)
            }
            
            ZStack {
                
                // Convert plot as points
                
                // Path
                AnimatedGraphPath(progress: graphProgress, points: points)
                .fill(
                    
                    LinearGradient(colors: [
                        profit ? Color("Profit") : Color("Loss"),
                        profit ? Color("Profit") : Color("Loss")
                    ], startPoint: .leading, endPoint: .trailing)
                )
                
                // Background coloring
                fillBG()
                // Clipping the shape
                .clipShape(
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: 0))
                        
                        path.addLines(points)
                        
                        path.addLine(to: CGPoint(x: proxy.size.width, y: height))
                        
                        path.addLine(to: CGPoint(x: 0, y: height))
                    }
                )
                .opacity(graphProgress)
            }
            .overlay(
                
                // Drag indicator...
                VStack(spacing: 0) {
                    Text(currentPlot)
                        .font(.caption.bold())
                        .foregroundColor(.white)
                        .padding(.vertical, 6)
                        .frame(width: 100)
                        .background(Color("Gradient1"), in: Capsule())
                        .offset(x: translation < 10 ? 30 : 0)
                        .offset(x: translation > (proxy.size.width - 60) ? -30 : 0)
                    
                    Rectangle()
                        .fill(Color("Gradient1"))
                        .frame(width: 1, height: 40)
                        .padding(.top)
                    
                    Circle()
                        .fill(.white)
                        .frame(width: 22, height: 22)
                        .overlay(
                            Circle()
                                .fill(Color("Gradient1"))
                                .frame(width: 10, height: 10)
                        )
                    
                    Rectangle()
                        .fill(Color("Gradient1"))
                        .frame(width: 1, height: 50)
                }
                // Fixed frame for gesture calculation
                    .frame(width: 80, height: 170)
                    .offset(y: 70)
                    .offset(offset)
                    .opacity(showPlot ? 1 : 0),
                alignment: .bottomLeading
            )
            .contentShape(Rectangle())
            .gesture(DragGesture().onChanged({ value in
                withAnimation { showPlot = true }
                
                let translation = value.location.x
                
                // Getting index...
                let index = max(min(Int((translation / width).rounded() + 1), data.count - 1), 0)
                currentPlot = data[index].convertToCurrency()
                self.translation = translation
                
                // Removing half width.. 80
                offset = CGSize(width: points[index].x - 40, height: points[index].y - height)
            }).onEnded({ value in
                withAnimation { showPlot = false }
            }))
        }
        .overlay(
            
            VStack(alignment: .leading) {
                let max = data.max() ?? 0
                let min = data.min() ?? 0
                
                Text(max.convertToCurrency())
                    .font(.caption.bold())
                    .offset(y: -5)
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(min.convertToCurrency())
                        .font(.caption.bold())
                    
                    Text("Last 7 days")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .offset(y: 40)
            }
                .frame(maxWidth: .infinity, alignment: .leading)
        )
        .padding(.horizontal, 10)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                withAnimation(.easeInOut(duration: 1.5)) {
                    graphProgress = 1
                }
            })
        }
        .onChange(of: data) { newValue in
            //MARK: ReAnimating when ever Plot data Updates
            graphProgress = 0
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                withAnimation(.easeInOut(duration: 1.5)) {
                    graphProgress = 1
                }
            })
        }
    }
    
    @ViewBuilder
    func fillBG() -> some View {
        let color = profit ? Color("Profit") : Color("Loss")
        
        LinearGradient(colors: [
            
            color
                .opacity(0.3),
            color
                .opacity(0.2),
            color
                .opacity(0.1)
        ]
            + Array(repeating:
                        color
                        .opacity(0.1), count: 4)
            + Array(repeating:
                        Color.clear, count: 2)
            ,startPoint: .top, endPoint: .bottom)
    }
}

struct LineGraph_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// MARK: Animated path
struct AnimatedGraphPath: Shape {
    var progress: CGFloat
    var points: [CGPoint]
    
    var animatableData: CGFloat {
        get { return progress }
        set { progress = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            
            //drawing points
            path.move(to: CGPoint(x: 0, y: 0))
            
            path.addLines(points)
        }
        .trimmedPath(from: 0, to: progress)
        .strokedPath(StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
    }
}
