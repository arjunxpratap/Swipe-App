# Swipe iOS Assignment

A SwiftUI-based iOS application that demonstrates:
- A **Product Listing** screen (with search, sorting, and favorites)  
- An **Add Product** screen (with offline creation and automatic upload)

This README describes the project architecture, setup instructions, features, and how each requirement was met.

## App Demo Video



---

https://github.com/user-attachments/assets/40824225-1790-4024-a010-b37ee5884dc9

---

## Table of Contents
1. [Overview](#overview)  
2. [Screens](#screens)  
3. [Features Implemented](#features-implemented)  
4. [Architecture](#architecture)  
5. [Offline Functionality](#offline-functionality)  
6. [Installation](#installation)  
7. [Usage](#usage)  
8. [Dependencies](#dependencies)  
9. [Future Improvements](#future-improvements)  
10. [Credits](#credits)

---

## Overview

This app, **Swipe**, lets users browse a list of products obtained from the Swipe Public API and add new products using the POST endpoint. It showcases SwiftUI (and optionally UIKit for specific components) and leverages MVVM architecture to keep code modular and testable.

**Main Capabilities**:  
- Fetch products from a remote API  
- Display products in a scrollable list with searching and sorting  
- Mark favorites (saved locally and persisted across app launches)  
- Add new products, with image upload if desired  
- Handle offline additions (saved locally, uploaded automatically once the connection is restored)

---

## Screens

### 1. Product Listing Screen
- Displays products fetched from `GET https://app.getswipe.in/api/public/get`  
- Search bar to filter products by name  
- Sorting (price low-to-high, high-to-low, name A–Z/Z–A, type)  
- Favorite icon on each product; tapping it toggles the favorite status  
- Favorites appear at the top and persist locally  
- Progress bar indicates loading state  
- A floating **+** button to navigate to the Add Product screen

### 2. Add Product Screen
- Allows entry of product name, selling price, tax rate, and product type (from a picker)
- Optional image selection (JPEG/PNG)
- Validates for empty fields and numeric inputs for price/tax
- Submits via `POST https://app.getswipe.in/api/public/add`
- If offline, saves the product locally and automatically uploads when reconnected

---

## Features Implemented

1. **Product Listing**  
   - Loads data from the Swipe API  
   - Offers a search bar, sorting options, and a progress bar  
2. **Add Product**  
   - Form with validation, optional image, and offline fallback  
3. **Favorites & Local Persistence**  
   - Toggle favorites with a heart icon, stored in `favorites.json`  
   - Favorites re-applied upon app launch  
4. **Offline Functionality**  
   - Newly created products are stored in `offlineProducts.json` if offline  
   - Automatically uploaded on network reconnection  
5. **UI/UX Enhancements**  
   - SwiftUI’s animations, a floating “Add” button, progress indicators, and Lottie animations

---

## Architecture

- **MVVM**  
  - **Model**: The `Product` struct and local storage managers (`JSONStorageManager`)  
  - **ViewModel**:  
    - `ProductViewModel` handles fetching, sorting, searching, and favoriting  
    - `AddProductViewModel` handles creation, validation, and offline storage/upload  
  - **View**: SwiftUI views (`ContentView`, `AddProductView`) observing their respective ViewModels
- **Network Monitoring**: `NetworkMonitor` (using `NWPathMonitor`) detects online/offline states  
- **Local JSON Storage**: For favorites (`favorites.json`) and offline creations (`offlineProducts.json`)

---

## Offline Functionality

1. **Detect** network state via `NetworkMonitor`.  
2. **If offline**, save the new product to local JSON.  
3. **When back online**, automatically push all locally saved products to the API.  
4. Clears local JSON once synced.

---

## Installation

1. **Clone** or **download** this repository.  
2. **Open** `Swipe.xcodeproj` in Xcode.  
3. **Run** on simulator or a device (iOS 15+).  
4. Ensure you have an active internet connection (except when testing offline mode).

---

## Usage

- **Product Listing**  
  - Launch app → products auto-load.  
  - Tap **heart** icons to favorite, **sort** via the top-right menu, **search** using the search bar.  
- **Add Product**  
  - Tap the **+** floating button.  
  - Enter product details, pick a type, optionally select an image.  
  - Tap the **Submit** button (Lottie animation).  
  - **Offline?** The product is saved locally and automatically uploads once reconnected.

---

## Dependencies

- **SwiftUI** / **Combine**  
- **Lottie** for animations  
- **Network** (NWPathMonitor)  

*(All integrated via Swift Package Manager or system frameworks.)*

---

## Future Improvements

- **Enhanced Image Handling**: Possibly store images in base64 or local files for offline mode.  
- **Better Error Handling**: More robust alerts for network issues or partial upload failures.  
- **Core Data**: Migrate local JSON to a database for larger-scale apps.  
- **Automated Tests**: Increase coverage for view models, especially offline scenarios.

---

## Credits

- **Author**: [Arjun Pratap Choudhary](https://github.com/arjunxpratap)  
- **Assignment**: Provided by **Swipe** (Simple Billing & Payments App)  

*Thank you for reviewing this iOS assignment! If you have any questions, feel free to reach out.* 
