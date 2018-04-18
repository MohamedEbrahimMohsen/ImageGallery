//
//  ImageGalleryCollectionViewController.swift
//  ImageGallery
//
//  Created by Mohamed Mohsen on 4/17/18.
//  Copyright © 2018 Mohamed Mohsen. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class ImageGalleryCollectionViewController: UICollectionViewController, UICollectionViewDropDelegate, UICollectionViewDragDelegate {

    var cellImages = [UIImage]()
    
    @IBOutlet var imageGalleryCollectionView: UICollectionView!{
        didSet{
            imageGalleryCollectionView.dropDelegate = self
            imageGalleryCollectionView.dragDelegate = self
            imageGalleryCollectionView.delegate = self
            imageGalleryCollectionView.dataSource = self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return cellImages.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath)
    
        // Configure the cell
        if let customCell = cell as? ImageGalleryCollectionViewCell{
            customCell.collectionViewCellImage.image = cellImages[indexPath.item]
        }
    
        return cell
    }

    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        session.localContext = collectionView
        return dragItems(at: indexPath)
    }
    
    private func dragItems(at indexPath: IndexPath) -> [UIDragItem]{
        if let cellImage = (imageGalleryCollectionView.cellForItem(at: indexPath) as? ImageGalleryCollectionViewCell)?.collectionViewCellImage.image{
            let dragItem = UIDragItem(itemProvider: NSItemProvider(object: cellImage))
            dragItem.localObject = cellImage
            return [dragItem]
        }else{
            return []
        }
    }
 
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        return dragItems(at: indexPath)
    }
    
    //Handling Drop Interaction
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return (session.canLoadObjects(ofClass: NSURL.self) && session.canLoadObjects(ofClass: UIImage.self)) || session.canLoadObjects(ofClass: UIImage.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        let isSelf = session.localDragSession?.localContext as? UICollectionView == collectionView
        return UICollectionViewDropProposal(operation: isSelf ? .move : .copy , intent: .insertAtDestinationIndexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath = coordinator.destinationIndexPath ?? Constants.defualtDestinationIndexPathForAnyCollectionView
        for item in coordinator.items{
            if let sourceIndexPath = item.sourceIndexPath{ //In Case moving inside our collection view
                if let cellImage = item.dragItem.localObject as? UIImage{
                    imageGalleryCollectionView.performBatchUpdates({
                        cellImages.remove(at: sourceIndexPath.item)
                        cellImages.insert(cellImage, at: destinationIndexPath.item)
                        imageGalleryCollectionView.deleteItems(at: [sourceIndexPath])
                        imageGalleryCollectionView.insertItems(at: [destinationIndexPath])
                    })
                    coordinator.drop(item.dragItem, toItemAt: destinationIndexPath )
                }
            }else{ //In Case copying an image from the web into the gallery
                let placeholderContext = coordinator.drop(item.dragItem, to: UICollectionViewDropPlaceholder.init(insertionIndexPath: destinationIndexPath, reuseIdentifier: "DropPlaceholderCell"))
                //------
                item.dragItem.itemProvider.loadObject(ofClass: UIImage.self){(provider, error) in
                    
                    if let img = provider as? UIImage{
                        DispatchQueue.main.async{
                            placeholderContext.commitInsertion(dataSourceUpdates: {insertionIndexPath in
                                if destinationIndexPath.item == insertionIndexPath.item{
                                    self.cellImages.insert(img, at: destinationIndexPath.item)
                                }
                            })
                        }
                    }else{
                        placeholderContext.deletePlaceholder()
                    }
                }
                //------
            }
        }
    }
    
    
    
    private var image: UIImage?
    
    
    private var imageURL: URL? {
        didSet{
            image = nil
        }
    }
    
    private func fetchImage(url: URL){
        DispatchQueue.global(qos: .userInitiated).async {[weak self] in
            let urlContents = try? Data(contentsOf: url)
            DispatchQueue.main.async {
                if let imageDate = urlContents, url == self?.imageURL{
                    self?.image = UIImage(data: imageDate)
                }
            }
        }
    }
    //Ending Handling Drop Interaction
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //Constants
    private struct Constants{
        static var MinimumZoomScale: CGFloat = 0.25
        static var MaximumZoomScale: CGFloat = 5
        static var defualtDestinationIndexPathForAnyCollectionView: IndexPath = IndexPath(item: 0, section: 0)
    }
    
    
    // MARK: - Navigation
    /*
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
}


























