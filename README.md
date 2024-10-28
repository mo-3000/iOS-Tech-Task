# Moneybox iOS Technical Challenge

Welcome to my take on the Moneybox iOS Technical Challenge! 🎉 This app aims to provide a "light" version of the Moneybox experience, letting users log in, view their account balances, and check out their Moneybox savings. Here's a quick rundown of the solution and the approach I took.

## Overview 📝

The app consists of three main screens:
1. **Login Screen**: For existing users to log in securely.
2. **Account List Screen**: Displays a list of accounts, such as ISA and GIA, using a collection view with a clean and modern layout.
3. **Account Detail Screen**: Shows account details with a button to add money to the Moneybox (a fixed £10 increment).

I focused on providing a smooth user experience, following best practices in app architecture and coding standards.

## Key Features 🚀

### MVVM Architecture 🏛️
- I opted for the MVVM pattern to keep the codebase clean and maintainable. It separates the view logic from business logic, making it easier to test and extend.
- The view models handle the business logic and data manipulation, while the views remain focused on rendering the UI.

### Programmatic UI 📱
- The entire UI is built programmatically — no storyboards. This choice provides more flexibility and makes the layout code easier to tweak.
- It also reduces merge conflicts in version control since there are no large XML files being modified.

### Modern CollectionView with Diffable Data Source 📚
- I used a `UICollectionView` with a diffable data source for the account list, which is perfect for handling dynamic data.
- There's also a splash of animation when new items load, giving the app a polished look.
- The collection view is styled with a compositional layout to create a flexible and modern appearance.

### Dependency Injection 🔧
- The view models and helpers use dependency injection, which keeps the code loosely coupled and easy to test.
- This approach also allows us to swap out implementations for testing without changing the core logic.

### Error Handling 🛑
- Error states are managed gracefully with user-friendly messages.
- The UI updates dynamically based on the loading status (in progress, completed, or error) to provide feedback to the user.

### Unit Testing with Mocks and Stubs 🧪
- I included unit tests that use mocks and stubs to simulate things like API responses, making testing straightforward and reliable.
- Dependency injection is used here to inject mocked data providers into the view models.

### Async Image Fetching 📷
- Added an `AsyncImageFetcher` utility, which can handle loading images for accounts if we decide to display images in the future.

### Accessibility 🌍
- VoiceOver support is enabled through accessibility labels on interactive elements.

## Design Choices 🎨

### Clean and Modern UI
- I aimed for a minimalistic design with enough visual feedback to guide the user. 
- Animations make the app feel more alive—cells gently animate into place, giving the interface a fun touch.
- Colours and fonts were chosen for readability and visual appeal.

### Programmatic Views
- Building views in code helps maintain fine-grained control over the UI. It’s easier to configure constraints and animations, and the codebase becomes more flexible for future changes.

### Error Handling
- The app attempts to handle errors gracefully. If something goes wrong (like a failed network request), the user will see a friendly message with an option to retry.

### MVVM for Testability
- Using MVVM made it easy to isolate business logic in the view models, which allows for more granular unit testing.

## Challenges and Considerations 🧩

- **Bearer Token Expiration**: Since the token expires every 5 minutes, I made sure the app could gracefully handle expired sessions and prompt the user to log back in.
- **Data Refreshing**: The app refreshes data using pull-to-refresh and manages the loading states to show appropriate indicators.

## Running the App 🏃‍♂️

### Requirements
- Xcode 15 or later
- iOS 15+

1. Clone the repository and open `Moneybox.xcodeproj`.
2. Run the app on a simulator or a real device.
3. Log in with the test credentials provided in the brief:
   - **Username**: `test+ios2@moneyboxapp.com`
   - **Password**: `P455word12`

4. Explore the app! Check out the accounts list and try adding some money to the Moneybox.

## What's Next? 🤔

If I had more time, I would:

- **Implement a more sophisticated token refresh mechanism**: Currently, the app prompts the user to log back in when the token expires. I would improve this by automatically refreshing the token in the background, allowing for a seamless user experience.

- **Add more animations to the login screen and account detail interactions**: While there are some animations in place to enhance the app's polish, I would introduce additional animations to make transitions smoother and interactions more engaging. For example, animating form elements on the login screen or adding subtle motion effects when navigating to the account detail screen would further enrich the experience.

- **Introduce support for biometric authentication (Face ID/Touch ID)**: To enhance security and improve user convenience, I would add support for biometric authentication. This would allow users to log in quickly using Face ID or Touch ID, offering a secure and modern authentication experience.

- **Expand on unit tests and add UI tests for key user flows**: Although unit tests are included for the core business logic, I would further increase test coverage to include more edge cases. I would also add UI tests to verify critical user flows, such as the login process, account listing, and money addition, ensuring that the app behaves as expected under various conditions.

- **Leverage Combine for reactive UI experiences**: While I chose not to use reactive programming in this project to reduce complexity and make classes easier to test, I would implement Combine in larger projects to handle asynchronous events and data binding more effectively. Combine would enable a more reactive and declarative approach to managing UI updates, making the code more concise and responsive, especially when dealing with dynamic data streams.


## Conclusion 🏁

This project was a blast to work on! I aimed to create a solid starting point that follows best practices and delivers a pleasant user experience. Hopefully, it showcases my skills in iOS development, clean architecture, and user-friendly design.

Feel free to reach out if you have any questions or feedback! 😊
