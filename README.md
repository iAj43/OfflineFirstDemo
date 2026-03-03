{\rtf1\ansi\ansicpg1252\cocoartf2822
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 # OfflineFirstDemo\
\
Offline-first iOS demo application built using SwiftUI, MVVM, and Repository pattern.\
\
## Overview\
\
This app demonstrates:\
\
- Offline-first data loading\
- Persistent file-based caching\
- Live update simulation via polling\
- Stable identifiers with delta merging\
- Clean MVVM architecture\
- Dependency Injection\
- Unit test coverage for core behaviors\
\
Deployment Target: iOS 16+  \
Language: Swift 5+\
\
---\
\
## Architecture\
\
The app follows:\
\
- MVVM (Model-View-ViewModel)\
- Repository pattern (Single Source of Truth)\
- Dependency Injection\
- Actor-based thread-safe repository\
- File-based persistent cache\
\
Flow:\
\
View \uc0\u8594  ViewModel \u8594  Repository \u8594  (API + Cache)\
\
---\
\
## Features\
\
### List Screen\
- Displays id, title, status, updatedAt\
- Pull-to-refresh\
- Navigation to detail\
- Offline banner when serving cached data\
\
### Detail Screen\
- Displays full item details\
- Works offline using cached data\
\
---\
\
## Offline Strategy\
\
- Remote fetch persists data to file cache.\
- On network failure, cached data is returned.\
- Cache survives app restart.\
- Merge strategy uses `updatedAt` comparison.\
\
---\
\
## Live Update Simulation\
\
- Polls mock data source every 10 seconds.\
- Applies delta merge based on id + updatedAt.\
- Prevents full list UI refresh.\
\
---\
\
## Testing\
\
Includes unit tests for:\
\
- Repository behavior\
- Cache persistence\
- ViewModel state transitions\
- Offline fallback logic\
\
Run tests using Cmd + U.\
\
---\
\
## Future Improvements\
\
- Add TTL-based cache invalidation\
- Add real API layer\
- Add UI automation tests\
- Improve error UI messaging}