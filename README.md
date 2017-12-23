# Movies-Countdown
Movies Countdown app for iOS

This app is my final project of Udacity's iOS Nanodegree!

# App Description 
Movies Countdown is an app for people who want to track (exactly) when their favorite upcoming movies going to be released.

# How To Run The App
This app uses themoviedb.org APIs. I included my API key within the project. However, I can't guarantee the API key will work forever.
If that the case, you just need to go to the themoviedb.org website and signup and get an API key (it is a simple process, just go to the themoviedb.org and follow the instructions there).
After you get your API key, in Xcode, go to the file Networking group, then the file TMDBAPIKey.swift.
In this file, there is a static constant called apiKey, delete its previous value and put your new API key there.
Run the project and it should work.

# How To Use The App
- First time you will open the app, you will have an empty list of upcoming movies
- tap + to start adding movies
- the add movie screen will get a sorted list of movies from today and forward.
- select the movie you like and an information screen about the movie you select will appear.
- if you wish to track the movie tap the add button (a message will appear that your movie added successfully to your list)
- you can continue browsing and adding more movies, or you can go back to your list of upcoming movies
- if you go back to your list, you will find the newly added movies on your list
- you can see to the right of each cell in the list how many days remaining until this movie will be released
- if a movie will be released today you will see the right box turned to green, and a "Today" text appears
- if a movie passed its release date, its right box will be red, and it will start counting days since its released
- selecting a movie in your list of upcoming movies will display a detail screen of the movie
- in the detail screen, you will see a countdown timer (from years to seconds!) of how much remaining until the movie will be released
- tap the info button to see additional information about the movie
- tap the delete button (the one with garbage icon) to delete the movie from your list
- tap the button with up and down arrows to switch the countdown box position up or bottom. This is useful because some movie posters include their title in the top and some in the bottom, so you can move the countdown box away from the title.
- tap the share button to create an image and share it wherever you like. The image that will be created will include the movie's poster and the countdown box at the top or bottom as you choose before tapping the share button.
