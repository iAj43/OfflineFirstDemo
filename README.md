# OfflineFirstDemo
Offline-first iOS demo application built using SwiftUI, MVVM, and Repository pattern.

## Overview
This app demonstrates:
- Offline-first data loading
- Persistent file-based caching
- Live update simulation via polling
- Stable identifiers with delta merging
- Clean MVVM architecture
- Dependency Injection
- Unit test coverage for core behaviors

Deployment Target: iOS 16+
Language: Swift 5+

## Architecture
The app follows:
- MVVM (Model-View-ViewModel)
- Repository pattern (Single Source of Truth)
- Dependency Injection
- Actor-based thread-safe repository
- File-based persistent cache

Flow:
View → ViewModel → Repository → (API + Cache)

## Features

### List Screen
- Displays id, title, status, updatedAt
- Pull-to-refresh
- Navigation to detail
- Offline banner when serving cached data

### Detail Screen
- Displays full item details\
- Works offline using cached data\

## Offline Strategy
- Remote fetch persists data to file cache.
- On network failure, cached data is returned.
- Cache survives app restart.
- Merge strategy uses `updatedAt` comparison.

## Live Update Simulation
- Polls mock data source every 10 seconds.
- Applies delta merge based on id + updatedAt.
- Prevents full list UI refresh.

## Testing
Includes unit tests for:
- Repository behavior
- Cache persistence
- ViewModel state transitions
- Offline fallback logic

Run tests using Cmd + U

## Screenshots

<img width="1419" height="2796" alt="Simulator Screenshot - iPhone 16 - 2026-03-03 at 19 17 58-portrait" src="https://github.com/user-attachments/assets/9c582e57-1a66-4009-a5bb-a80ac7447324" />

<img width="1419" height="2796" alt="Simulator Screenshot - iPhone 16 - 2026-03-03 at 19 18 04-portrait" src="https://github.com/user-attachments/assets/802b2918-e4b2-4104-abbb-04e65b55be93" />
