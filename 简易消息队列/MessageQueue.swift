//
//  MessageQueue.swift
//  ChatDemo
//
//  Created by 李正国 on 2023/4/12.
//

import Foundation

fileprivate let defaultQueueSize = 50

struct MessageQueue<Element>:CustomStringConvertible,CustomDebugStringConvertible{
    
    
    var description: String {
        var retval = self
        return retval._description()
    }
    
    var debugDescription: String{
        return description
    }
    
    
    
    mutating func  _description()->String{
        
        guard _NodeListFlag == false else {
            return queue2.description()
        }
        return queue1.description()
    }
    
    
    mutating func size()->Int{
        guard _NodeListFlag == false else {
            return queue2.size()
        }
        return queue1.size()
    }
    
    mutating func put(elemnt:Element){
        guard queue1.size() <= defaultQueueSize else{
            _NodeListFlag = true
            queue2.put(elemnt: elemnt)
            return
        }
        queue1.put(elemnt: elemnt)
    }
    
    mutating func drop(){
        guard _NodeListFlag == false else {
            queue2.drop()
            return
        }
        queue1.drop()
    }
    
    mutating func fetchElement()->Element?{
        guard _NodeListFlag == false else {
            return  queue2.fetchElement()
        }
        return queue1.fetchElement()
    }
    
    
    init() {
    }
    
    
    
//    fileprivate mutating func outQueue<Element>()->some AbstractQueue{
//        return queue1
//    }

    private lazy var queue1  = _internalQueue<Element>.init()
    
    
    private var _NodeListFlag = false
    
    private lazy var queue2 : _internalNodeList<Element> = {
        var retval = _internalNodeList<Element>.init(with: nil)
        var temp:[Element] = [Element]()
        while queue1.size() > 0 {
            if let v = queue1.fetchElement() {
                temp.insert(v, at: 0)
            }
            queue1.drop()
        }
        for item in temp {
            retval.put(elemnt: item)
        }
        return retval
    }()
    
}

extension MessageQueue:Sendable{}



fileprivate protocol AbstractQueue:Sendable{
    
    associatedtype E
    
    mutating func size()->Int
    
    mutating func put(elemnt:E)
    
    mutating func drop()
    
    mutating func fetchElement()->E?
    
}



fileprivate struct _internalNodeList<Element>:AbstractQueue{
    
    
    
    mutating func description() -> String {
        var retval = ""
        var ptr : _internalNode<E>? = node
        while ptr?.next != nil{
            ptr = ptr?.next
            retval += " "
            retval += "\(String(describing: ptr?.element!))"
        }
        return retval
    }
    
    
    
    typealias E = Element
    
    
    mutating func put(elemnt: Element) {
        var ptr = getLast()
        var newNode = _internalNode.init(withElement: elemnt)
        ptr?.next = newNode
        newNode.pre = ptr
        _size += 1;
    }
    
    mutating func fetchElement() -> Element? {
        
        var ptr = getLast()
        return ptr?.element
    }
    
    
    
    
    mutating func size() -> Int {
        return _size
    }
    
    mutating func drop() {
        guard size() > 0 else {
            return
        }
        var ptr = getLast()
        ptr?.pre?.next = ptr?.next
        ptr?.pre = nil
        ptr?.next = nil
        _size -= 1
    }
  
    init(with element:E?) {
        node = _internalNode.init(withElement: nil)
        guard element != nil else {
            return
        }
        node.next = _internalNode.init(withElement: element)
        node.next?.pre = node
        _size += 1
    }
    
    
    private func getLast()->_internalNode<E>?{
        var ptr : _internalNode<E>? = node
        while ptr?.next != nil{
            ptr = ptr?.next
        }
        return ptr
    }
    
    //头结点
    private  var node : _internalNode<E>
    
    private var _size:Int = 0
}



fileprivate class _internalNode<Element>{

    var element:Element?
    
    
    init(withElement element:Element?) {
        self.element  = element
    }
    
    
    
    public var next:_internalNode?
    
    public var pre:_internalNode?
    
}



fileprivate struct _internalQueue<Element>:AbstractQueue{
    
    
    mutating func description() -> String {
        return smallQueus.description
    }
    
    
    typealias E = Element
    
    
    
    mutating func drop() {
        smallQueus.removeLast()
    }
    
    mutating func fetchElement()-> Element?{
        return smallQueus.last
    }
    
    
    
    
    
    mutating func put(elemnt: Element) {
        smallQueus.append(elemnt)
    }
    

    mutating func size() -> Int {
        return smallQueus.count
    }
    
    lazy var smallQueus = [Element].init()
}


