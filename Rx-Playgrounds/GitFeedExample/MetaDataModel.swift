//
//  MetaDataModel.swift
//  Rx-Playgrounds
//
//  Created by Birapuram Kumar Reddy on 1/15/18.
//  Copyright © 2018 KRiOSApps. All rights reserved.
//

import Foundation
import SwiftyJSON

struct MetaDataModel {
    var actorName : String
    var eventType : String

    init?(json:JSON) {
        if let metaDict = json.dictionary, let actor = metaDict["actor"]?.dictionary,let actorName = actor["login"]?.string,let type = metaDict["type"]?.string {
            self.actorName = actorName
            self.eventType = type
            return
        }
        return nil
    }

   /* func prepareMetaData(json:JSON) -> MetaDataModel? {
        if let repoInfoDict = json.dictionary {
            return MetaDataModel.init(metaDict: repoInfoDict)
        }
        return nil
    }*/
}
