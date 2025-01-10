# Decentralized Marketplace

This project is a decentralized marketplace built using **Solidity** and **Foundry**. It allows users to list, buy, and sell items securely and transparently.

## Features

### 1. Item Management
- **Structs**: Defines items with attributes like `name`, `description`, `price`, and `quantity`.
- **Mappings**: Manages relationships between sellers and their items.
- **Functions**:
  - List items
  - Edit items
  - Delete items

### 2. User Interaction
- **Modifiers**: Ensures only the item owner can edit or delete items.
- **Events**: Triggers notifications for actions such as item listing, editing, deletion, and purchase.
- **Error Handling**: Prevents invalid operations like purchasing out-of-stock items.

### 3. Transactions
- **Constructor**: Initializes key parameters.
- **Functions**: Manages buying and selling logic.

## Getting Started

### Prerequisites
- **Foundry**: Install Foundry for compiling and testing contracts:
  ```bash
  curl -L https://foundry.paradigm.xyz | bash
  foundryup
  ```

### Installation
1. Clone the repository:
   ```bash
   git clone git@github.com:FadhilMulinya/Decentralized-MarketPLace.git
   cd Decentralized-MarketPLace
   ```
2. Build the contracts:
   ```bash
   forge build
   ```
3. Run tests:
   ```bash
   forge test
   ```

## Usage
- **Listing an Item**: Use `listItem` with item details.
- **Editing an Item**: Use `editItem` (only the owner can edit).
- **Deleting an Item**: Use `deleteItem` (only the owner can delete).
- **Purchasing an Item**: Use `purchaseItem` with payment in Ether.

## License
Licensed under the MIT License.

