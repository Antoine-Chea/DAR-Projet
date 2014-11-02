package com.navitia.servlet;

import static com.googlecode.objectify.ObjectifyService.ofy;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.googlecode.objectify.ObjectifyService;
import com.navitia.datastore.StopArea;

public class StopAreaServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	static {
        ObjectifyService.register(StopArea.class);
    }
	
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		String coord = req.getParameter("coord");
		List<StopArea> stopArea = null;
		if (coord == null) {
			stopArea = ofy().load().type(StopArea.class).list();
		} else {
			System.out.println("coord: " + coord);
			stopArea = ofy().load().type(StopArea.class).filter("coord ==", coord).list();
		}
		

		for (StopArea line : stopArea) {
			System.out.println("[StopArea]" + line);
		}
		
		req.setAttribute("stopArea", stopArea);
		this.getServletContext().getRequestDispatcher("/jsp/stopArea.jsp").forward(req, resp);
	}
	
}
