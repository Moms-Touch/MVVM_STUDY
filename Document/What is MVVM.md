# MVVM이란?

아래의 링크는 이 게시물의 원본이다.

[Design Patterns by Tutorials: MVVM](https://www.raywenderlich.com/34-design-patterns-by-tutorials-mvvm)

## MVVM은 Model-View-ViewModel(MVVM)

- 모델은 앱 데이터를 가지는데, 주로 struct, class를 무관한다.
- 뷰는 보여지고, 스크린의 control을 맡는다. UIView의 자식들이다.
- 뷰모델은 모델의 정보를 뷰에 보여질 새로운 정보들로 변경한다. 뷰모델들은 보통 class로 만든다. 이유는 참조로 돌아다니기 위해서!
- MVVM은 MVC의 단점을 잘 보완할 수 있다고 한다. 이미 뷰컨트롤러는 여러 역할을 이미 하고 있기 때문에, MVVM은 Massive viewController를 해결하는데, 하나의 방법이 될 수 있다.

### MODEL

---

예시코드에서 모델이 있다고 가정한다.

```swift
struct Pet {
  
  public enum Rarity {
     case common
     case uncommon
     case rare
     case veryRare
   }
   
   public let name: String
   public let birthday: Date
   public let rarity: Rarity
   public let image: UIImage
   
   public init(name: String,
               birthday: Date,
               rarity: Rarity,
               image: UIImage) {
     self.name = name
     self.birthday = birthday
     self.rarity = rarity
     self.image = image
   }
  
}
```

`Pet` 이라는 모델을 만들었는데, 여기에는 뭐 다양한 속성이 있다. 이 `Pet` 모델을 뷰모델로 바꿔 볼 수 있다. 이 뷰모델을 결국 뷰에서 보여져야할 모양으로 다시 정보를 바꾸는 작업을 실행한다. 기존 MVC에서는 Model에서 controller로 데이터가 오면 controller가 이 작업을 수행했지만, 이제는 뷰모델이 이 일을 한다.

### ViewModel

---

```swift
final class PetViewModel {
  
  // 1
  private let pet: Pet
  private let calendar: Calendar
  
  init(pet: Pet) {
    self.pet = pet
    self.calendar = Calendar(identifier: .gregorian)
  }
  
  // 2
  public var name: String {
    return pet.name
  }
  
  public var image: UIImage {
    return pet.image
  }
  
  // 3
  public var ageText: String {
    let today = calendar.startOfDay(for: Date())
    let birthday = calendar.startOfDay(for: pet.birthday)
    let components = calendar.dateComponents([.year],
                                             from: birthday,
                                             to: today)
    let age = components.year!
    return "\(age) years old"
  }
  
  // 4
  public var adoptionFeeText: String {
    switch pet.rarity {
    case .common:
      return "$50.00"
    case .uncommon:
      return "$75.00"
    case .rare:
      return "$150.00"
    case .veryRare:
      return "$500.00"
    }
  }
}

extension PetViewModel {
  func configure(_ view: PetView) {
    view.nameLabel.text = name
    view.ageLabel.text = ageText
    view.adoptionFeeLabel.text = adoptionFeeText
    view.imageView.image = image
  }
}
```

1. 여기서 `pet` 과 `calendar` 이라는 저장 프로퍼티를 만들고, `init` 에서 초기화를 시켜준다.
2. 저장프로퍼티를 활용해서 계산 프로퍼티를 만들 수 있다. 이러한 계산 프로퍼티를 활용해서 우리는 뷰모델을 뷰에서 더 잘 활용할 수 있다. 
3. `ageText` 라는 계산 프로퍼티는 오늘과 생일을 가지고 와서 강아지의 나이를 계산해서 Return 해준다. 이런 식으로, 뷰모델에서는 뷰에 필요한 연산, 작업을 모두 실행한다.
4. 필요한 경우에 configure이라는 함수를 만들어서 다양한 view에 대응을 할 경우에 사용할 수 있다. 이러면 view 측면에서 사용하는 코드의 길이가 짧아질 것이다.

### View

---

```swift
class ViewController: UIViewController {
  
  let birthday = Date(timeIntervalSinceNow: (-2 * 86400 * 366))
  let image = UIImage(named: "stuart")!
  

  override func viewDidLoad() {
    super.viewDidLoad()
    let stuart = Pet(name: "Stuart", birthday: birthday, rarity: .veryRare, image: image)
    let viewModel = PetViewModel(pet: stuart)
    
    let frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    let petView = PetView(frame: frame)
    petView.translatesAutoresizingMaskIntoConstraints = false
    
    viewModel.configure(petView)
    
    view.addSubview(petView)
    petView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    petView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    petView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7).isActive = true
    petView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
  }

}
```

뷰에서 보면, 뷰는 뷰모델을 가지고 있는 것을 알 수 있다. 뷰에서 뷰모델을 가진 뒤에, 뷰모델의 `configure` 함수를 활용해서 뷰의 내용을 채워 줄 수 있다.
