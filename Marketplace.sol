// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract Marketplace {
    struct Product {
        uint256 id;
        address payable seller;
        string name;
        uint256 price;
        uint256 stock;
        bool isSold;
        bool exists;
    }

    mapping(uint256 => Product) public products;
    
    uint256 public nextProductId = 1;

    event ProductAdded(
        uint256 id,
        address indexed seller,
        string name,
        uint256 stock,
        uint256 price
    );

    event ProductPurchased(
        uint256 id,
        address indexed buyer,
        address indexed seller,
        uint256 price
    );

    function getProductDetails(uint256 _productId) public view returns(Product memory){
        require(_productId > 0 && _productId < nextProductId, "Product ID tidak valid");
        return products[_productId];
    }

    function addProduct(string memory _name, uint256 _price, uint256 _stock) public {
        require(_price > 0, "Harga harus lebih dari nol");
        require(address(msg.sender) != address(0), "Address seller tidak boleh kosong");
        products[nextProductId] = Product(
            nextProductId,
            payable(msg.sender),
            _name,
            _price,
            _stock,
            false,
            true
        );

        emit ProductAdded(nextProductId, msg.sender, _name, _stock, _price);

        nextProductId++;
    }

    function buyProduct(uint256 _id) public payable {
        Product storage product = products[_id];
        require(product.exists, "Produk tidak ditemukan");
        require(!product.isSold, "Produk sudah terjual");
        require(msg.value >= product.price, "ETH yang dikirim kurang dari harga tertera");
        require(msg.sender != product.seller, "Penjual tidak dapat membeli produk sendiri");

        product.stock--;
        if(product.stock <= 0) product.isSold = true;

        (bool success, ) = product.seller.call{value: msg.value}("");
        require(success, "Gagal mengirim ETH ke penjual");

        emit ProductPurchased(_id, msg.sender, product.seller, msg.value);
    }
}