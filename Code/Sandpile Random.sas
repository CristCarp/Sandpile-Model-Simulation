proc iml;
    
    n = 80; *Taille de la matrice : 201 pour centrée et 20 pour aléatoire;
	z = 200000; *Nombre d'itération :' 100 000 pour centrée et 20 000 pour aléatoire;
    sand = j(n, n, 0); *Création d'une matrice vide;
	s = j(1, z, 0); *Compte les avalanches;
	t = j(1, z, 0); *Compte le temps des avalanches;

    /*On crée une boucle pour étaler le sable*/
    do i=1 to z; 
		x = ceil(n * uniform(1));
		y = ceil(n * uniform(1));
        sand[x,y] = sand[x,y] + 1; *On ajoute un grain sur une case aléatoire;
		do while(max(sand) >= 4); * jusqu'à que le tas soit stable;
        	ind = loc(sand >= 4); *On trouve les cases ou il y a 4 grains ou plus;
			if ncol(ind) > 0 then do;
				s[i] = s[i] + ncol(ind); *Compte les avalanches;
				t[i] = t[i] + 1; *Compte le temps des avalanches;
        		sand[ind] = sand[ind] - 4; *La case perd 4 grains de sables;
        		/*On redistribut ces grains au cases voisines*/
        		gauche  = loc(mod(ind, n) ^= 1); *pas sur la première colonne;
				droite = loc(mod(ind, n) ^= 0); *pas sur la dernière colonne;
				haut = loc(ind > n); *pas sur la première ligne;
				bas  = loc(ind <= n*(n-1)); *pas sur la dernière ligne;
				/* redistribution */
				if ncol(gauche) > 0 then sand[ind[gauche] - 1] = sand[ind[gauche] - 1] + 1;
				if ncol(droite) > 0 then sand[ind[droite] + 1] = sand[ind[droite] + 1] + 1;
				if ncol(haut) > 0 then sand[ind[haut] - n] = sand[ind[haut] - n] + 1;
				if ncol(bas) > 0 then sand[ind[bas] + n] = sand[ind[bas] + n] + 1;
			end;
		end;
    end;

	title "Reprsentation du tas de sable après n itération";
	call heatmapcont(sand) xvalues=vname yvalues=vname colorramp={White CXFFEDC7 CXFBE646 CXFBC34D Orange} displayoutlines=0;
	title "Fréquence de la taille des avalanches";
	call histogram(s) scale='PROPORTION';
	title "Fréquence de la durée des avalanches (nombres d'itération avant stabilité)";
	call histogram(t) scale='PROPORTION';

	/*Conversion des données de taille pour les graphiques*/
	s_nonzero = s[loc(s > 0)];
	call tabulate(valeurs, effectif, s_nonzero);
	frequence = effectif/sum(effectif);

	/*Conversion de la ditribution de taille des avalanches en log log pour la régression*/
	log_freq_s = log(effectif/sum(effectif));
	log_s = log(valeurs);

	/*Création d'un data pour exporter en dehors de iml*/
	create distlogs var {"log_freq_s" "log_s" "valeurs" "frequence"};
	append;
	close distlogs;

	/*Conversion des données du temps pour les graphiques*/
	t_nonzero = t[loc(t > 0)];
	call tabulate(valeurs, effectif, t_nonzero);
	frequence = effectif/sum(effectif);

	/*Création d'un data pour exporter en dehors de iml*/
	create distlogt var {"frequence" "valeurs"};
	append;
	close distlogt;

quit;

proc sgplot data=distlogs;
scatter x=valeurs y=frequence / markerattrs = (symbol=circlefilled);
xaxis type=log label="Taille t";
yaxis type=log label="P(S=s)";
title "Fréquence de la taille des avalanches (log log)";
run;

proc sgplot data=distlogt;
   scatter x=valeurs y=frequence / markerattrs=(symbol=circlefilled);
   xaxis type=log label="Durée t" minor display=(nolabel);
   yaxis type=log label="P(T=t)" minor display=(nolabel);
   title "Distribution de la durée des avalanches (log-log)";
run;

title "Regression linéaire sur la taille des avalanches en log log avec max_taille_avalanche = 90";
proc reg data=distlogs(where=(log_s <= 4.5)); *car exp(4.5) = 90;
   model log_freq_s = log_s;
run;

