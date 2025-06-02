import SwiftUI
import Charts

struct StockChartView: View {
    let data: ChartData
    @State private var selectedPrice: Double?
    
    var body: some View {
        let chartPoints: [ChartPoint] = data.chartPoints
        let priceRange: (min: Double, max: Double) = data.priceRange
        
        
        let isPriceHigherAtStart = chartPoints.first?.price ?? 0 > chartPoints.last?.price ?? 0

        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.gray).opacity(0.2))
                .shadow(radius: 8)
            
            Chart {
                ForEach(chartPoints) { point in
                    LineMark(
                        x: .value("Date".localized, point.date),
                        y: .value("Price".localized, point.price)
                    )
                    .interpolationMethod(.cardinal)
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                isPriceHigherAtStart ? Color.red.opacity(0.7) : Color.green.opacity(0.7),
                                isPriceHigherAtStart ? Color.red.opacity(0.4) : Color.green.opacity(0.4)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .lineStyle(StrokeStyle(lineWidth: 2, lineCap: .round))
                }
                
                AreaMark(
                    x: .value("Date".localized, chartPoints.first?.date ?? Date()),
                    yStart: .value("Min".localized, priceRange.min),
                    yEnd: .value("Price".localized, chartPoints.first?.price ?? 0)
                )
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            isPriceHigherAtStart ? Color.red.opacity(0.2) : Color.green.opacity(0.2),
                            isPriceHigherAtStart ? Color.red.opacity(0.05) : Color.green.opacity(0.05)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            }
            .chartXAxis {
                AxisMarks(position: .bottom) { _ in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                        .foregroundStyle(Color.gray.opacity(0.3))
                    AxisTick(stroke: StrokeStyle(lineWidth: 0.5))
                        .foregroundStyle(Color.gray.opacity(0.3))
                    AxisValueLabel()
                        .foregroundStyle(Color.gray)
                }
            }
            .chartYAxis {
                AxisMarks(position: .trailing) { value in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                        .foregroundStyle(Color.gray.opacity(0.3))
                    AxisTick(stroke: StrokeStyle(lineWidth: 0.5))
                        .foregroundStyle(Color.gray.opacity(0.3))
                    AxisValueLabel {
                        if let doubleValue = value.as(Double.self) {
                            Text("\(Int(doubleValue))")
                                .foregroundStyle(Color.gray)
                        }
                    }
                }
            }
            .chartYScale(domain: priceRange.min...priceRange.max)
            .padding()
        }
    }
}
