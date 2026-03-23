<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String user = (String) session.getAttribute("user");
    String role = (String) session.getAttribute("role");
    if(user == null){ response.sendRedirect("login.jsp"); return; }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>GachaStore | Official Arknights Merchandise</title>
    <style>
        :root {
            --shop-blue: #3498db;
            --admin-cold: #d1ecf1;
            --admin-text: #0c5460;
            --dark-nav: #2c3e50;
        }

        body {
            background: url("https://i.redd.it/wehif1rowai41.jpg") no-repeat center center fixed;
            background-size: cover;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0; padding: 0;
        }

        .topnav {
            display: flex; align-items: center;
            background: var(--dark-nav);
            padding: 5px 40px; position: sticky; top: 0; z-index: 1000;
            box-shadow: 0 2px 10px rgba(0,0,0,0.3);
        }
        .topnav a { color: white; padding: 15px 20px; text-decoration: none; font-weight: 500; }
        .topnav a:hover { background: rgba(255,255,255,0.1); }

        .dropdown { position: relative; display: inline-block; }
        .dropbtn { 
            background: none; border: none; color: white; 
            padding: 15px 20px; font-size: 16px; cursor: pointer; font-family: inherit;
        }
        .dropdown-content {
            display: none; position: absolute; background: white;
            min-width: 180px; box-shadow: 0 8px 16px rgba(0,0,0,0.2); z-index: 1;
        }
        .dropdown-content a { color: #333; padding: 12px 16px; display: block; }
        .dropdown-content a:hover { background: #f1f1f1; color: var(--shop-blue); }
        .dropdown:hover .dropdown-content { display: block; }

        .admin-section {
            background-color: var(--admin-cold);
            color: var(--admin-text);
            padding: 12px; text-align: center;
            border-bottom: 1px solid #bee5eb;
            font-size: 14px; font-weight: bold;
        }
        .admin-btn {
            background: white; border: 1px solid #bee5eb;
            padding: 5px 15px; margin: 0 10px; border-radius: 4px;
            cursor: pointer; color: var(--admin-text); transition: 0.3s;
        }
        .admin-btn:hover { background: #e2f3f5; }

        .search-box { margin-left: auto; display: flex; }
        .search-box input { 
            padding: 8px 12px; border: none; border-radius: 4px 0 0 4px; outline: none;
        }
        .search-box button { 
            background: var(--shop-blue); color: white; border: none;
            padding: 8px 15px; border-radius: 0 4px 4px 0; cursor: pointer;
        }

        .main-container {
            width: 85%; max-width: 1100px; margin: 40px auto;
            background: rgba(255, 255, 255, 0.95);
            padding: 30px; border-radius: 12px; box-shadow: 0 10px 30px rgba(0,0,0,0.4);
        }

        .hero-logo { text-align: center; margin-bottom: 30px; }

        .product-grid {
            display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 25px; margin-top: 30px;
        }
        .product {
            border: 1px solid #eee; padding: 15px; border-radius: 8px;
            text-align: center; background: white;
        }
        .product img { width: 100%; height: 220px; object-fit: cover; border-radius: 4px; }
        .price { color: #e74c3c; font-size: 1.3em; font-weight: bold; margin: 10px 0; display: block; }
        
        .btn-view {
            background: var(--shop-blue); color: white; border: none;
            padding: 10px 20px; width: 100%; border-radius: 4px; cursor: pointer;
        }
    </style>
</head>
<body>

<div class="topnav">
    <a href="home.jsp">Home</a>
    
    <div class="dropdown">
        <button class="dropbtn">Shop Categories ▼</button>
        <div class="dropdown-content">
            <a href="#">Acrylic Stands</a>
            <a href="#">Scale Figures</a>
            <a href="#">Plushies</a>
            <a href="#">Limited Items</a>
        </div>
    </div>

    <a href="#">Contact</a>
    <a href="#">My Basket</a>

    <div class="search-box">
        <input type="text" placeholder="Search merchandise...">
        <button type="button">Search</button>
    </div>
</div>

<% if("admin".equals(role)){ %>
<div class="admin-section">
    ADMIN ACCESS:
    <button onclick="window.location.href='AccountList.jsp'" class="admin-btn">Manage Accounts</button>
    <button onclick="window.location.href='ProductList.jsp'" class="admin-btn">Manage Inventory</button>
</div>
<% } %>

<div class="main-container">
    <div class="hero-logo">
        <img src="images/Arknights_Logo.png" width="400">
        <p>Welcome back, <strong><%= user %></strong></p>
    </div>

    <h2 style="border-bottom: 2px solid #eee; padding-bottom: 10px;">Featured Products</h2>

    <div class="product-grid">
        <div class="product">
            <img src="images/Texas_Table_Stand.jpg">
            <h3>Texas Acrylic Stand</h3>
            <span class="price">270.000 VND</span>
            <p style="font-size:0.9em; color:#666;">Quantity: 5 In Stock</p>
            <button class="btn-view">View Product</button>
        </div>

        <div class="product">
            <img src="images/Exusiai_Table_Stand.jpg">
            <h3>Exusiai Acrylic Stand</h3>
            <span class="price">290.000 VND</span>
            <p style="font-size:0.9em; color:#666;">Quantity: 5 In Stock</p>
            <button class="btn-view">View Product</button>
        </div>

        <div class="product">
            <img src="images/LapLand_Table_Stand.jpg">
            <h3>Lappland Acrylic Stand</h3>
            <span class="price">290.000 VND</span>
            <p style="font-size:0.9em; color:#666;">Quantity: 5 In Stock</p>
            <button class="btn-view">View Product</button>
        </div>
        <div class="product">
            <img src="images/Croissant_Table_Stand.jpg">
            <h3>Croissant Acrylic Stand</h3>
            <span class="price">290.000 VND</span>
            <p style="font-size:0.9em; color:#666;">Quantity: 5 In Stock</p>
            <button class="btn-view">View Product</button>
        </div>
        <div class="product">
            <img src="images/Sora_Table_Stand.jpg">
            <h3>Sora Acrylic Stand</h3>
            <span class="price">290.000 VND</span>
            <p style="font-size:0.9em; color:#666;">Quantity: 5 In Stock</p>
            <button class="btn-view">View Product</button>
        </div>
        <div class="product">
            <img src="images/Mostima_Table_Stand.jpg">
            <h3>Mostima Acrylic Stand</h3>
            <span class="price">290.000 VND</span>
            <p style="font-size:0.9em; color:#666;">Quantity: 5 In Stock</p>
            <button class="btn-view">View Product</button>
        </div>
    </div>

    <div style="margin-top: 40px; text-align: center;">
        <hr style="border:0; border-top:1px solid #eee; margin-bottom: 20px;">
        <button onclick="window.location.href='login.jsp'" 
                style="background:none; border:1px solid #ccc; padding:8px 25px; cursor:pointer; color:#666;">
            Log Out
        </button>
    </div>
</div>

</body>
</html>