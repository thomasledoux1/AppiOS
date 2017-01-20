//
//  MovieCollectionViewController.swift
//  NewApp
//
//  Created by Thomas on 04/01/2017.
//  Copyright © 2017 Thomas. All rights reserved.
//

import UIKit
import os.log


class MovieCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    //MARK : properties
    private let reuseIdentifier = "MovieCollectionViewCell"
    private let itemsPerRow  : CGFloat = 3
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    var movies = [Movie]()
    
    @IBAction func unwindToMovieList(sender : UIStoryboardSegue){
        if let srcViewCntrl = sender.source as? MovieViewController, let movie = srcViewCntrl.movie {
            if collectionView?.indexPathsForSelectedItems?.count != 0{
                let selectedIndexPathSingle = collectionView?.indexPathsForSelectedItems!.first!
                movies[selectedIndexPathSingle!.row] = movie
                collectionView!.reloadItems(at: collectionView!.indexPathsForSelectedItems!)
            }
            else{
                let newIndex = IndexPath(row: movies.count, section: 0)
                movies.append(movie)
                collectionView!.insertItems(at: [newIndex])
            }
            saveMovies()
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        if let savedMovies = loadMovies() {
            movies += savedMovies
        }
        else{
            loadSampleData()
        }
        
        self.installsStandardGestureForInteractiveMovement = true
        collectionView?.allowsMultipleSelection = false
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? ""){
        case "AddMovie" : os_log("Adding new movie", log : OSLog.default, type: .debug)
        case "ShowDetail" :
            guard let movieViewCntrl = segue.destination as? MovieViewController else{
                fatalError("unexpected destination")
            }
            guard let selectedMovieCell = sender as? MovieCollectionViewCell else{
                fatalError("unexpected sender")
            }
            guard let indexPath = collectionView?.indexPath(for: selectedMovieCell) else{
                fatalError("selected cell not displayed in collectionview")
            }
            let selectedMovie = movies[indexPath.row]
            movieViewCntrl.movie = selectedMovie
        default : fatalError("unexpected indentifier")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return movies.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MovieCollectionViewCell
        
        let movie =  movies[indexPath.row]
        
        cell.imageView.image = movie.photo
        cell.backgroundColor = UIColor.white
        
        
        return cell
    
    }
        
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        os_log("Moving items", log: OSLog.default, type : .debug)
        let temp = movies[sourceIndexPath.row]
        movies[sourceIndexPath.row] = movies[destinationIndexPath.row]
        movies[destinationIndexPath.row] = temp
    }
    
    
    
    private func loadSampleData(){
        let photo1 = UIImage(named: "movie1")
        let photo2 = UIImage(named: "movie2")
        let photo3 = UIImage(named: "movie3")
        
        let movie1 = Movie(name: "Star Wars : Episode 1", photo: photo1, rating : 6)!
        let movie2 = Movie(name: "Harry Potter And The Philosopher Stone", photo: photo2, rating : 7)!
        let movie3 = Movie(name: "Lord Of The Rings : Return Of The King", photo: photo3, rating : 8)!
        
        movies += [movie1, movie2, movie3]
    }
    
    private func saveMovies() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(movies, toFile: Movie.ArchiveURL.path)
        if isSuccessfulSave{
            os_log("save successful", log: OSLog.default, type: .debug)
        }
        else{
            os_log("save unsuccessful", log: OSLog.default, type: .error)

        }
        
    }
    
    private func loadMovies() -> [Movie]?{
        return NSKeyedUnarchiver.unarchiveObject(withFile : Movie.ArchiveURL.path) as? [Movie]
    }

}
