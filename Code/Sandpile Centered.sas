proc iml;
    
    n = 301; *Taille de la matrice : 201 pour centrée et 20 pour aléatoire;
    sand = j(n, n, 0); *Création d'une matrice vide;
    center = ceil((n+1) / 2); *Centre de la matrice;
	/*Centré*/
	sand[center,center] = 100000;
	/*Centres des quart de matrice*/
	*sand[center*0.5,center*0.5] = 200000;
	*sand[center*1.5,center*1.5] = 200000;
	*sand[center*0.5,center*1.5] = 200000;
	*sand[center*1.5,center*0.5] = 200000;
	/*Sur les 4 sommets*/
    *sand[1,1] = 5000000;
	*sand[n,n] = 5000000;
	*sand[1,n] = 5000000;
	*sand[n,1] = 5000000;

    *On crée une boucle pour étaler le sable;
		do while(max(sand) >= 4); * jusqu'à que le tas soit stable;
        	ind = loc(sand >= 4); *On trouve les cases ou il y a 4 grains ou plus;
			if ncol(ind) > 0 then do;
        		sand[ind] = sand[ind] - 4; *La case perd 4 grains;
        		/* On redistribut ces grains au cases voisines : */
        		gauche = loc(mod(ind, n) ^= 1); *pas sur la première colonne;
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

	title "Reprsentation du tas de sable après n itération";
	call heatmapcont(sand) xvalues=vname yvalues=vname colorramp={cx8B0000 cxC62828 cxFF6F00 cxFFA726 cxFFD54F} displayoutlines=0;


