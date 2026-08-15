# login_api

login api -
api url- 'https://dummyjson.com/auth/login'
method: 'POST',
headers: { 'Content-Type': 'application/json' },
body: JSON.stringify({
    username: 'emilys',
    password: 'emilyspass',
    expiresInMins: 30, // optional, defaults to 60
})

Step 1 -
- Create the Flutter project
  - flutter create login_api
  - cd login_api

- Add the http pakage
  - flutter pub add http

Step 2 -
- Create Model Service Screen

- Understand the POST request
  - POST URL - https://dummyjson.com/auth/login
  - Headers - Content-Type': 'application/json 
  - Request body - {
    "username": "emilys",
    "password": "emilyspass",
    "expiresInMins": 30
    }
  - Response - {
    "accessToken": "ey.aa.c1",
    "refreshToken": "ey.aa.E0",
    "id": 1,
    "username": "emilys",
    "email": "emily.johnson@x.dummyjson.com",
    "firstName": "Emily",
    "lastName": "Johnson",
    "gender": "female",
    "image": "https://dummyjson.com/icon/emilys/128"
    }

- Dart -
  - request -
    - Dart Map -> jsonEncode() -> JSON String -> http.post()
  - response -
    - response.body -> jsonDecode() -> Dart Map

- Service - login() -> POST API -> statusCode -> response.body -> print()
-----------------------------------------------------------------------------