//
//  ImageGalleryTableViewController.swift
//  ImageGallery
//
//  Created by Mohamed Mohsen on 4/17/18.
//  Copyright © 2018 Mohamed Mohsen. All rights reserved.
//

import UIKit

class ImageGalleryTableViewController: UITableViewController{
    
    struct objects{
        var sectionName: String
        var sectionObjects: [categoryInfo]
    }
    
    var tblViewObjects = [objects]()
    var x = 7
    static var RecentlyDeleted = [String:[UIImage]]()
    func addDeleted(image:UIImage, withCategoryName name: String){
        tblViewObjects[1].sectionObjects[0].categoryImages?.append(image)
    }
    func revertCategory(image: UIImage, withCategoryName name: String){
        if tblViewObjects[0].sectionObjects.filter({$0.name == name}).count == 1{
            for index in tblViewObjects[0].sectionObjects.indices{
                if (tblViewObjects[0].sectionObjects[index].name == name){tblViewObjects[0].sectionObjects[index].categoryImages?.append(image)}
            }
        }
    }
    @IBOutlet var imageGalleryTableView: UITableView!
    @IBAction func addNewCategory(_ sender: UIBarButtonItem) {
        tblViewObjects[0].sectionObjects.append(categoryInfo(image: UIImage(named: "img"), name: "Untitled".madeUnique(withRespectTo: tblViewObjects[0].sectionObjects), number: 1400, categoryImages: []))
        imageGalleryTableView.reloadData()
    }
    
    //private var categories = [categoryInfo]()

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
        tblViewObjects = [objects(sectionName: "", sectionObjects: []) , objects(sectionName: "Recently Deleted", sectionObjects: [])]
        tblViewObjects[0].sectionObjects.append(contentsOf: [categoryInfo(image: UIImage(named: "img.jpg"), name: "My Photos", number: 1200,
        categoryImages: [UIImage(named: "img.jpg")!,UIImage(named: "img2.jpg")!])])
        tblViewObjects[0].sectionObjects.append(contentsOf: [categoryInfo(image: UIImage(named: "img2.jpg"), name: "Facebook", number: 1200,
        categoryImages: [UIImage(named: "img.jpg")!,UIImage(named: "img2.jpg")!])])
         tblViewObjects[0].sectionObjects.append(contentsOf: [categoryInfo(image: UIImage(named: "img2.jpg"), name: "Twiter", number: 1200,
        categoryImages: [UIImage(named: "img.jpg")!,UIImage(named: "img2.jpg")!])])
         tblViewObjects[0].sectionObjects.append(contentsOf: [categoryInfo(image: UIImage(named: "img3.jpg"), name: "Instagram", number: 1200,
        categoryImages: [UIImage(named: "img.jpg")!,UIImage(named: "img2.jpg")!])])
        
        
        tblViewObjects[1].sectionObjects.append(contentsOf: [categoryInfo(image: UIImage(named: "img3.jpg"), name: "Deleted Images", number: 1200,
        categoryImages: [])])
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
        return tblViewObjects.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tblViewObjects[section].sectionObjects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! ImageGalleryTableViewCell
        
        // Configure the cell...
        cell.cellImage.image = tblViewObjects[indexPath.section].sectionObjects[indexPath.row].image
        cell.cellName.text = tblViewObjects[indexPath.section].sectionObjects[indexPath.row].name
        cell.cellNumber.text = String(tblViewObjects[indexPath.section].sectionObjects[indexPath.row].number)
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tblViewObjects[section].sectionName
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
                var destination = segue.destination
                if let navigationControl = destination as? UINavigationController{
                    destination = navigationControl.visibleViewController ?? navigationControl
                }
                if let collectionViewController = destination as? ImageGalleryCollectionViewController{
                    if let indexPath = imageGalleryTableView.indexPath(for: tableViewCell){
                        assert(tblViewObjects[0].sectionObjects.indices.contains(indexPath.row), "ImageGalleryTableViewController.Prepare: Row# \(indexPath.row) is not a valid row")
                        let category = tblViewObjects[0].sectionObjects[indexPath.row]
                        DispatchQueue.global(qos: .userInitiated).async{
                            collectionViewController.cellImages = category.categoryImages!
                            collectionViewController.title = category.name
                        }
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















