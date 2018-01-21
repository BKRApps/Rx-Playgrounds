import UIKit
import RxSwift

func exampleName(_ name:String) {
    print("\n-------\(name)-----------\n")
}

let bag = DisposeBag()

exampleName("Start with")

Observable.of(1,2,3,4)
    .startWith(0) // starting value to emit
    .subscribe(onNext:{ print($0)})
    .disposed(by: bag)

exampleName("Concat")

let concatObs1 = PublishSubject<Int>()
let concatObs2 = PublishSubject<Int>()

Observable.concat([concatObs1,concatObs2])
    .subscribe(onNext:{ print($0)})
    .disposed(by: bag)

concatObs1.onNext(10)
concatObs2.onNext(1000) // it is not going to emit because it will concat the events after concatOb1 completed or errored out.
concatObs1.onNext(20)
concatObs1.onCompleted()
concatObs2.onNext(1000) // now, it will be emitted

let concatObs3 = PublishSubject<String>()
let concatObs4 = PublishSubject<String>()

concatObs3.concat(concatObs4)
    .subscribe(onNext:{print($0)})
    .disposed(by: bag)

concatObs4.onNext("it will not get printed")
concatObs3.onCompleted()
concatObs4.onNext("it will get printed") // it will be emitted once the self observable completed

exampleName("Concat map => flat map")

let citiesInCountries = ["india":Observable.of("hyderabad","bengalurur"),"usa":Observable.of("california","nyc")]

Observable.of("india","usa")
    .concatMap { (country)  in return citiesInCountries[country]! }
    .subscribe(onNext:{ print($0)})
    .disposed(by: bag)

exampleName("Merge")

let mergeObs1 = PublishSubject<Int>()
let mergeObs2 = ReplaySubject<Int>.create(bufferSize: 2)

let source = Observable.of(mergeObs1,mergeObs2)
source
    .merge(maxConcurrent: 1) // it means, it will emit only mergeObs1, once it is complete, then it will emit mergeObs2. replace ReplaySubject with Publish subject and check it.
    .subscribe(onNext:{ print($0)})
    .disposed(by: bag)

mergeObs1.onNext(1)
mergeObs2.onNext(10)
mergeObs1.onNext(2)
mergeObs2.onNext(20) // merging all the emitted values from all the observables

mergeObs1.onCompleted()
mergeObs2.onNext(30)

exampleName("Combine Latest")

let combineEx1 = PublishSubject<String>()
let combineEx2 = PublishSubject<Int>()

Observable.combineLatest(combineEx1, combineEx2) { (v1,v2) in
        return (v1,v2)
    }
    .subscribe(onNext : { print($0)})
    .disposed(by: bag)

combineEx1.onNext("Hello")
combineEx2.onNext(10)

combineEx2.onNext(20) // pick the latest from the observables and return the selector.
combineEx1.onNext("World")
combineEx1.onNext("Swift")

combineEx1.onCompleted()
combineEx2.onNext(30)

exampleName("Zip")

let zipEx1 = PublishSubject<String>()
let zipEx2 = PublishSubject<Int>()

zipEx1.distinctUntilChanged()
Observable
    .zip(zipEx1, zipEx2) { (v1,v2) in
    return (v1,v2)
    }
    .subscribe(onNext : { print($0)})
    .disposed(by: bag)

zipEx1.onNext("Hello")
zipEx2.onNext(10)

zipEx2.onNext(20) // pick the latest from the observables and return the selector.
zipEx1.onNext("World")
zipEx1.onNext("Swift")

combineEx1.onCompleted()
combineEx2.onNext(30)

exampleName("Triggers : With Latest From && Sample")

let button = PublishSubject<Void>()
let firstNameTF = PublishSubject<String>()

button
    .withLatestFrom(firstNameTF)
    .distinctUntilChanged() // uncomment this and replace withLatestFrom with text firstNameTF.sample(button)
    .subscribe(onNext:{print($0)})

firstNameTF.onNext("kum")
firstNameTF.onNext("kuma")
firstNameTF.onNext("kumar reddy")
button.onNext(())
button.onNext(())

exampleName("Switches")
exampleName("amb")
// It waits for any of them to emit an element, then unsubscribes from the other one.

let ambEx1 = PublishSubject<Int>()
let ambEx2 = PublishSubject<Int>()

ambEx1.amb(ambEx2)
    .subscribe(onNext:{print($0)})

ambEx1.onNext(10)
ambEx2.onNext(10000)
ambEx1.onNext(20)

exampleName("Switch Latest")

let first = PublishSubject<Int>()
let second = PublishSubject<Int>()
let third = PublishSubject<Int>()

let switchEx = PublishSubject<Observable<Int>>()

switchEx.switchLatest()
    .subscribe(onNext:{print($0)})

first.onNext(1) // no use
switchEx.onNext(first) // right now, it will switched to first observable
second.onNext(10) // no use
first.onNext(1)

switchEx.onNext(second)
second.onNext(10) // now, 10 event will be emitted.

exampleName("reduce")

Observable.of(1,2,3,4,5,6)
    .reduce(0, accumulator: +)
    .subscribe({print($0)})

exampleName("scan")

Observable.of(1,2,3,4,5,6)
    .scan(0, accumulator: +)
    .subscribe({print($0)})

