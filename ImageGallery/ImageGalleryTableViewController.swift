//
//  ImageGalleryTableViewController.swift
//  ImageGallery
//
//  Created by Mohamed Mohsen on 4/17/18.
//  Copyright © 2018 Mohamed Mohsen. All rights reserved.
//

import UIKit

class ImageGalleryTableViewController: UITableViewController{
    
//    struct objects{
//        var sectionName: String
//        var sectionObjects: [categoryInfo]
//    }
//
//    var tblViewObjects = [objects]()

    static var recentlyDeleted = [recentlyDeletedInfo]()
    
    struct recentlyDeletedInfo{
        var categoryIdentifier: String
        var deletedObject: Any //deletedObject can be anything (Category, Image ,... )
    }
    
    static func delete(object: Any , withIdentifer identifier: String){
        if let deletedCategory = object as? categoryInfo{
            addDeleted(category: deletedCategory)
        }else if let deletedImage = object as? UIImage{
            addDeleted(image: deletedImage, withCategoryName: identifier)
        }
    }
    
    static func addDeleted(image:UIImage, withCategoryName name: String){
        recentlyDeleted.append(recentlyDeletedInfo(categoryIdentifier: name, deletedObject: image))
    }
    static func addDeleted(category:categoryInfo){
        recentlyDeleted.append(recentlyDeletedInfo(categoryIdentifier: category.name, deletedObject: category))
    }
    
    func revertCategory(image: UIImage, withCategoryName name: String){
        if categories.filter({$0.name == name}).count == 1{
            for index in categories.indices{
                if (categories[index].name == name){categories[index].categoryImages?.append(image)}
            }
        }
    }
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
       
        categories.append(categoryInfo(image: UIImage(named: "img.jpg"), name: "My Photos", number: 1400,
        categoryImages: [UIImage(named: "img.jpg")!]))
        categories.append(categoryInfo(image: UIImage(named: "img2.jpg"), name: "Facebook", number: 1200,
        categoryImages: [UIImage(named: "img")!,UIImage(named: "img2.jpg")!]))
        categories.append(categoryInfo(image: UIImage(named: "img3.jpg"), name: "Instagram", number: 2400,
        categoryImages: [UIImage(named: "img")!,UIImage(named: "img2.jpg")!,UIImage(named: "img3.jpg")!]))
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
        return 2 //we have only two sections one for All and one only for the recently deleted
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section{
        case Constatns.NormalCategoriesSectionNumber: return categories.count
        case Constatns.RecentlyDeletedSectionNumber: return ImageGalleryTableViewController.recentlyDeleted.count
        default: return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! ImageGalleryTableViewCell
        
        // Configure the cell...
        if indexPath.section == Constatns.NormalCategoriesSectionNumber{
            cell.cellImage.image = categories[indexPath.row].image
            cell.cellName.text = categories[indexPath.row].name
            cell.cellNumber.text = String(categories[indexPath.row].number)
        }else if let deletedCategory = ImageGalleryTableViewController.recentlyDeleted[indexPath.row].deletedObject as? categoryInfo{
                cell.cellImage.image = deletedCategory.image
                cell.cellName.text = deletedCategory.name
                cell.cellNumber.text = String(deletedCategory.number)
        }else if let deletedImage = ImageGalleryTableViewController.recentlyDeleted[indexPath.row].deletedObject as? UIImage{
//                let onlyImageCell = tableView.dequeueReusableCell(withIdentifier: "onlyImageTableViewCell", for: indexPath) as! OnlyImageTableViewCell
//                onlyImageCell.imageCell.image = deletedImage
//                return onlyImageCell
            let onlyImageCell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as? OnlyImageTableViewCell
            onlyImageCell?.cellImage.image = deletedImage
            return onlyImageCell!
            }
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == Constatns.RecentlyDeletedSectionNumber {return "Recently Deleted"} else {return ""}
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
                        assert(categories.indices.contains(indexPath.row), "ImageGalleryTableViewController.Prepare: Row# \(indexPath.row) is not a valid row")
                        let category = categories[indexPath.row]
                        DispatchQueue.global(qos: .userInitiated).async{
                            collectionViewController.cellImages = category.categoryImages!
                            collectionViewController.title = category.name
                        }
                    }
                }
            }
        }
    }

    
    
    
    struct Constatns{
        static var NormalCategoriesSectionNumber: Int = 0
        static var RecentlyDeletedSectionNumber: Int = 1
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















