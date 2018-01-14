//: Playground - noun: a place where people can play

import UIKit
import RxSwift
import RxCocoa

func exampleName(_ name:String) {
    print("\n-------\(name)-----------\n")
}


let bag = DisposeBag()

exampleName("Publish Subject")
let publishSubject = PublishSubject<Int>()

//emitting the events. as of now no one is registed as a subscribers. so these events will be not emitted to any one.
publishSubject.on(Event.next(10))
publishSubject.onNext(20)

//now, we have one observer. from now onwards, this observer will get the events emitted by subject.
publishSubject.subscribe(onNext:{ print($0)}){print("disposed")}.disposed(by: bag)

publishSubject.onNext(30)
publishSubject.onCompleted()
//once the subject completed or error out, it is not going to emit any events.
publishSubject.onNext(40)

//once, subject is completed and if any new observers subscribe to the subject, it will send onCompleted event.
publishSubject.subscribe(onCompleted:{print("Subject stopped emitting events")})


exampleName("Behaviour Subject")
let behaviourSubject = BehaviorSubject<Int>(value: 100)
//whenever someone subscribes, they will get the latest emitted value. That is the  reason, we have to create the behavior subject with default event.
behaviourSubject.subscribe(onNext:{ print("subscriber 1) \($0)")})
behaviourSubject.onNext(200)

//200 is the latest emitted event, so subscriber 2 will get the 200 as the value
behaviourSubject.subscribe(onNext:{ print("subscriber 2) \($0)")})

exampleName("Replay Subject")
let replaySubject = ReplaySubject<Int>.create(bufferSize: 2)

// right now, the array is empty. So it will not emit any values.
replaySubject.subscribe(onNext:{print("subscriber 1) \($0)")})

//once we emit 1000, the subscriber 1 will get the onNext event. we have 1000 in our replay array.
replaySubject.onNext(1000)

//when subscriber 2 subscribes, he will be immediately get on OnNext events with array values.
replaySubject.subscribe(onNext:{ print("subscriber 2) \($0)")})

// emitted one more event, now array looks like [1000,2000]
replaySubject.on(Event.next(2000))

print("\n")
//when subscriber 2 subscribes, he will be immediately get on OnNext events with array values.
replaySubject.subscribe(onNext:{ print("subscriber 3) \($0)")})

exampleName("Variable Subject")
let variableSubject = Variable<Int>.init(10000)
variableSubject.asObservable().subscribe(onNext:{print($0)})
variableSubject.value
variableSubject.value = 20000



