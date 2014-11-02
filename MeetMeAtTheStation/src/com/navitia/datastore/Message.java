package com.navitia.datastore;

import java.text.SimpleDateFormat;
import java.util.Date;

import com.googlecode.objectify.annotation.Cache;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;
import com.googlecode.objectify.annotation.Index;

@Entity
@Cache
@Index
public class Message {
	
	@Id Long id;
	String tchat;
	String pseudo;
	String message;
	String date;
	

	public String getDate() {return date;}
	public String getTrain() {return tchat;}
	public String getPseudo() {return pseudo;}
	public String getMessage() {return message;}
	
	public Message() {}
	
	public Message(String tchat, String pseudo, String message) {

	 	SimpleDateFormat ft = new SimpleDateFormat ("HH:mm:ss");
		this.date = ft.format(new Date());
		this.tchat = tchat;
		this.pseudo = pseudo;
		this.message = message;
	}

}
