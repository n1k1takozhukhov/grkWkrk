import CoreData
import Foundation
import UIKit

protocol StockItemServicing {
    func fetchStocks() -> [StockEntity]
    func fetchStockItems() -> [StockItem]
    func addNewStockItem(stockItem: StockItem)
    func addSampleData()
    func deleteStockItem(stockItem: StockItem)
    func fetchSnapsItems() -> [StockItem]
    func fetchWatchlistItems() -> [StockItem]
}

final class StockItemService: StockItemServicing {
    private let moc: NSManagedObjectContext

    init(moc: NSManagedObjectContext) {
        self.moc = moc
        Task{
            //self.deleteAllStockItems()
        }
    }

    func fetchStocks() -> [StockEntity] {
        let request = NSFetchRequest<StockEntity>(entityName: "StockEntity")
        var entities: [StockEntity] = []

        do {
            entities = try moc.fetch(request)
        } catch {
            print("Some error occured while fetching")
        }
        return entities
    }
    
    func fetchStockItems() -> [StockItem] {
        fetchStocks().map {
            return StockItem(
                id: $0.id ?? UUID(),
                symbol: $0.symbol ?? "no symbol",
                title: $0.symbol ?? "Unknown",
                price: $0.price,
                percentChange: Double($0.percent_change),
                ammount: Double($0.ammount),
                priceWhenBought: $0.price_when_bought,
                is_watchlist: $0.is_watchlist,
                is_snaps: $0.is_snaps,
                profit: Double($0.value) * $0.ammount
            )
        }
    }
    
    func fetchWatchlistItems() -> [StockItem]{
        return fetchStockItems().filter { stockItem in
            stockItem.is_watchlist ?? false
        }
    }
    
    func fetchSnapsItems() -> [StockItem]{
        return fetchStockItems().filter { stockItem in
            stockItem.is_snaps ?? false
        }
    }
    
    func addNewStockItem(stockItem: StockItem) {
        let newStock = StockEntity(context: moc)
        newStock.id = UUID()
        newStock.ammount = stockItem.ammount
        newStock.price_when_bought = stockItem.price
        newStock.percent_change = Int16(stockItem.percentChange ?? 0)
        newStock.symbol = stockItem.symbol
        newStock.is_watchlist = stockItem.is_watchlist ?? false
        newStock.is_snaps = stockItem.is_snaps ?? false
        newStock.price = stockItem.price
        save()
    }
    
    func addSampleData() {
        let stock1 = StockItem(symbol: "bbb",title: "AAPL", price: 15, ammount: 25)
        let stock2 = StockItem(symbol: "ccc",title: "BTC-USD", price: 2000, ammount: 3)
        addNewStockItem(stockItem: stock1)
        addNewStockItem(stockItem: stock2)
    }
    
    func deleteStockItem(stockItem: StockItem) {
        var query: String = ""
        var predicate: NSPredicate
        
        if stockItem.is_watchlist ?? false {
            query = "is_watchlist"
            predicate = NSPredicate(format: "symbol == %@ AND \(query) == %@", stockItem.symbol, NSNumber(value: true))
        } else if stockItem.is_snaps ?? false {
            query = "is_snaps"
            predicate = NSPredicate(format: "symbol == %@ AND \(query) == %@ AND ammount == %@", stockItem.symbol, NSNumber(value: true), NSNumber(value: stockItem.ammount))
        } else {
            print("No stock items to delete")
            return
        }
        
        let request = NSFetchRequest<StockEntity>(entityName: "StockEntity")
        request.predicate = predicate
        
        do {
            let results = try moc.fetch(request)
            for entity in results {
                moc.delete(entity)
            }
            save()
        } catch {
            print("Error deleting stock item: \(error)")
        }
    }
    
    func deleteAllStockItems() {
            let request = NSFetchRequest<StockEntity>(entityName: "StockEntity")
            
            do {
                let results = try moc.fetch(request)
                for entity in results {
                    moc.delete(entity)
                }
                save()
            } catch {
                print("Error deleting all stock items: \(error)")
            }
        }
}

private extension StockItemService {
    func save() {
        if moc.hasChanges{
            do {
                try moc.save()
                debugPrint("saved to coredata successfuly")
            } catch {
                print("Cannot save MOC: \(error.localizedDescription)")
            }
        }
    }
}


