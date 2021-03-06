/* This file is part of mac2imgur.
*
* mac2imgur is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.

* mac2imgur is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.

* You should have received a copy of the GNU General Public License
* along with mac2imgur.  If not, see <http://www.gnu.org/licenses/>.
*/

import Foundation

class ScreenshotMonitor {
    
    var query: NSMetadataQuery
    var callback: (pathToImage: String) -> ()
    
    init(callback: (pathToImage: String) -> ()) {
        self.callback = callback
        
        query = NSMetadataQuery()
        
        // Only accept screenshots
        query.predicate = NSPredicate(format: "kMDItemIsScreenCapture = 1", argumentArray: nil)
        
        // Add observer
        NSNotificationCenter.defaultCenter().addObserver(self, selector: NSSelectorFromString("eventOccurred:"), name: NSMetadataQueryDidUpdateNotification, object: query)
        
        // Start query
        query.startQuery()
    }
    
    @objc func eventOccurred(notification: NSNotification) {
        if let info = notification.userInfo {
            if let itemsAdded = info["kMDQueryUpdateAddedItems"] as? NSArray {
                for item in itemsAdded {
                    let metadataItem = item as NSMetadataItem
                        
                    // Get the path to the screenshot
                    let screenshotPath: String = metadataItem.valueForKey(NSMetadataItemPathKey) as String
                        
                    println("Screenshot file event detected @ \(screenshotPath)")
                    
                    callback(pathToImage: screenshotPath)
                }
            }
        }
    }
}