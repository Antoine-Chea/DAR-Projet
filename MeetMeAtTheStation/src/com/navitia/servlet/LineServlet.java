package com.navitia.servlet;

import static com.googlecode.objectify.ObjectifyService.ofy;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.googlecode.objectify.ObjectifyService;
import com.navitia.datastore.Line;

public class LineServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	static {
        ObjectifyService.register(Line.class);
    }
	
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {

		List<Line> lines = ofy().load().type(Line.class).order("code").list();

		for (Line line : lines) {
			System.out.println("[LINE]" + line);
		}
		
		req.setAttribute("lines", lines);
		this.getServletContext().getRequestDispatcher("/jsp/line.jsp").forward(req, resp);
		
	}

}
