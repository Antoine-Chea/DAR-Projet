package com.navitia.servlet.backend;

import static com.googlecode.objectify.ObjectifyService.ofy;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.labs.repackaged.org.json.JSONArray;
import com.google.appengine.labs.repackaged.org.json.JSONException;
import com.google.appengine.labs.repackaged.org.json.JSONObject;
import com.navitia.datastore.Line;
import com.navitia.datastore.StopArea;
import com.navitia.util.GetURL;

public class UpdateBackendServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		/*
		 * =======================================================================================================================
		 * Cette partie déommentée permet d'ajouter les station et les lignes a la base de donnée
		 * =======================================================================================================================
		 */
		//String url = "https://api.navitia.io/v1/coverage/fr-idf/networks/network:RTP/physical_modes/physical_mode:Metro/";
		//addLines(url);
		//addStopAreas(url);
		//addLinesCode();
		//=========================================================================================================================
		
		/*
		 * =======================================================================================================================
		 * Cette partie déommentée permet de mettre à jour toute les prochains départs de toute les stations
		 * =======================================================================================================================
		 */
		//updateNextDeparture();
		//=========================================================================================================================
		
		/*
		 * =======================================================================================================================
		 * Cette partie déommentée permet de mettre à jour toute les prochains départs de la station: 
		 * =======================================================================================================================
		 */
		updateNextDeparture("Jussieu");
		//=========================================================================================================================
	}
	
	public void addLines(String url){
		GetURL u = new GetURL(url+"lines");
		try {
			JSONArray array = u.getJson().getJSONArray("lines");

			for(int i=0; i<array.length(); i++){
				String code = array.getJSONObject(i).getString("code");
				String name = array.getJSONObject(i).getString("name");
				String id = array.getJSONObject(i).getString("id");
				if(!id.contentEquals("line:RTF:M4")){
					System.out.println("code: "+code+" _name: "+name+" _id: "+id);

					Line line = new Line(id,name,code);
					List<Line> lines = ofy().load().type(Line.class).filter("id", line.getId()).list();
					if (lines.size() == 0) {
					System.out.println("AJOUT OK de la ligne " + line.getCode());
						ofy().save().entity(line).now();
					} else {
						System.out.println("LIGNE "+ line.getCode()+", DEJA AJOUTEE.");
					}
				}
			}
		} catch (JSONException e) {
			e.printStackTrace();
		}
	}

	public void addStopAreas(String url){
		int nbStations = 0;
		int nbAjoute = 0;
		GetURL u = new GetURL(url+"stop_areas");
		try {
			JSONObject pagination = u.getJson().getJSONObject("pagination");
			int total = pagination.getInt("total_result");
			int itemsPerPage = pagination.getInt("items_per_page");
			int startPage = pagination.getInt("start_page");
			int pages = (total/itemsPerPage) + startPage + 1;

			for(int k=startPage; k<pages; k++){
				u = new GetURL(url+"stop_areas?start_page="+k);
				JSONArray array = u.getJson().getJSONArray("stop_areas");
				for(int i=0; i<array.length(); i++){
					JSONObject elt = array.getJSONObject(i);
					String coord = elt.getJSONObject("coord").getString("lat")+"/"+elt.getJSONObject("coord").getString("lon");
					String name = elt.getString("name");
					String id = elt.getString("id");
					System.out.println("coord: "+coord+" _name: "+name+" _id: "+id);
					nbStations ++;

					StopArea stopArea= new StopArea(id,name,coord);
					List<StopArea> stopAreas = ofy().load().type(StopArea.class).filter("id", stopArea.getId()).list();
					if (stopAreas.size() == 0) {
						System.out.println("AJOUT OK de la stopArea " + stopArea.getName());
						ofy().save().entity(stopArea).now();
						nbAjoute ++;
					} else {
						nbAjoute++;
						System.out.println("STOP_AREA "+ stopArea.getName()+", DEJA AJOUTEE.");
					}
				}
			}
			System.out.println("nbStations: "+nbStations+"***nbajoute: "+nbAjoute);
		} catch (JSONException e) {
			e.printStackTrace();
		}
	}	

	public void addLinesCode(){
		List<StopArea> stopAreas = ofy().load().type(StopArea.class).list();		
		List<String> al;
		int nbAdd=0;
		
		for(StopArea e : stopAreas){
			StopArea sa = ofy().load().type(StopArea.class).id(e.getId()).now();
			if(sa.getLinesCode().get(0) == "-1"){		
				al = new ArrayList<String>();
				String url = "https://api.navitia.io/v1/coverage/fr-idf/stop_areas/"+e.getId()+"/physical_modes/physical_mode:Metro/lines";
				GetURL u = new GetURL(url);	
				try {
					JSONArray lines = u.getJson().getJSONArray("lines");
					
					for(int i=0; i<lines.length(); i++){
						String code = lines.getJSONObject(i).getString("code");
						al.add(code);
					}				
				} catch (JSONException e1) {
					e1.printStackTrace();
				}
				sa.setLinesCode(al);
				ofy().save().entity(sa);
				System.out.println(sa.getName()+" liste code: "+sa.getLinesCode()+ ", AJOUT OK");
				nbAdd++;
			} else {
				nbAdd++;
				System.out.println("LISTE CODE DE "+sa.getName()+", DEJA AJOUTE.");
			}
		}
		System.out.println("-----nbAdd: "+nbAdd+"------");
	}
	
	
	public void updateNextDeparture() {
		
		List<StopArea> stopAreas = ofy().load().type(StopArea.class).list();	
		List<String> al;
		
		int nbUpdate=0;
		SimpleDateFormat sd = new SimpleDateFormat("yyyyMMdd");
		SimpleDateFormat sh = new SimpleDateFormat("HHmm");
		Date d=new Date();
		String date = sd.format(d)+"T"+sh.format(d);
		
		for(StopArea e : stopAreas){
			al = new ArrayList<>();
			String url = "https://api.navitia.io/v1/coverage/fr-idf/networks/network:RTP/physical_modes/physical_mode:Metro/stop_areas/"+e.getId()+"/departures?from_datetime="+date;
			GetURL u = new GetURL(url);	
			try {
				JSONArray departures = u.getJson().getJSONArray("departures");
				
				for(int i=0; i<departures.length(); i++){
					String direction = departures.getJSONObject(i).getJSONObject("route").getJSONObject("direction").getString("name");
					String lineCode = departures.getJSONObject(i).getJSONObject("route").getJSONObject("line").getString("code");
					String time = departures.getJSONObject(i).getJSONObject("stop_date_time").getString("departure_date_time");;
					al.add(lineCode+"/"+direction+"/"+time);
				}
			} catch (JSONException e1) {
				e1.printStackTrace();
			}
			StopArea sa = ofy().load().type(StopArea.class).id(e.getId()).now();
			sa.setNextDeparture(al);
			ofy().save().entity(sa);
			nbUpdate++;
			System.out.println(sa.getName()+" nextDeparture at "+date+": "+sa.getNextDeparture()+ ", AJOUT OK");
		}
		System.out.println("nbUpdate nextDeparture : "+nbUpdate);
	}
	
	public void updateNextDeparture(String station) {
		
		List<StopArea> stopAreas = ofy().load().type(StopArea.class).filter("name ==", station).list();	
		List<String> al;
		
		int nbUpdate=0;
		SimpleDateFormat sd = new SimpleDateFormat("yyyyMMdd");
		SimpleDateFormat sh = new SimpleDateFormat("HHmm");
		Date d=new Date();
		String date = sd.format(d)+"T"+sh.format(d);
		
		for(StopArea e : stopAreas){
			al = new ArrayList<>();
			String url = "https://api.navitia.io/v1/coverage/fr-idf/networks/network:RTP/physical_modes/physical_mode:Metro/stop_areas/"+e.getId()+"/departures?from_datetime="+date;
			GetURL u = new GetURL(url);	
			try {
				JSONArray departures = u.getJson().getJSONArray("departures");
				
				for(int i=0; i<departures.length(); i++){
					String direction = departures.getJSONObject(i).getJSONObject("route").getJSONObject("direction").getString("name");
					String lineCode = departures.getJSONObject(i).getJSONObject("route").getJSONObject("line").getString("code");
					String time = departures.getJSONObject(i).getJSONObject("stop_date_time").getString("departure_date_time");;
					al.add(lineCode+"/"+direction+"/"+time);
				}
			} catch (JSONException e1) {
				e1.printStackTrace();
			}
			StopArea sa = ofy().load().type(StopArea.class).id(e.getId()).now();
			sa.setNextDeparture(al);
			ofy().save().entity(sa);
			nbUpdate++;
			System.out.println(sa.getName()+" nextDeparture at "+date+": "+sa.getNextDeparture()+ ", AJOUT OK");
		}
		System.out.println("nbUpdate nextDeparture : "+nbUpdate);
	}
	

}
