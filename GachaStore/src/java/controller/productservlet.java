package controller;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import model.DBConnect;

@WebServlet("/ProductServlet")
public class productservlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        String id = request.getParameter("selectedId");
        
        try (Connection conn = DBConnect.getConnection()) {

            if ("insert".equals(action)) {
                String sql = "INSERT INTO products (name, price, quantity, date) VALUES (?, ?, ?, ?)";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, request.getParameter("name"));
                ps.setDouble(2, Double.parseDouble(request.getParameter("price")));
                ps.setInt(3, Integer.parseInt(request.getParameter("qty")));
                ps.setDate(4, Date.valueOf(request.getParameter("date")));
                ps.executeUpdate();
            }
            
           
            else if ("update".equals(action) && id != null) {
                String sql = "UPDATE products SET name=?, price=?, quantity=?, date=? WHERE id=?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, request.getParameter("name_" + id));
                ps.setDouble(2, Double.parseDouble(request.getParameter("price_" + id)));
                ps.setInt(3, Integer.parseInt(request.getParameter("qty_" + id)));
                ps.setDate(4, Date.valueOf(request.getParameter("date_" + id)));
                ps.setInt(5, Integer.parseInt(id));
                ps.executeUpdate();
            }

            else if ("delete".equals(action) && id != null) {
                String sql = "DELETE FROM products WHERE id = ?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setInt(1, Integer.parseInt(id));
                ps.executeUpdate();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("ProductList.jsp");
    }
}