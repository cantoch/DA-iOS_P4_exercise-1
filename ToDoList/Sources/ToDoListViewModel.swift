import SwiftUI

final class ToDoListViewModel: ObservableObject {    /*final class est une classe qui ne peut pas être héritée*/
    // MARK: - Private properties
    private var allItems: [ToDoItem] = []    //Création d'une propriété de la class ToDoListViewModel un tableau utilisant le model ToDoIdem
    private var filteredItems: [ToDoItem] = []
    private var currentFilterIndex: Int = 0
    
    private let repository: ToDoListRepositoryType
    
    
    // MARK: - Init
    
    init(repository: ToDoListRepositoryType) {
        self.repository = repository
        self.allItems = repository.loadToDoItems()
        self.toDoItems = allItems    //Copie des taches pour un filtrage propre sans suppression des items à chaque filtrage
    }
    
    // MARK: - Outputs
    
    /// Publisher for the list of to-do items.
    @Published var toDoItems: [ToDoItem] = [] {
        didSet {
            repository.saveToDoItems(toDoItems)
        }
    }
    
    // MARK: - Inputs
    
    // Add a new to-do item with priority and category
    func add(item: ToDoItem) {
        allItems.append(item)
        applyFilter(at: currentFilterIndex)
    }
    
    /// Toggles the completion status of a to-do item.
    func toggleTodoItemCompletion(_ item: ToDoItem) {
        if let index = allItems.firstIndex(where: { $0.id == item.id }) {
            allItems[index].isDone.toggle()
            applyFilter(at: currentFilterIndex)
        }
    }
    
    /// Removes a to-do item from the list.
    func removeTodoItem(_ item: ToDoItem) {
        allItems.removeAll { $0.id == item.id }
        applyFilter(at: currentFilterIndex)
    }
    
    /// Apply the filter to update the list.
    func applyFilter(at index: Int) {
        switch index {
        case 0:
            toDoItems = allItems
        case 1:
            toDoItems = allItems.filter { $0.isDone }
        case 2:
            toDoItems = allItems.filter { !$0.isDone }
        default:
            break
        }
        currentFilterIndex = index
        // Énumération des filtres qui seront choisis dans la view par l'intermediaire du filterIndex
    }
}
