# Inventory Management System

A real-time inventory management system built with Ruby on Rails 8, Hotwire, and Tailwind CSS. Each user has their own private inventory with full CRUD operations, real-time stock tracking, and low stock notifications.

## Table of Contents

- [Features](#features)
- [Quick Start](#quick-start)
- [Technical Decisions](#technical-decisions)
- [Testing](#testing)
- [Architecture](#architecture)

## Features

### Core Features
- **User Authentication**: Signup, login, logout with Rails 8 built-in authentication
- **Multi-Tenant Inventory**: Each user has their own private product inventory
- **Product Management**: Full CRUD operations (name, description, price, quantity)
- **Real-time Stock Tracking**: Live updates using Hotwire Turbo Streams
- **Low Stock Notifications**: Automatic alerts when inventory falls below 10 units

### Bonus Features
- **Search & Filtering**: Search products by name/description, filter by low stock
- **Image Upload**: Product images via Active Storage
- **CSV Export**: Export inventory data with current filters applied

## Quick Start

### Option 1: Dev Container (Recommended)

No local Ruby installation required. Just need Docker and VS Code.

> **Note:** The first time you build the Dev Container, it may take 5-15 minutes to download the Docker image, install Ruby, and run `bundle install`. Subsequent starts will be much faster due to Docker caching.

1. Install [Docker Desktop](https://www.docker.com/products/docker-desktop/)
2. Install [VS Code](https://code.visualstudio.com/) with [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
3. Clone this repo and open in VS Code
4. Click "Reopen in Container" when prompted (or run `Dev Containers: Reopen in Container` from command palette)
5. Wait for container to build (installs Ruby, Node.js, dependencies)
6. Run `bin/rails server -b 0.0.0.0` in the terminal
7. Visit `http://localhost:3000`

### Option 2: Local Installation

#### Prerequisites

- Ruby 3.2+
- Bundler (`gem install bundler`)

#### Installation

```bash
# Clone the repository
git clone https://github.com/Barsu5489/StockManager-System
cd StockManager-System

# Install dependencies
bundle install

# Setup database with Active Storage
bin/rails db:create db:migrate

# Start the server
bin/dev
```

### Usage

1. Visit `http://localhost:3000`
2. Click "Sign up" to create an account
3. Start adding products to your inventory

### Default Admin (from seeds)

If you run `bin/rails db:seed`:
- **Email**: admin@example.com
- **Password**: password123

## Technical Decisions

All technical decisions are documented in detail in [docs/decisions.md](docs/decisions.md).

### Summary

| Decision | Choice | Why |
|----------|--------|-----|
| Database | SQLite | Zero config, Rails 8 default, portable |
| Authentication | Rails 8 built-in | Simple, no gems, full control |
| Real-time | Hotwire Turbo Streams | Native Rails, no JS framework needed |
| CSS | Tailwind CSS v4 | Utility-first, Rails 8 default |
| Image Upload | Active Storage | Built-in, works with local/cloud storage |
| Testing | Minitest | Rails default, fast, simple |
| Multi-tenancy | User-scoped queries | Data isolation, security |

## Testing

### Run Tests

```bash
# Run all tests
bin/rails test

# Run with coverage report
bin/rails test
open coverage/index.html
```

### Test Coverage

- **53+ tests** covering:
  - Product model validations and scopes
  - User model and authentication
  - Controller CRUD operations
  - User isolation (can't access other users' products)
  - Stock adjustment with Turbo Streams
  - CSV export functionality

## Architecture

### Data Model

```
┌─────────────┐       ┌──────────────────┐
│    User     │       │     Product      │
├─────────────┤       ├──────────────────┤
│ email       │───────│ user_id (FK)     │
│ password    │   1:N │ name             │
│ sessions    │       │ description      │
│ products    │       │ price            │
└─────────────┘       │ quantity         │
                      │ image (attached) │
                      └──────────────────┘
```


### Real-time Updates Flow

```
User clicks +/- button
       │
       ▼
POST /products/:id/increase_stock (or decrease_stock)
       │
       ▼
Controller updates quantity
       │
       ▼
Turbo Stream response replaces:
  1. Product card (updated quantity)
  2. Low stock alert (if threshold crossed)
       │
       ▼
UI updates without page refresh
```

## License

MIT
