# Repository Pattern

<img width="374" alt="스크린샷_2022-01-17_오후_5 25 14" src="https://user-images.githubusercontent.com/69891604/149791168-05d0e38b-e057-430b-b49d-f7ff4598fc0f.png">


### 레포지토리 패턴은 데이터의 추상화를 제공하여, 어플리케이션이 추상화된 인터페이스로 작업할 수 있게 해준다.

- 데이터 출처(로컬 DB? 서버 API)에 관계없이 동일한 인터페이스로 어플리케이션이 데이터를 사용할 수 있게 해준다.
- 레포지토리 패턴은 네트워킹이나, 인메모리 캐싱, 퍼시스턴스 스토리지(그냥 앱 내에 DB)를 위한 파사드(상위의 추상화된 인터페이스)를 제공한다. 이 파사드는 디스크나 클라우드에서 CRUD를 할 수 있다. 그래서 리포지토리 자체는 어떻게 데이터를 받아오고 저장하는지 알려주지 않는다.
- 레포지토리는 비동기적으로 CRUD 메서드를 제공한다. 그 내부의 구현은 stateless일수도 있고 stateful일 수도 있다. Stateless implementation은 데이터를 받은 뒤에 데이터를 계속 가지고 있지 않는다. 반면에 Stateful implementation 은 데이터를 저장한다. 컴포넌트들은 주로 stateful하고 인메모리에 데이터를 저장한다.
- 이 앱에서 레포지토리는 데이터 액세스를 위한 여러개의 층을 가지고 있다. 결국 레포지토리는 데이터가 어디서 온 것인지 모르고 쓸수 있게 만드는 것이다.
    - Cloud-remote-API layer
    - Persistent-store-API layer
    - in-Memory-cache layer
- `KooberUserSessionRepository`의 예시
    
    이 레포지토리에서는 Cloud REST API를 사용해서 usersession을 생성하고, 이 세션을 persistent store에 저장하는 역할을 한다. 새로운 유저가 생겨나면, `KooberUserSessionRepository`가 특정 메소드를 실행한다. 아무래도 REST API!
    
    결국 이러한 모든 것들은 보여지지 않은 채 이루어지는 것이다. 데이터의 출처도 알 수 없고, 앱단 DB로 가는지, 서버와 네트워킹하는지는 ViewModel은 알지 못한다. 즉, `KooberUserSessionRepository`는 내부의 구현을 보여주지 않는다. 이 메소드를 쓰는 사람은 내부를 모르기 때문에, 내부는 어떻게 바뀌어도 상관없고, 돌아가기만 하면 되는 것이다.
    
    즉, 레포지토리들은 구현에 대해서 굉장히 유동성을 보장한다. 그러면서 user Interface layer들에게는 어떠한 영향도 미치지 않는다. (ViewModel은 아무것도 모른다!) 
    

### UserSessionRepository는 UserSession에서 쓰일 메소드를 정의해놓은 프로토콜

```swift
public protocol UserSessionRepository {
  
  func readUserSession() -> Promise<UserSession?>
  func signUp(newAccount: NewAccount) -> Promise<UserSession>
  func signIn(email: String, password: String) -> Promise<UserSession>
  func signOut(userSession: UserSession) -> Promise<UserSession>
}
```

### KooberUserSessionRepository는 레포지토리

```swift
public class KooberUserSessionRepository: UserSessionRepository {

  // MARK: - Properties
  let dataStore: UserSessionDataStore
  let remoteAPI: AuthRemoteAPI

  // MARK: - Methods
  public init(dataStore: UserSessionDataStore, remoteAPI: AuthRemoteAPI) {
    self.dataStore = dataStore
    self.remoteAPI = remoteAPI
  }

  public func readUserSession() -> Promise<UserSession?> {
    return dataStore.readUserSession()
  }

  public func signUp(newAccount: NewAccount) -> Promise<UserSession> {
    return remoteAPI.signUp(account: newAccount)
            .then(dataStore.save(userSession:))
  }

  public func signIn(email: String, password: String) -> Promise<UserSession> {
    return remoteAPI.signIn(username: email, password: password)
            .then(dataStore.save(userSession:))
  }

  public func signOut(userSession: UserSession) -> Promise<UserSession> {
    return dataStore.delete(userSession: userSession)
  }
}
```

### 레포지토리 패턴의 결과

<img width="550" alt="스크린샷_2022-01-17_오후_5 57 26" src="https://user-images.githubusercontent.com/69891604/149791226-1507f772-1edc-4f3f-ad9c-0e0714b4b84b.png">

결국은 레포지토리 패턴은 데이터가 어디서 오는지 알수 없도록 한다.(프로토콜을 사용해서)

- `SignInViewModel`을 보면 `UserSessionRepository`의 의존성 주입을 받는다.
    
    이를 통해서 `SignInViewModel`은 `UserSessionRepository`에 정의된 메서드들을 사용할 수 있다. 하지만 ViewModel은 이 레포지토리의 구현이 어떻게 되어있는지는 알수 없을 뿐더러, 데이터의 출처도 역시 알 수 없다. → Decoupling이 되었다는 뜻이다.
    
- 이 현상은 사실 엄청난 의의를 나타내는데, 결국 caller는 구현을 알 수 없다는 것이고, 어떤 다른 뷰모델이 `UserSessionRepository` 를 주입받아서 구현을 모드는 것이다. 이말은 결국 다른 fake remote API나 in-memory store로 바꾸더라도, 프로토콜은 안바뀌니깐 사용가능하다.
- Repository Pattern을 사용하면서 정의된 인터페이스를 구현하는 Mock에 DI를 할 수 있게되면서 testable 해진다.

```swift
public class SignInViewModel {

  // MARK: - Properties
  let userSessionRepository: UserSessionRepository
  let signedInResponder: SignedInResponder

  // MARK: - Methods
  public init(userSessionRepository: UserSessionRepository,
              signedInResponder: SignedInResponder) {
    self.userSessionRepository = userSessionRepository
    self.signedInResponder = signedInResponder
  }
```

이를 통해서 ViewModel은 온전히 비즈니스 로직에만 집중하게 만들 수 있습니다. 

또한 ViewModel들간 Repository를 공유해서 데이터 일관성을 유지할수도 있습니다. 예를 들어 위의 `UserSessionRepository`는 `KooberUserSessionRepository` 가 채택하고 있는 protocol이다. 그러면서 ViewModel들은 UserSessionRepository 주입을 받으면서 KooberUserSessionRepository가 구현해 놓은 메소드들을 사용할 수 있다.

 

### 참고한 블로그와 책

[[Design Pattern] Repository패턴이란](https://eunjin3786.tistory.com/198)

[iOS: Repository pattern in Swift](https://haningya.tistory.com/232)

[Advanced iOS App Architecture, Chapter 5: Architecture: MVVM](https://www.raywenderlich.com/books/advanced-ios-app-architecture/v3.0/chapters/5-architecture-mvvm#toc-chapter-008-anchor-001)
