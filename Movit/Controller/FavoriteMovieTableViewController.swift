import UIKit
import RealmSwift



class FavoriteMovieTableViewController: UITableViewController {
    let realm = try! Realm()
    
    var favoriteMovies: RealmSwift.Results<MovieModel>?
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItem()
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdateFavorites(notification:)), name: Notification.Name("DidUpdateFavoritesNotification"), object: nil)
        
    }
    
    @objc func didUpdateFavorites(notification: Notification) {
        loadItem()
    }
    
    
    //MARK: - FavoriteMovieTableViewController Datasource & Delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteMovies?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteMovieTableViewCell", for: indexPath) as! FavoriteMovieTableViewCell
        
        if let movieData = favoriteMovies?[indexPath.row] {
            cell.configure(with: movieData)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    
    func loadItem() {
        favoriteMovies = realm.objects(MovieModel.self)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
        guard let cell = sender.superview?.superview as? FavoriteMovieTableViewCell,
                  let indexPath = tableView.indexPath(for: cell) else {
                return
            }
        let alert = UIAlertController(title: "This movie has been removed", message: "", preferredStyle: .alert)
        do {
            try self.realm.write {
                if let movieData = favoriteMovies?[indexPath.row] {
                    if let favoriteMovie = favoriteMovies?.filter("title = %@", movieData.title).first {
                        self.realm.delete(favoriteMovie.genreList)
                        self.realm.delete(favoriteMovie)
                    }
                }
            }
        } catch {
            print("Error saving new items, \(error)")
        }
        present(alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            alert.dismiss(animated: true, completion: nil)
            self.tableView.reloadData()
        }
    }
}

//MARK: - Searchbar Delegate
extension FavoriteMovieTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        favoriteMovies = favoriteMovies?.filter("title CONTAINS[cd] %@", searchBar.text!)
        if searchBar.text?.count == 0 {
            loadItem()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
        tableView.reloadData()
    }
    
}

