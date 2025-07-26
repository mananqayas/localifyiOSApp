# Localify

A modern iOS application for local business management and networking, built with SwiftUI.

## 🎥 Demo Video

**Watch the app in action:** [Video Demo](https://www.youtube.com/watch?v=aPlhL2YnfIg&feature=youtu.be)

## Overview

Localify Redo is a comprehensive business management platform that allows local business owners to:
- Create and manage their business profiles
- Showcase their portfolio with photos and descriptions
- Connect with customers through messaging
- Share updates through posts
- Manage customer reviews
- Build their online presence in the local community

## Backend API

**Base URL:** `https://localify.api.mananqayas.com/api`

**Repository:** [https://github.com/mananqayas/localifyiOSAppAPI](https://github.com/mananqayas/localifyiOSAppAPI)

The application connects to a RESTful API built with TypeScript that handles:
- User authentication and authorization
- Business profile management
- Portfolio and media management
- Messaging and communications
- Review and rating systems
- Post and content management

## Features

### 🏠 Dashboard
- Business overview and analytics
- Quick access to key features
- Business information management

### 💼 Portfolio Management
- Upload and organize business photos
- Showcase work and services
- Visual portfolio presentation

### 📱 Posts & Updates
- Create and share business updates
- Engage with the local community
- Manage content visibility

### 💬 Messaging
- Direct communication with customers
- Real-time chat functionality
- Message history and management

### 👤 Profile Management
- Business profile customization
- Service listings and descriptions
- Contact information and location

## Technical Stack

- **Platform:** iOS
- **Framework:** SwiftUI
- **Architecture:** MVVM (Model-View-ViewModel)
- **Networking:** URLSession with async/await
- **Security:** Keychain for secure token storage
- **UI Components:** Custom SwiftUI components and styling

## Project Structure

```
localifyRedo/
├── Models/              # Data models and response structures
├── Views/               # SwiftUI views and screens
├── ViewModels/          # Business logic and state management
├── Services/            # API service layers
├── Manager/             # Network and utility managers
├── Extensions/          # Swift extensions and utilities
├── Fonts/               # Custom fonts (Poppins, Playball)
└── Assets.xcassets/     # Images and visual assets
```

## API Endpoints

The app integrates with various API endpoints including:
- `/owner/register` - User registration
- `/owner/login` - User authentication
- `/owner/profile` - Profile management
- `/business/*` - Business operations
- `/portfolio/*` - Portfolio management
- `/posts/*` - Content management
- `/reviews/*` - Review system

## Getting Started

1. Clone the repository
2. Open `localifyRedo.xcodeproj` in Xcode
3. Build and run the project on iOS Simulator or device
4. The app will connect to the production API automatically

## Migration Note

This project is migrated from a private repository to public. All the old commits are in the original private repository.

## Requirements

- iOS 14.0+
- Xcode 13.0+
- Swift 5.5+
