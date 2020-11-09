# SpecialTechniquesiOS

## 03autolayoutprogram

### Step 1: added code in SceneDelagate.swift

```
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        //First step
        
        guard let windowScene = scene as? UIWindowScene else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()
    }

```
### Step 2: Simple Constraint add to View
```
import UIKit

class ViewController: UIViewController {

    private let myview: UIView = {
        let myview = UIView()
        myview.translatesAutoresizingMaskIntoConstraints = false
        myview.backgroundColor = .link
        return myview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .cyan
        view.addSubview(myview)
        addConstraints()
        
    }
    

    private func addConstraints(){
        var constraints = [NSLayoutConstraint]()
        
        //Add
        constraints.append(myview.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor))
        constraints.append(myview.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor))
        constraints.append(myview.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor))
        constraints.append(myview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor))
        
        //Active
        NSLayoutConstraint.activate(constraints)
    }
}

```
