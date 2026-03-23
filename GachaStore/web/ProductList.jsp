<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, model.DBConnect" %>
<%
    // 1. Security
    String role = (String)session.getAttribute("role");
    if(role == null || !role.equals("admin")) { response.sendRedirect("home.jsp"); return; }

    // 2. Get Parameters from Navbar
    String query = request.getParameter("query");      
    String category = request.getParameter("category"); 
    String sort = request.getParameter("sort"); // NEW: Get sort value

    Connection conn = DBConnect.getConnection();
    
    // 3. Dynamic SQL Construction
    StringBuilder sql = new StringBuilder("SELECT * FROM products WHERE 1=1");
    
    if (query != null && !query.trim().isEmpty()) {
        sql.append(" AND (name LIKE ? OR category LIKE ? OR description LIKE ?)");
    }
    if (category != null && !category.trim().isEmpty()) {
        sql.append(" AND category = ?");
    }

    // 4. Handle Sorting Logic
    // Default to 'id DESC' if nothing is selected
    String orderBy = " id DESC"; 
    if ("price_asc".equals(sort)) orderBy = " price ASC";
    else if ("price_desc".equals(sort)) orderBy = " price DESC";
    else if ("name_asc".equals(sort)) orderBy = " name ASC";
    
    sql.append(" ORDER BY").append(orderBy);

    // 5. Prepare and Fill
    PreparedStatement listPs = conn.prepareStatement(sql.toString());
    int paramIndex = 1;
    if (query != null && !query.trim().isEmpty()) {
        String p = "%" + query + "%";
        listPs.setString(paramIndex++, p);
        listPs.setString(paramIndex++, p);
        listPs.setString(paramIndex++, p);
    }
    if (category != null && !category.trim().isEmpty()) {
        listPs.setString(paramIndex++, category);
    }

    ResultSet rs = listPs.executeQuery();
%>

