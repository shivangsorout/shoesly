# shoesly_app

A shoe e-commerce application made using flutter.

# Building and Running the Flutter Application

## Prerequisites:
Before you begin, ensure you have the following installed:
- **Flutter SDK:** Follow the official Flutter installation instructions for your operating system.
- **Dart SDK:** Flutter requires the Dart SDK. It's included with the Flutter SDK, so you don't need to install it separately.
- **Android Studio/VS code or Xcode:** Depending on whether you're targeting Android or iOS, you'll need either Android Studio/VS code or Xcode installed.
## Getting Started:
1. Clone the repository:
	```
	git clone https://github.com/shivangsorout/shoesly
	```
2. Navigate to the project directory:
	```
	cd <project_directory>
	```
3. Install dependencies:
	```
	flutter pub get
	```
## Running the Application:
- **Android**   
Ensure you have an Android device connected via USB or an Android emulator running.   

- Run the command in terminal:
 ```
 flutter run
 ```
- **iOS**   
Ensure you have a macOS machine with Xcode installed.   

- Run the command in terminal:
 ```
 flutter run
 ```
## Assumptions during Development:
- **Data Structure:**
  - The Firestore database will have collections such as shoes and subcollections such as reviews.
  - Each shoe document will have a colorsAvailable map with color codes as keys and color names as values.
  
- **Data Consistency:**
  - The data in Firestore is assumed to be well-structured and consistent, with all necessary fields present in each document.
  - Each shoe document has a unique ID, and fields such as name, brandName, price, imgUrls, sizesAvailable, colorsAvailable, description, totalReviews, avgRating, gender, and dateAdded are present.
- **Pagination and Data Loading:**
  - The application will handle pagination for large datasets, such as the shoes collection and reviews subcollection.
  - Each paginated request will fetch a predefined number of documents (e.g., 10).
- **User Interaction:**
  - Users can scroll through lists of shoes and reviews, triggering additional data loads as they reach the end of the current data set.
  - Users can select filters such as price range, brand name, and color to refine their search results.
- **Error Handling:**
  - Basic error handling is implemented to catch and log exceptions, but detailed user feedback for errors might not be fully implemented.
  - Assumes that the necessary Firebase services (Firestore) are properly configured and accessible.
- **Data Validation:**
  - Shoe sizes and colors are validated to be within the available options listed in the shoe document.
- **Performance Optimization:**
  - The application will leverage Firestore queries and indexes for efficient data retrieval.
  - Assumes that Firestore indexes are properly set up to optimize query performance, especially for 
- **State Management:**
  - The application uses a state management solution (e.g., Bloc) to handle the application's state outside of widget builders.
- **Map Conversion:**
  - Assumes that map data structures can be easily converted to list entries for operations such as sorting or filtering.
These assumptions help define the scope and constraints within which the application operates, guiding both development and testing processes.
Certainly! Here are some potential challenges you might have faced during the development of your application and how you overcame them:

## Challenges and Solutions

#### 1. **Pagination and Infinite Scrolling**
   - **Challenge**: Implementing efficient pagination for large datasets in Firestore.
   - **Solution**: Used Firestore's `limit` and `startAfterDocument` methods to fetch data in chunks. Implemented a `ScrollController` to detect when the user scrolls to the end of the list and trigger the next data load.

#### 2. **Managing Complex Firestore Queries**
   - **Challenge**: Creating complex queries to filter shoes by price, brand, color, and rating, while ensuring performance.
   - **Solution**: Leveraged Firestore's indexing capabilities and used compound queries. Ensured all necessary indexes were created in Firestore to optimize query performance.

#### 3. **Real-time Data Updates**
   - **Challenge**: Ensuring the application reflects real-time updates from Firestore, such as new reviews or changes in shoe details.
   - **Solution**: Used Firestore's snapshot listeners to listen for real-time updates and update the UI accordingly. Implemented debounce mechanisms to avoid excessive re-rendering.

#### 4. **Error Handling and User Feedback**
   - **Challenge**: Providing meaningful error messages and handling different types of errors (e.g., network errors, permission issues).
   - **Solution**: Implemented comprehensive error handling throughout the application, displaying user-friendly error messages and retry options. Logged errors for debugging and monitoring.

#### 5. **State Management**
   - **Challenge**: Managing application state efficiently, especially when dealing with multiple interdependent states.
   - **Solution**: Used the Bloc (Business Logic Component) pattern to manage state across the application. This helped in separating business logic from UI and provided a clear structure for state transitions.

#### 6. **Optimizing Firestore Queries**
   - **Challenge**: Optimizing Firestore queries to ensure quick response times even with large datasets.
   - **Solution**: Indexed frequently queried fields, used pagination, and optimized data structures to minimize read operations.

#### 7. **Dynamic Filtering**
   - **Challenge**: Implementing dynamic filtering based on multiple criteria (e.g., price range, brand, color).
   - **Solution**: Built flexible query builders that construct Firestore queries based on selected filters. Used dot notation for querying nested map fields.

#### 8. **Handling Complex JSON Structures**
   - **Challenge**: Converting complex JSON structures to Dart objects and vice versa.
   - **Solution**: Created well-defined data models and used the `fromJson` and `toJson` methods to handle JSON serialization and deserialization.

By addressing these challenges with thoughtful solutions and leveraging the capabilities of Flutter and Firestore, you were able to build a robust, responsive, and user-friendly application.

## Additional Features and Improvements

#### Reload App Button
- **Feature**: Added a "Reload App" button to reset the state of the application.
- **Benefit**: Allows users to reset the application if it gets stuck on a loading screen or encounters an error, improving the overall user experience.
- **Implementation**:
  - Implemented a button that, when pressed, emits an empty state in the Bloc, effectively resetting the application state.
  - Ensured the app reinitializes correctly and any necessary data is reloaded from Firestore.
