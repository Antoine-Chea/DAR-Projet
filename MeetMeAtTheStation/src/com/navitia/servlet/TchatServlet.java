package com.navitia.servlet;

import static com.googlecode.objectify.ObjectifyService.ofy;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.googlecode.objectify.ObjectifyService;
import com.navitia.datastore.Message;

public class TchatServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	static {
        ObjectifyService.register(Message.class);
    }
	
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {

		System.out.println("Tchat GET: " + req.getParameter("tchat"));
		
		String tchat = req.getParameter("tchat");

		List<Message> msg = ofy().load().type(Message.class).filter("tchat ==", tchat).order("-date").limit(10).list();
		req.setAttribute("messages", msg);
		
		this.getServletContext().getRequestDispatcher("/jsp/tchat.jsp").forward(req, resp);
	}
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		
		System.out.println("Tchat POST: " + req.getParameter("tchat"));
		System.out.println("Pseudo POST: " + req.getParameter("pseudo"));
		System.out.println("Message POST: " + req.getParameter("message"));
		
		// ici on post le message dans la bd
		String tchat = req.getParameter("tchat");
		String pseudo =	req.getParameter("pseudo");
		String message = req.getParameter("message");
		
		Message m = new Message(tchat, pseudo, message);
		System.out.println("Message envoyé: [" + pseudo + ": " + message + "]");
		ofy().save().entity(m).now();

		doGet(req, resp);
	}
	
	

}
