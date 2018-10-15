//
//  main.swift
//  GenericsInSwift
//
//  Created by Bill liu on 2018/10/13.
//  Copyright © 2018 Mzying. All rights reserved.
//

import Foundation

print("Hello, World!")


/// 合法商品
protocol LegallyTradable{
    
}


/// 合法货币
protocol TradeCurrency {
    
}


/// 金额协议
protocol Money {
    associatedtype Currency
    
    var currency : Currency { get }
    
    var amount : Float { get }
    
    func sum<M : Money>(with money : M) -> M where M.Currency == Currency
}

extension Money where Currency == EURCurrency{
    func printAmount() {
        print("\(amount) EUR")
    }
}


struct RMBCurrency : TradeCurrency{
    
}

struct EURCurrency : TradeCurrency{
    
}


struct IPadMoney : Money{
    typealias Currency = EURCurrency
    
    var currency: EURCurrency{
        return EURCurrency()
    }
    
    var amount: Float{
        return 2000
    }
    
    func sum<M>(with money: M) -> M where M : Money, IPadMoney.Currency == M.Currency {
        return IPadMoney() as! M
    }
}


struct IPhoneMoney : Money {
    typealias Currency = RMBCurrency
    
    var currency: RMBCurrency{
        return RMBCurrency()
    }
    
    var amount: Float{
        return 5988
    }
    
    func sum<M>(with money: M) -> M where M : Money, IPhoneMoney.Currency == M.Currency {
        return IPhoneMoney() as! M
    }
}



protocol Company{
    func buy<T: LegallyTradable, M: Money>(product : T, with money : M) where M.Currency : TradeCurrency
    
    func sell<T: LegallyTradable, M: Money>(product: T.Type, for money : M) -> T? where M.Currency : TradeCurrency
}

struct Mzying: Company {
    func buy<T, M>(product: T, with money: M) where T : LegallyTradable, M : Money, M.Currency : TradeCurrency {
        
    }
    
    func sell<T, M>(product: T.Type, for money: M) -> T? where T : LegallyTradable, M : Money, M.Currency : TradeCurrency {
        return nil;
    }
}


//Mzying().buy(product: <#T##LegallyTradable#>, with: <#T##Money#>)

struct PastaPackage {
    
}

struct TomatoSauce {
    
}


struct InventoryList<T> {
    
    var items: [T] = []
    
    mutating func add(item : T){
        items.append(item)
    }
    
    mutating func remove() -> T{
        return items.removeLast()
    }
    
    func isCapacityLow() -> Bool {
        return items.count < 3
    }
}


extension InventoryList{
    var topItem: T?{
        return items.last
    }
}



var pastaInventory = InventoryList<PastaPackage>()

pastaInventory.add(item: PastaPackage())

//var tomatoSauceInventory = InventoryList<TomatoSauce>()
//_ = tomatoSauceInventory.remove()



protocol StorableItem {
    
}



protocol Storage {
    associatedtype Item : StorableItem
    
    var items: [Item] {set get}
    
    mutating func add(item: Item)
    
    var size : Int {get}
    
    mutating func remove() -> Item
    
    func showCurrentInventory() -> [Item]
    
//    associatedtype Iterator : IteratorProtocol where Iterator.Element == Item
    
//    func makeIterator() -> Iterator
}


extension Storage{
    //subscript 关键字，让对象支持下标访问。
    subscript<Indices: Sequence>(indices: Indices) -> [Item] where Indices.Iterator.Element == Int{
        
        return indices.compactMap { (index) -> Item? in
            let count = items.count
            
            if index + 1 > count || index < 0{
                return nil
            }
            
            return items[index]
        }
    }
}


struct Food : StorableItem{
    var name : String
}

struct Mzyingstorage : Storage {
    
    typealias Item = Food
    
    var items = [Food]()
    
    var size: Int {return 100}
    
    mutating func add(item: Food) {
        items.append(item)
    }
    
    mutating func remove() -> Food{
        return items.removeLast()
    }
    
    func showCurrentInventory() -> [Food] {
        return items
    }
    
    func test() -> [Food] {
        return self[[1,0,3]]
    }
}


var mzyingStorage = Mzyingstorage()
mzyingStorage.add(item: Food(name: "A"))
mzyingStorage.add(item: Food(name: "B"))
mzyingStorage.add(item: Food(name: "C"))

print("test:\(mzyingStorage.test())")


