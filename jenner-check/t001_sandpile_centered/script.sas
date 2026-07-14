/* Modele du tas de sable - version centree (algorithme de Bak, Tang, Wiesenfeld) */
/* Depot centre deterministe sur une grille n x n, topplings jusqu'a stabilite.   */
/* Grille reduite (n=121) pour une execution rapide et reproductible ; la logique  */
/* de redistribution est identique au script original du depot.                    */
proc iml;
    n = 121;                          *Taille de la matrice;
    sand = j(n, n, 0);                *Creation d'une matrice vide;
    center = ceil((n+1) / 2);         *Centre de la matrice;
    sand[center,center] = 20000;      *Depot centre;

    *On cree une boucle pour etaler le sable;
    do while(max(sand) >= 4);         * jusqu'a ce que le tas soit stable;
        ind = loc(sand >= 4);         *On trouve les cases ou il y a 4 grains ou plus;
        if ncol(ind) > 0 then do;
            sand[ind] = sand[ind] - 4;                 *La case perd 4 grains;
            gauche = loc(mod(ind, n) ^= 1);            *pas sur la premiere colonne;
            droite = loc(mod(ind, n) ^= 0);            *pas sur la derniere colonne;
            haut = loc(ind > n);                       *pas sur la premiere ligne;
            bas  = loc(ind <= n*(n-1));                *pas sur la derniere ligne;
            if ncol(gauche) > 0 then sand[ind[gauche] - 1] = sand[ind[gauche] - 1] + 1;
            if ncol(droite) > 0 then sand[ind[droite] + 1] = sand[ind[droite] + 1] + 1;
            if ncol(haut) > 0 then sand[ind[haut] - n] = sand[ind[haut] - n] + 1;
            if ncol(bas) > 0 then sand[ind[bas] + n] = sand[ind[bas] + n] + 1;
        end;
    end;

    /* Etat final stable : chaque case porte 0, 1, 2 ou 3 grains */
    mx    = max(sand);                *Hauteur maximale (doit etre < 4);
    total = sum(sand);               *Grains conserves sur la grille;
    /* Distribution des hauteurs sur la configuration critique finale */
    h0 = sum(sand = 0);
    h1 = sum(sand = 1);
    h2 = sum(sand = 2);
    h3 = sum(sand = 3);
    print mx total, h0 h1 h2 h3;

    /* Export de la distribution des hauteurs pour analyse hors IML */
    hauteur = {0, 1, 2, 3};
    effectif = h0 // h1 // h2 // h3;
    create heights var {"hauteur" "effectif"};
    append;
    close heights;
quit;

proc print data=heights noobs;
    title "Distribution des hauteurs - configuration critique (depot centre)";
run;
