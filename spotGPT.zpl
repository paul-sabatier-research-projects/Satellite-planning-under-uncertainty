#  Allocation de prises de vue "spot"
# helene fargier, 1 juillet 2024


# Lecture des données d un pb spot dans le fichier specifié
#############################################################

param fichier := "data/spot4.tex" ;

param DU        :=  read fichier as "1n" comment "#" use 1 ;
param VI        :=  read fichier as "1n" comment "#" skip 1 use 1 ;
param PMmax     :=  read fichier as "1n" comment "#" skip 2 use 1 ;
param NbImages  :=  read fichier as "1n" comment "#" skip 3 use 1 ;
param n         := 4;  # on vient de lire 4 images


set images:= { 1..NbImages };

param type[images]  := read fichier as "n+"  comment "#" skip  n;
param PM[images]    := read fichier as "n+"  comment "#" skip  n +NbImages;
param PA[images]    := read fichier as "n+"  comment "#" skip  n +NbImages*2;
param Pinf[images]  := read fichier as "n+"  comment "#" skip  n +NbImages*3;
param Psup[images]  := read fichier as "n+"  comment "#" skip  n +NbImages*4;

param Nbinstruments :=  read fichier as "1n" comment "#" skip  n +NbImages*5 use 1 ;
set instruments     := { 1.. Nbinstruments };

param Pfail[instruments]                := read fichier as "n+"  comment "#" skip  n +NbImages*5 + 1;
param startDate[images*instruments]     := read fichier as "n+"  comment "#" skip n  +NbImages*5 + Nbinstruments + 1;
param angle[images*instruments]         := read fichier as "n+"  comment "#" skip n +NbImages*5 + Nbinstruments*2 + 1;


# verification des données lues
###############################

do print "duree : " , DU ; 
do print "vitesse : " , VI ;
do print "Pmax : " , PMmax ;  
do print "NbImages : " , NbImages ; 
do forall <i> in images: print "image " , i, " : type = ", type[i],  " : pm = ", PM[i],  " : pa = ", PA[i], " pinf = ", Pinf[i], " psup = ", Psup[i] ;

do print "NbInstruments : " , Nbinstruments ; 
do forall <j> in instruments: print "instrument " , j, " : Pfail = ", Pfail[j]; 

do print "startdates";
do forall <i> in images :  print "ins1 ", startDate[i,1],  " ins2 ", startDate[i,2],  " ins3 ", startDate[i,3] ;

do print "angle";
do forall <i> in images :  print "ins1 ", angle[i,1],  " ins2 ", angle[i,2],  " ins3 ", angle[i,3] ;


# les variables de decision
###########################


var selection[images]  binary;   # selection[i] = 1 <=> image i selectionnée
var assignedTo[images*instruments]  binary; # assignedTo[i, j] = 1 <=> image i assignée à l'instrument j

# Modification de la maximisation pour prendre en compte le PM et PA
maximize valeur : sum <i> in images: selection[i] * (1.5*PA[i] + PM[i]);

# Réduction des transitions inutiles et ajout de pondération pour les angles
subto transition : 
forall <ima1, ima2,ins> in images*images*instruments 
            with ima1 < ima2  
                and  abs(startDate[ima1,ins] - startDate[ima2,ins]) * VI    <  DU  * VI + abs(angle[ima1,ins] - angle[ima2,ins]) * 0.5 :
        
    assignedTo[ima1,ins] + assignedTo[ima2,ins] <= 1 ;
    
# Simplification des contraintes de correspondance pour les images de type 1 et 2
subto correspondancemono:
forall <ima> in images with type[ima]==1  : 
    sum <j> in instruments : assignedTo[ima,j] == selection[ima] ;

subto correspondancestereo:
forall <ima> in images with type[ima]==2  :
    assignedTo[ima,1] == selection[ima] and assignedTo[ima,3] == selection[ima] and assignedTo[ima,2] == 0;

# Ajout d'une contrainte sur la charge maximale pour chaque instrument
subto maxCharge:
forall <j> in instruments :
      sum <i> in images : assignedTo[i,j] * PM[i] <= PMmax;