<html>
<head>
    <title>Inventory Management</title>
    <style>
        :root {
            --primary: #2c3e50; --success: #27ae60; --warning: #f39c12; --danger: #e74c3c; --light: #f8f9fa;
        }
        body { background: #f0f2f5; font-family: 'Segoe UI', sans-serif; margin: 0; }
        
        /* Navbar */
        .navbar {
            background: var(--primary); padding: 15px 50px; display: flex;
            justify-content: space-between; align-items: center; color: white; box-shadow: 0 2px 10px rgba(0,0,0,0.2);
        }
        .main-card { 
            background: white; padding: 30px; border-radius: 12px; width: 90%; 
            max-width: 1200px; margin: 30px auto; box-shadow: 0 4px 20px rgba(0,0,0,0.1); 
        }

        /* Add Form Section */
        #addFormSection {
            display: none; background: var(--light); padding: 20px; border-radius: 8px;
            margin-bottom: 25px; border-left: 5px solid var(--success);
        }

        /* Table Styling */
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th { background: #f4f6f7; color: var(--primary); padding: 15px; text-align: left; }
        td { padding: 12px; border-bottom: 1px solid #eee; }

        .unlockable { 
            border: 1px solid transparent; background: transparent; padding: 8px; 
            width: 100%; color: #333; pointer-events: none; transition: 0.2s;
        }
        .active-row .unlockable { 
            border: 1px solid #3498db; background: #fff; pointer-events: auto; 
        }

        .btn { padding: 10px 18px; border: none; border-radius: 6px; cursor: pointer; font-weight: 600; }
        .btn-home { background: transparent; color: white; border: 1px solid white; }
        
        /* The Disclaimer Alert */
        .status-msg { 
            background: #fff3cd; color: #856404; padding: 10px; border-radius: 5px; 
            margin-bottom: 15px; border: 1px solid #ffeeba; font-weight: bold;
        }
    </style>
</head>
<body>

<div class="navbar">
    <div class="nav-left">
        <button class="btn btn-home" onclick="window.location.href='home.jsp'">← Home</button>
        <span style="font-size: 1.1rem; font-weight: bold; margin-left:10px;">Product Inventory</span>
    </div>

    <div class="nav-center">
        <form method="get" action="ProductList.jsp" style="display: flex; gap: 8px;">
            <input type="text" name="query" placeholder="Search anything..." 
                   value="<%= (query != null) ? query : "" %>"
                   style="padding: 8px; border-radius: 4px; border: none; width: 180px;">
            
            <select name="category" onchange="this.form.submit()" style="padding: 8px; border-radius: 4px; border: none;">
                <option value="">All Categories</option>
                <option value="Acrylic Stand" <%= "Acrylic Stand".equals(category) ? "selected" : "" %>>Stands</option>
                <option value="Plushy" <%= "Plushy".equals(category) ? "selected" : "" %>>Plushies</option>
                <option value="Scale" <%= "Scale".equals(category) ? "selected" : "" %>>Scale Figures</option>
                <option value="Limited" <%= "Limited".equals(category) ? "selected" : "" %>>Limited</option>
            </select>

            <select name="sort" onchange="this.form.submit()" style="padding: 8px; border-radius: 4px; border: none;">
                <option value="id_desc" <%= "id_desc".equals(sort) ? "selected" : "" %>>Newest</option>
                <option value="price_asc" <%= "price_asc".equals(sort) ? "selected" : "" %>>Price: Low-High</option>
                <option value="price_desc" <%= "price_desc".equals(sort) ? "selected" : "" %>>Price: High-Low</option>
                <option value="name_asc" <%= "name_asc".equals(sort) ? "selected" : "" %>>Name: A-Z</option>
            </select>
            
            <button type="submit" class="btn" style="background: var(--warning); color: white;">Filter</button>
            
            <% if(query != null && !query.isEmpty()) { %>
                <a href="ProductList.jsp" style="color: #bdc3c7; font-size: 12px; align-self: center; text-decoration: none;">Clear</a>
            <% } %>
        </form>
    </div>

    <div class="nav-right">
        <button class="btn" style="background: var(--success); color: white;" onclick="toggleAddForm()">+ Add New Product</button>
    </div>
</div>

<div class="main-card">
    <div id="addFormSection">
        <h3 style="margin-top:0;">Register New Product</h3>
        <form method="post" action="ProductServlet">
            <input type="hidden" name="action" value="insert">
            <div style="display: flex; gap: 10px; flex-wrap: wrap;">
                <input type="text" name="name" placeholder="Product Name" required style="flex:2; padding:10px;">
                <input type="number" name="price" placeholder="Price" required style="flex:1; padding:10px;">
                <input type="number" name="qty" placeholder="Qty" required style="flex:1; padding:10px;">
                <input type="date" name="date" required style="flex:1; padding:10px;">
                <button type="submit" class="btn" style="background: var(--success); color: white;">Save Product</button>
            </div>
        </form>
    </div>

    <form method="post" action="ProductServlet" id="productForm">
        <table>
            <thead>
                <tr>
                    <th>Select</th><th>ID</th><th>Name</th><th>Price (VND)</th><th>Qty</th><th>Date</th>
                </tr>
            </thead>
            <tbody>
                <%
            while(rs.next()){
            int id = rs.getInt("id");
%>
                <tr>
                    <td><input type="radio" name="selectedId" value="<%= id %>" onclick="unlockRow(this)"></td>
                    <td><%= id %></td>
                    <td><input type="text" name="name_<%= id %>" value="<%= rs.getString("name") %>" class="unlockable" readonly></td>
                    <td><input type="number" name="price_<%= id %>" value="<%= rs.getDouble("price") %>" class="unlockable" readonly></td>
                    <td><input type="number" name="qty_<%= id %>" value="<%= rs.getInt("quantity") %>" class="unlockable" readonly></td>
                    <td><input type="date" name="date_<%= id %>" value="<%= rs.getDate("date") %>" class="unlockable" readonly></td>
                </tr>
                <% } conn.close(); %>
            </tbody>
        </table>

        <div id="actionPanel" style="display:none; margin-top:30px;">
            <div class="status-msg">
                ⚠️ Row Unlocked: You can now edit the product info above or delete this entry.
            </div>
            <div style="text-align: right;">
                <button type="submit" name="action" value="update" class="btn" style="background: var(--warning); color:white;">Save Changes</button>
                <button type="submit" name="action" value="delete" class="btn" style="background: var(--danger); color:white; margin-left:10px;" onclick="return confirm('Delete this product?')">Delete Product</button>
            </div>
        </div>
    </form>
</div>

<script>
    function toggleAddForm() {
        var section = document.getElementById("addFormSection");
        section.style.display = (section.style.display === "none" || section.style.display === "") ? "block" : "none";
    }

    function unlockRow(radio) {

        document.querySelectorAll('tr').forEach(r => r.classList.remove('active-row'));
        document.querySelectorAll('.unlockable').forEach(i => i.readOnly = true);

        var row = radio.closest('tr');
        row.classList.add('active-row');
        row.querySelectorAll('.unlockable').forEach(i => i.readOnly = false);
        
        document.getElementById("actionPanel").style.display = "block";
    }

    document.getElementById('productForm').onsubmit = function() {
        this.querySelectorAll('.unlockable').forEach(i => i.readOnly = false);
    };
</script>

</body>
</html>