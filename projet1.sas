
data profil_web_export;
         sep=";";
         length  num_cli $8 connexion_mois $6 source_web $35 typ_client $35 montant_credit $17 activite $7 anciennete $8 utilisation_credit $8 logmt $19
                 sitfam $19 dept $24 tr_age $9 revfyr $12 assurance $17;

         infile  '\\ad.univ-lille.fr\Etudiants\Homedir3\316050\Documents\M2\clustering\cours-20241002T144907Z-001\cours\bdd_profilweb.txt'  dlm=sep missover dsd firstobs=2;

         input num_cli connexion_mois source_web typ_client montant_credit activite anciennete utilisation_credit logmt sitfam dept tr_age revfyr assurance;

run;

data profil_web_export;
set profil_web_export;
if montant_credit='?' then montant_credit='? mt credit';
if anciennete='?' then anciennete='?mois';
if assurance='?' then assurance='?assu';
if revfyr='manquant' then revfyr='? revenu';
if activite='?' then activite='?acti';
run;


*Etape 2: Statistiques descriptives de la BDD (statistiques simples- croisees);

proc freq data=profil_web_export;table connexion_mois source_web typ_client montant_credit anciennete activite logmt sitfam tr_age revfyr assurance/missing;run;


proc freq data=profil_web_export;table typ_client*activite typ_client*montant_credit typ_client*anciennete typ_client*logmt typ_client*sitfam typ_client*tr_age typ_client*revfyr typ_client*assurance/missing chisq ;run;


*Etape 3: Création echantillon prealable a l ACM ;

data profil_web_export;
set profil_web_export;
alea=uniform(0);
run;

proc sort data=profil_web_export;
by alea;
run;

data wrk.cm_profilweb_ech;
set profil_web_export (obs=10000);
run;


*Etape 4: ACM;

proc corresp data= wrk.cm_profilweb_ech  dimens=20 outc=wrk.cm_profilweb_recupacm /*noprint*/;
tables num_cli,/*connexion_mois source_web*/ typ_client montant_credit anciennete activite logmt sitfam tr_age revfyr assurance;
run;
