package com.navitia.datastore;

import java.util.ArrayList;
import java.util.List;

import com.googlecode.objectify.annotation.Cache;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;
import com.googlecode.objectify.annotation.Index;

@Entity
@Cache
@Index
public class StopArea {

	@Id String id;
	String name;
	String coord;
	List<String> linesCode;
	List<String> nextDeparture;

	public StopArea(){}
	
	public StopArea(String id,String name,String coord){
		this.id=id;
		this.name=name;
		this.coord=coord;
		List<String> l = new ArrayList<>();
		l.add("-1");
		this.linesCode=l;
		this.nextDeparture=l;
	}

	/* GET and SET */
	public String getId() {return id;}
	public void setId(String id) {this.id = id;}
	public String getName() {return name;}
	public void setName(String name) {this.name = name;}
	public String getCoord() {return coord;}
	public void setCoord(String coord) {this.coord = coord;}
	public List<String> getLinesCode() {return linesCode;}
	public void setLinesCode(List<String> linesCode) {this.linesCode = linesCode;}
	public List<String> getNextDeparture() {return nextDeparture;}
	public void setNextDeparture(List<String> nextDeparture) {this.nextDeparture = nextDeparture;}
}
