package controller;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import cart.dao.CartDAO;
import cart.dto.CartDTO;
import order.dao.OrderDAO;

@WebServlet("/Cart2")
public class Cart2Controller extends HttpServlet {
   private static final long serialVersionUID = 1L;

   protected void doGet(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
	   HttpSession session = request.getSession();
		String userid = (String)session.getAttribute("userid");
		if(userid == null) {
			response.sendRedirect("login");
		}else
		{
			CartDAO cdao = CartDAO.getInstance();
		      String uid = userid;
		      int ordercount = 1;
		      String pid = "";
		      OrderDAO odao = OrderDAO.getInstance();
		      ArrayList<CartDTO> clist;
		      CartDTO data = new CartDTO();
		      clist = cdao.cartSelect(uid);
		        ArrayList<String> al = new ArrayList<>();
		        for(int i=0;i<clist.size();i++){
		           al.add(clist.get(i).getpId());
		        }

		      RequestDispatcher rd;

		      if (request.getParameter("value") != null && request.getParameter("value").equals("delete")) {
		         cdao.cartDelete(uid);
		         rd = request.getRequestDispatcher("WEB-INF/jsp/client/cart2.jsp");
		         rd.forward(request, response);
		      } else if (request.getParameter("value") != null && request.getParameter("value").equals("complete")) {
		         cdao.cartDelete(uid);
		         rd = request.getRequestDispatcher("WEB-INF/jsp/client/cart2.jsp");
		         rd.forward(request, response);
		      }

		      else if (request.getParameter("value") != null && request.getParameter("value").equals("order")) {
		         
		         ordercount = odao.selectOrder();
		         odao.orderInsert(ordercount++, uid, al);
		         cdao.cartDelete(uid);
		         System.out.println(pid);
		         
		         rd = request.getRequestDispatcher("WEB-INF/jsp/client/cart2.jsp");
		         rd.forward(request, response);
		      }
		}
      

   }

   protected void doPost(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {

      doGet(request, response);
   }

}