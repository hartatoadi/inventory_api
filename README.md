# 🧾 Simple Inventory System (Rails API)

## Overview
This is a small Rails API project for managing inventory transactions.  
When a transaction is created (`in` or `out`), the product stock is updated accordingly.  
If the stock is insufficient, the API returns a descriptive error.

## Tech Stack
- Ruby on Rails 7 (API mode)
- PostgreSQL or SQLite
- RSpec for testing
- Kaminari for pagination (bonus)

## API Endpoints

### POST `/transactions`
Creates a new transaction.

**Request Example**
```json
{ 
  "product_id": 1, 
  "quantity": 5, 
  "transaction_type": "out" 
}
```

**Success Response**
```json
{ 
  "message": "Transaction created successfully", 
  "product":  { 
                "id": 1, 
                "name": "Apple", 
                "stock": 15 
              }
}
```

**Error Response**
```json
{ "error": "Insufficient stock for product Apple" }
```


### GET /transactions
Returns list of transactions (with optional pagination).

**Success Response**
```json
[{"id":1,"quantity":5,"transaction_type":"out","created_at":"2025-10-20T05:09:43.058Z","product":{"id":1,"name":"Apple"}}]
```

## AI Assistance
* Github Copilot

## Setup
```ruby
bundle install
rails db:create db:migrate db:seed
rails s
```
