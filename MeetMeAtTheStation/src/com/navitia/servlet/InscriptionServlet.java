package com.navitia.servlet;

import static com.googlecode.objectify.ObjectifyService.ofy;

import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.googlecode.objectify.ObjectifyService;
import com.navitia.datastore.Utilisateur;

@SuppressWarnings("serial")
public class InscriptionServlet extends HttpServlet {
	// Enregistrement de la classe persistable aupres d'Objectify
	static {
		ObjectifyService.register(Utilisateur.class);
	}

	public void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws IOException, ServletException {

		String id = req.getParameter("id");
		
		
		String email = req.getParameter("email");
		String motdepasse = req.getParameter("motdepasse");
		
		List<Utilisateur> utilisateurs = null;
		if (id.equals("null")) {
			utilisateurs = ofy().load().type(Utilisateur.class).filter("email ==", email).filter("motDePasse ==", md5(motdepasse)).list();
		} else {
			System.out.println("id[" + id + "]");
			utilisateurs = ofy().load().type(Utilisateur.class).filter("id ==", new Long(id)).list();
		}
		
		if (utilisateurs.size() == 0) {
			System.out.println("utilisateur inconnu");
		} else {
			System.out.println("User: " + utilisateurs.get(0).getPrenom() + ":" + utilisateurs.get(0).getNom());
			
			req.setAttribute("utilisateur", utilisateurs.get(0));
			this.getServletContext().getRequestDispatcher("/jsp/connexion.jsp").forward(req, resp);
		}
	}


	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException{
		//try{			
			String nom = req.getParameter("nom");
			String prenom = req.getParameter("prenom");
			String pseudo = req.getParameter("pseudo");
			String email = req.getParameter("email");
			String motDePasse = req.getParameter("motDePasse");
			String motDePasseConfirme = req.getParameter("motDePasseConfirme");
			
			/*
			System.out.println("nom: " + nom);
			System.out.println("prenom: " + prenom);
			System.out.println("pseudo: " + pseudo);
			System.out.println("email: " + email);
			System.out.println("motDePasse: " + motDePasse);
			System.out.println("motDePasseConfirme: " + motDePasseConfirme);
			*/
			
			if (!nom.equals("") && !prenom.equals("") && !pseudo.equals("") && !email.equals("") && !motDePasse.equals("") && !motDePasseConfirme.equals("")){
				if (motDePasse.equals(motDePasseConfirme)) {
					 String re = "^[_a-z0-9-]+(\\.[_a-z0-9-]+)*@[a-z0-9-]+(\\.[a-z0-9-]+)+$";

					if (email.matches(re)) {
						ArrayList<Long> amis = new ArrayList<Long>();
						amis.add((long) -1);
						Utilisateur u = new Utilisateur(nom, prenom, pseudo,  email, md5(motDePasse), amis);
						
						List<Utilisateur> utilisateurs = ofy().load().type(Utilisateur.class).filter("email ==", email).list();
						if (utilisateurs.size() == 0) {
							utilisateurs = ofy().load().type(Utilisateur.class).filter("pseudo ==", pseudo).list();
							if (utilisateurs.size() == 0) {
								System.out.println("AJOUT DE: " + prenom + " " + nom);
								ofy().save().entity(u).now();
								
								req.setAttribute("code", "0");
								req.setAttribute("utilisateur", u);
								this.getServletContext().getRequestDispatcher("/jsp/inscription.jsp").forward(req, resp);
							} else {
								System.out.println("pseudo déjà utilisé");

								req.setAttribute("code", "5");
								this.getServletContext().getRequestDispatcher("/jsp/inscription.jsp").forward(req, resp);
							}
						} else {
							System.out.println("Email déjà utilisé");

							req.setAttribute("code", "4");
							this.getServletContext().getRequestDispatcher("/jsp/inscription.jsp").forward(req, resp);
						}
					} else {
						System.out.println("Email incorrect");
						req.setAttribute("code", "3");
						this.getServletContext().getRequestDispatcher("/jsp/inscription.jsp").forward(req, resp);
					}
				} else {
					System.out.println("La confirmation du mot de passe est incorrect");
					req.setAttribute("code", "2");
					this.getServletContext().getRequestDispatcher("/jsp/inscription.jsp").forward(req, resp);
				}
			} else {
				System.out.println("Tout les champs sont obligatoires");
				req.setAttribute("code", "1");
				this.getServletContext().getRequestDispatcher("/jsp/inscription.jsp").forward(req, resp);
			}
	}
	
	public static String md5(String s) {
		try {
			String original = s;
			MessageDigest md = MessageDigest.getInstance("MD5");
			md.update(original.getBytes());
			byte[] digest = md.digest();
			StringBuffer sb = new StringBuffer();
			for (byte b : digest) {
				sb.append(String.format("%02x", b & 0xff));
			}
		
			//System.out.println("original:" + original);
			//System.out.println("digested(hex):" + sb.toString());
			
			return sb.toString();
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
		}
		return null;
	}
}