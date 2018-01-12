import UIKit
import RxSwift


// utility function

func provideHeadLine(_ name:String) {
    print("---------------------------------------------\(name)----------------------------------------------")
}

let bag = DisposeBag()
// Observable

let observable = Observable<Int>.of(10)

class simpleSubscribe1 : ObserverType {
    typealias E = Int
    // if let.
    /*func on(_ event: Event<Int>) {
        if let element = event.element {
            print(element)
        }else if let error = event.error {
            print(error)
        }
        if event.isStopEvent {
            print("Emitted the stop event")
        }

        if event.isCompleted {
            print("Completed the events")
        }
    }*/
    //switch
    func on(_ event: Event<Int>) {
        switch event {
        case .next(let element):
            print(element)
        case .error(let error):
            print(error)
        case .completed:
            print("Completed")
        }
    }
}

observable.subscribe(simpleSubscribe1())

observable.subscribe { (event) in
    print(event.element ?? (event.isCompleted ? "Completed" : "Error" ))
}

observable.subscribe(onNext: { print($0)}, onError: {print($0)}, onCompleted: {print("Completed")}) { print("Disposed")}

Observable<Int>.of(10,20).subscribe(onNext: { print($0)}, onError: {print($0)}, onCompleted: {print("Completed")}) { print("Disposed")}.disposed(by: bag)


enum MyError : Error {
    case SimpleError
}


provideHeadLine("Observable Create")

Observable<String>.create { (observer) -> Disposable in
    observer.onNext("This is kumar")
    observer.onError(MyError.SimpleError)
    observer.onCompleted()
    observer.onNext(" ? ")
    return Disposables.create()
}.subscribe(
    onNext: {print($0) },
    onError: {print($0) },
    onCompleted: { print("Completed") },
    onDisposed: {print("Disposed") }
).disposed(by: bag)

provideHeadLine("Observable Factory")

var flag = true
let observableFactory = Observable<Int>.deferred { () -> Observable<Int> in
    flag = !flag
    if flag {
        return Observable.of(1)
    }else{
        return Observable.of(10)
    }
}

observableFactory.subscribe( { print( $0.element ?? 0 ) })
observableFactory.subscribe( { print( $0.element ?? 0 ) })

provideHeadLine("Traits")

// Singles will emit either a .success(value) or .error event.
// A Completable will only emit a .completed or .error event.
// Maybe can either emit a .success(value), .completed, or .error.”

Single<Int>.create { (event) -> Disposable in
    event(SingleEvent.success(10))
    return Disposables.create()
    }.subscribe { (event) in
        switch event {
        case .success(let element):
            print("Sucess with element \(element)")
        case .error(let error):
            print("Error info \(error)")
        }
}







