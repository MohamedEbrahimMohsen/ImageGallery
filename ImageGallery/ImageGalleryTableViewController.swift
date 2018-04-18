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
    
    private var categories = [categoryInfo]()

    private struct categoryInfo{
        var image: UIImage?
        var name: String
        var number: Int
        var categoryImages: [UIImage]?
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageGalleryTableView.delegate = self
        imageGalleryTableView.dataSource = self
        categories.append(categoryInfo(image: UIImage(named: "img"), name: "My Photos", number: 1400, categoryImages: []))
        categories.append(categoryInfo(image: UIImage(named: "img"), name: "Facebook", number: 1200, categoryImages: []))
        categories.append(categoryInfo(image: UIImage(named: "img"), name: "Instagram", number: 2400, categoryImages: []))
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if splitViewController?.preferredDisplayMode != .primaryOverlay {
            splitViewController?.preferredDisplayMode = .primaryOverlay
        }
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
//        cell.cellImage.layer.cornerRadius = cell.cellImage.bounds.width / 6
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
