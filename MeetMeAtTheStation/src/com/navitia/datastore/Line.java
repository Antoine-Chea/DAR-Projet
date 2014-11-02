package com.navitia.datastore;

import com.googlecode.objectify.annotation.Cache;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;
import com.googlecode.objectify.annotation.Index;

@Entity
@Cache
@Index
public class Line {

	@Id String id;
	String name;
	String code;

	public Line(){}
	
	public Line(String id,String name,String code){
		this.id=id;
		this.name=name;
		this.code=code;
	}
	
	/* GET and SET */
	public String getId() {return id;}
	public void setId(String id) {this.id = id;}
	public String getName() {return name;}
	public void setName(String name) {this.name = name;}
	public String getCode() {return code;}
	public void setCode(String code) {this.code = code;}

}
