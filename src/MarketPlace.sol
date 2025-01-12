//SPDX-License-Identifier:MIT
pragma solidity 0.8.28;

contract MarketPlace {
    //Existing enums, structs, mappings, and events remain the same...
    enum Status {
        Sold,
        Unsold,
        Reserved,
        Cancelled
    }
    enum Category{
        Electronics,
        Fashion,
        Home,
        Sports,
        Other
    }

    struct Product {
        uint256 id;
        string name;
        string description;
        uint256 price;
        address owner;
        Status status;
        Category category;
        address buyerAddress;
    }

    mapping(uint256 => Product) public products;
    
    // Add new state variables for tracking
    uint256[] private productIds;
    mapping(address => uint256[]) private userPurchases;

    event ProductAdded(uint256 indexed id, uint256 price, address indexed owner, string name, string description, Category category);
    event ProductBought(uint256 indexed id, uint256 price, address indexed buyer, address indexed owner);
    event ProductCanselled(uint256 indexed id, address indexed owner);
    event ProductModified(uint256 indexed id, uint256 price, address indexed owner);
    event ProductDeleted(uint256 indexed id, address indexed owner);

    // Existing functions remain the same...
    
    // New function to modify a product
    function modifyProduct(uint256 _id, uint256 _newPrice, string calldata _newName, string calldata _newDescription) external returns(string memory) {
        require(products[_id].owner == msg.sender, "You are not the owner of this product");
        require(products[_id].status == Status.Unsold, "Product is not available for modification");
        require(_newPrice > 0, "Price must be greater than 0");
        require(bytes(_newName).length > 0, "Name must not be empty");
        require(bytes(_newDescription).length > 0, "Description must not be empty");

        products[_id].price = _newPrice;
        products[_id].name = _newName;
        products[_id].description = _newDescription;

        emit ProductModified(_id, _newPrice, msg.sender);

        return "Product modified successfully";
    }

    // Function to view all products
    function getAllProducts() external view returns(Product[] memory) {
        uint256 activeProducts = 0;
        
        // First count active products
        for(uint256 i = 0; i < productIds.length; i++) {
            if(products[productIds[i]].id != 0) {
                activeProducts++;
            }
        }

        // Create array of active products
        Product[] memory allProducts = new Product[](activeProducts);
        uint256 currentIndex = 0;

        for(uint256 i = 0; i < productIds.length; i++) {
            if(products[productIds[i]].id != 0) {
                allProducts[currentIndex] = products[productIds[i]];
                currentIndex++;
            }
        }

        return allProducts;
    }

    // Function to view all payments made by a user
    function getUserPurchases(address _user) external view returns(Product[] memory) {
        uint256[] storage userPurchaseIds = userPurchases[_user];
        Product[] memory purchasedProducts = new Product[](userPurchaseIds.length);

        for(uint256 i = 0; i < userPurchaseIds.length; i++) {
            purchasedProducts[i] = products[userPurchaseIds[i]];
        }

        return purchasedProducts;
    }

    // Function to cancel order
    function cancelProduct(uint256 _id) external returns(string memory) {
        require(products[_id].owner == msg.sender, "Only owner can cancel the product");
        require(products[_id].status == Status.Unsold, "Product is not available for cancellation");

        products[_id].status = Status.Cancelled;

        emit ProductCanselled(_id, msg.sender);

        return "Product cancelled successfully";
    }

    // Modify addProduct to track product IDs
    function addProduct(
        string calldata _name,
        string calldata _description,
        uint256 _price,
        Category _category,
        uint256 _id
    ) external returns(string memory) {
        require(_price > 0, "Price must be greater than 0");
        require(bytes(_name).length > 0, "Name must not be empty");
        require(bytes(_description).length > 0, "Description must not be empty");
        require(_id > 0, "Id must be greater than 0");

        products[_id] = Product(_id, _name, _description, _price, msg.sender, Status.Unsold, _category, address(0));
        productIds.push(_id);

        emit ProductAdded(products[_id].id, _price, msg.sender, _name, _description, _category);

        return "Product added successfully";
    }

    // Modify buyProduct to track purchases
    function buyProduct(uint256 _id) external payable returns(string memory) {
        require(products[_id].id != 0, "The product bought does not exist");
        require(products[_id].status == Status.Unsold, "The product is already sold");
        require(msg.value == products[_id].price, "Incorrect amount");

        address owner = products[_id].owner;

        (bool success, ) = owner.call{value: msg.value}("");
        require(success, "Payment of product failed");

        products[_id].status = Status.Sold;
        products[_id].buyerAddress = msg.sender;
        userPurchases[msg.sender].push(_id);

        emit ProductBought(_id, msg.value, msg.sender, products[_id].owner);

        return "Success";
    }
}