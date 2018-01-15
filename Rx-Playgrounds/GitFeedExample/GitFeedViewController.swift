//
//  GitFeedViewController.swift
//  Rx-Playgrounds
//
//  Created by Birapuram Kumar Reddy on 1/15/18.
//  Copyright © 2018 KRiOSApps. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Foundation
import SwiftyJSON

class GitFeedViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var results : [MetaDataModel]!
    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        let repoName = "ReactiveX/RxSwift"

        let requestObservable = Observable.from([repoName])
            .map {(repoString) in URL(string: "https://api.github.com/repos/\(repoString)/events")!}
            .map {(repoURL) in URLRequest(url: repoURL)}
            /*.flatMap { repoURLRequest -> Observable<(response:HTTPURLResponse,data:Data)> in
                return URLSession.shared.rx.response(request: repoURLRequest)
            }*/
            // instead of flatmap, i used map and trimming out the observable with flatmap.
            .map { return URLSession.shared.rx.response(request: $0)}
            .flatMap {$0}
            .share()

       let requestObserver = requestObservable
            .filter {response,_ in
                200..<300 ~= response.statusCode
            }
            .map { _,data  -> [JSON] in
                let json = JSON(data)
                if let jsonArray = json.array {
                    return jsonArray
                }
                return []
            }
            .map({ (jsonArray)  in
                 jsonArray.flatMap { MetaDataModel.init(json: $0) }
            })
            .observeOn(MainScheduler.instance)
            .subscribe(onNext:{ self.results = $0; self.tableView.reloadData() })

        requestObserver.disposed(by: bag)
    }

    /*func processJSON(json:JSON) {
            if let array = json.array {
                results = array.flatMap { MetaDataModel.init(json: $0)}
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
    }*/
}

extension GitFeedViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.results == nil {
            return 0
        }
        return self.results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gitFeedCell", for: indexPath) as! GitFeedCell
        let metaModel = self.results[indexPath.row]
        cell.configureCell(metaData: metaModel)
        return cell
    }
}
