//
//  ImageGalleryTableViewController.swift
//  ImageGallery
//
//  Created by Mohamed Mohsen on 4/17/18.
//  Copyright © 2018 Mohamed Mohsen. All rights reserved.
//

import UIKit

class ImageGalleryTableViewController: UITableViewController{
    
    
    @IBOutlet var imageGalleryTableView: UITableView!
    @IBAction func addNewCategory(_ sender: UIBarButtonItem) {
        categories.append(categoryInfo(image: UIImage(named: "img"), name: "Untitled".madeUnique(withRespectTo: categories), number: 1400, categoryImages: []))
        imageGalleryTableView.reloadData()
    }
    
    private var categories = [categoryInfo]()

    struct categoryInfo{
        var image: UIImage?
        var name: String
        var number: Int
        var categoryImages: [UIImage]?
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageGalleryTableView.delegate = self
        imageGalleryTableView.dataSource = self
        categories.append(categoryInfo(image: UIImage(named: "img"), name: "My Graduation Project Photos", number: 1400, categoryImages: [UIImage(named: "img")!]))
        categories.append(categoryInfo(image: UIImage(named: "img"), name: "Facebook", number: 1200, categoryImages: [UIImage(named: "img")!,UIImage(named: "img")!]))
        categories.append(categoryInfo(image: UIImage(named: "img"), name: "Instagram", number: 2400, categoryImages: [UIImage(named: "img")!,UIImage(named: "img")!,UIImage(named: "img")!]))
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
//        if splitViewController?.preferredDisplayMode != .primaryOverlay {
//            splitViewController?.preferredDisplayMode = .primaryOverlay
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! ImageGalleryTableViewCell
        
        // Configure the cell...
        cell.cellImage.image = categories[indexPath.row].image
        cell.cellName.text = categories[indexPath.row].name
        cell.cellNumber.text = String(categories[indexPath.row].number)
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showImagesForSelectedCategory"{
            if let tableViewCell = sender as? ImageGalleryTableViewCell{
                if let collectionViewController = segue.destination as? ImageGalleryCollectionViewController{
                    if let indexPath = imageGalleryTableView.indexPath(for: tableViewCell){
                        assert(categories.indices.contains(indexPath.row), "ImageGalleryTableViewController.Prepare: Row# \(indexPath.row) is not a valid row")
                        let category = categories[indexPath.row]
                        collectionViewController.cellImages = category.categoryImages!
                    }
                }
            }
        }
    }

}


extension String {
    func madeUnique(withRespectTo otherCatrgories: [ImageGalleryTableViewController.categoryInfo]) -> String {
        var possiblyUnique = self
        var uniqueNumber = 1
        var otherStrings = [String]()
        for category in otherCatrgories{
            otherStrings.append(category.name)
        }
        while otherStrings.contains(possiblyUnique) {
            possiblyUnique = self + " \(uniqueNumber)"
            uniqueNumber += 1
        }
        return possiblyUnique
    }
}
