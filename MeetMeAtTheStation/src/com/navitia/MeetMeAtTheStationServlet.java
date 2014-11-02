package com.navitia;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.googlecode.objectify.ObjectifyService;
import com.navitia.datastore.Line;
import com.navitia.datastore.Message;
import com.navitia.datastore.StopArea;
import com.navitia.datastore.Utilisateur;

@SuppressWarnings("serial")
public class MeetMeAtTheStationServlet extends HttpServlet {
	
    static {
        ObjectifyService.register(Utilisateur.class);
        ObjectifyService.register(Message.class);
        ObjectifyService.register(Line.class);
        ObjectifyService.register(StopArea.class);
    }
    
	public void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		this.getServletContext().getRequestDispatcher("/html/MeetMeAtTheStation.html").forward(req, resp);
	}
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {

	}
	
	
}
