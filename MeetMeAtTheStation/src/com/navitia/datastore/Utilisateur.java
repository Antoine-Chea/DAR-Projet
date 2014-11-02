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
public class Utilisateur {

	@Id Long id;
	String nom;
	String prenom;
	String pseudo;
	String email;
	String motDePasse;
	List<Long> amis;
 
	
	public Long getId() {return id;}
	public String getNom() {return nom;}
	public String getPrenom() {return prenom;}
	public String getPseudo() {return pseudo;}
	public String getEmail() {return email;}
	public String getMotDePasse() {return motDePasse;}
	public List<Long> getAmis() {return amis;}
	 
	
	public Utilisateur() {}
	
	public Utilisateur(String nom, String prenom, String pseudo, String email,
			String motDePasse, ArrayList<Long> amis) {
		this.nom = nom;
		this.prenom = prenom;
		this.pseudo = pseudo;
		this.email = email;
		this.motDePasse = motDePasse;
		this.amis = amis;
	}

	
	
	 
	 
	 

}
