/* Modele du tas de sable - version aleatoire (Bak, Tang, Wiesenfeld) */
/* Depot aleatoire seede (uniform(1)) ; suivi de la taille et de la duree */
/* des avalanches ; grille et nombre d'iterations reduits pour une         */
/* execution rapide et reproductible. Logique identique au script original.*/
proc iml;
    n = 40;                 *Taille de la matrice;
    z = 3000;               *Nombre d'iterations;
    sand = j(n, n, 0);      *Creation d'une matrice vide;
    s = j(1, z, 0);         *Compte les avalanches (taille);
    t = j(1, z, 0);         *Compte le temps des avalanches (duree);

    do i=1 to z;
        x = ceil(n * uniform(1));
        y = ceil(n * uniform(1));
        sand[x,y] = sand[x,y] + 1;                *grain sur une case aleatoire;
        do while(max(sand) >= 4);
            ind = loc(sand >= 4);
            if ncol(ind) > 0 then do;
                s[i] = s[i] + ncol(ind);          *taille de l'avalanche;
                t[i] = t[i] + 1;                  *duree de l'avalanche;
                sand[ind] = sand[ind] - 4;
                gauche = loc(mod(ind, n) ^= 1);
                droite = loc(mod(ind, n) ^= 0);
                haut = loc(ind > n);
                bas  = loc(ind <= n*(n-1));
                if ncol(gauche) > 0 then sand[ind[gauche] - 1] = sand[ind[gauche] - 1] + 1;
                if ncol(droite) > 0 then sand[ind[droite] + 1] = sand[ind[droite] + 1] + 1;
                if ncol(haut) > 0 then sand[ind[haut] - n] = sand[ind[haut] - n] + 1;
                if ncol(bas) > 0 then sand[ind[bas] + n] = sand[ind[bas] + n] + 1;
            end;
        end;
    end;

    /* Distribution de la taille des avalanches (comme dans le script original) */
    s_nonzero = s[loc(s > 0)];
    call tabulate(valeurs, effectif, s_nonzero);
    frequence = effectif/sum(effectif);

    /* Conversion log-log de la distribution de taille */
    log_freq_s = log(effectif/sum(effectif));
    log_s = log(valeurs);

    create distlogs var {"log_freq_s" "log_s" "valeurs" "frequence"};
    append;
    close distlogs;

    nb_avalanches = ncol(s_nonzero);
    taille_max = max(s_nonzero);
    print nb_avalanches taille_max;
quit;

/* Distribution taille des avalanches (log-log) - comme dans le depot */
proc sgplot data=distlogs;
   scatter x=valeurs y=frequence / markerattrs=(symbol=circlefilled);
   xaxis type=log label="Taille t";
   yaxis type=log label="P(S=s)";
   title "Frequence de la taille des avalanches (log log)";
run;

/* Regression lineaire log-log sur la taille des avalanches */
title "Regression lineaire sur la taille des avalanches en log log";
proc reg data=distlogs;
   model log_freq_s = log_s;
run;
