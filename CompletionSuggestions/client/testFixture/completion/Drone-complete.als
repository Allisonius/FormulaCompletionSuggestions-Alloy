open util/integer

// esomee, pour qullil y ait au moins un drone
some sig Drone {
	position: one Intersection,
	commande: lone Commande,
	batterie: Int,
//	chemin : seq Receptacle
	chemin : one Chemin
}

one sig Temps {
	tempsActuel:Int
}

some sig Receptacle {
	position: one Intersection,
	next: lone Receptacle,
	contenu : Int
}


sig Chemin {
	actuel: one Receptacle,
	suivant: lone Chemin
}

one sig Entrepot {
	position: one Intersection,
	ensembleCommandes: set Commande
}

sig EnsembleProduits {
	contenu: Int
}

some sig Commande {
	destination: one Receptacle,
	ensembleProd: lone EnsembleProduits
}

sig Intersection {
	X : Int,
	Y : Int
}

fact {
	all e:EnsembleProduits | some c:Commande | c.ensembleProd = e     // Ensemble de Produits appartient à une commande
	all c:Commande | some e:Entrepot | c in e.ensembleCommandes      // Les commandes sont dans ltentrepôt. ça sert à rien ça non ?
	all c:Commande | one c.ensembleProd => c.destination.position != Entrepot.position     // Pas de commande livrée à ltentrepot si la commande contient un ensembleProd

	// A ameliorer
	all ep:EnsembleProduits | ep.contenu> 0 // implicite
	
}

// la batterie du drone est entre 0 et 3
fact BatterieDrone {
	all d:Drone | d.batterie >= 0 && 3 >= d.batterie
}

// les drones ont une capacite max de 5
fact CapaciteDrone {
	all d: Drone | d.commande.ensembleProd.contenu = 5
}

// les receptacles ont une capacite max de 10
fact CapaciteReceptacle {
	all r: Receptacle | r.contenu = 10
}

/* Il y a au moins un receptacle sur une intersection voisine de ltentrepot */
fact EntrepotAUnVoisin {
	some r:Receptacle | 
	((r.position.X = Entrepot.position.X+1 || r.position.X = Entrepot.position.X-1) && (r.position.Y = Entrepot.position.Y))
	||
	((r.position.X = Entrepot.position.X) && (r.position.Y = Entrepot.position.Y+1 || r.position.Y = Entrepot.position.Y-1))
}

/* Il nexiste pas 2 intersectiones identiques*/
fact IntersectionUnitaire {
	all disj i1,i2: Intersection | i1 != i2
}

/* Il nexiste pas des intersections avec 2 receptacles */
fact ReceptacleUnitaire {
	all disj r1,r2: Receptacle |
	not (r1.position=r2.position)
}

/* aucun receptacle ne peut partager son intersection avec ltentrepôt */
fact EntrepotPasSurReceptacle {
	all r: Receptacle | not (Entrepot.position = r.position)
}

// taille de la grille
fact LimitationPositions {
	all i:Intersection | i.X = 10 && i.X >= -10 && i.Y = 10 && i.Y >= -10
}


	// DERNIER TENTATIVE FAITS SUR LE CHEMIN
// il nyy a pas deux chemins identiques
fact CheminUnique {
	all disj c1, c2: Chemin | c1.actuel != c2.actuel || c1.suivant != c2.suivant
}

// il y a une distance de 3 max entre chaque receptacle
fact VerifierDistance {
	all c:Chemin | one c.suivant => distance[c.actuel.position, c.suivant.actuel.position] = 3
}

// il y a toujours un chemin entre deux receptacles
fact ToujoursChemin {
	all r1, r2: Receptacle |
		r1 != r2 => (some ch:Chemin | calculerCheminBis[r1, r2, ch])
}

// le chemin ne boucle pas sur lui-meme
fact SuivantNonCyclique {
	all c: Chemin | c.actuel not in c.^suivant.actuel
}


pred simuler {
	initialiser
	iterer
}

pred initialiser {
	Temps.tempsActuel = 0
	all d:Drone | d.batterie = 3
	all d:Drone | attribuerCommande[d]
	all d:Drone | trouverPremierReceptacle[d]
//	all d:Drone | calculerChemin[d, first[d.chemin], d.commande.destination]
	all d:Drone | some c:Chemin | calculerCheminBis[d.chemin.actuel, d.commande.destination, c]
}

pred iterer {
	all d:Drone | allerAuReceptacle[d]
}


pred attribuerCommande[d:Drone] {
	one c:Commande | no d.commande => d.commande = c // one Commande ou some ?
}
 
pred deposerCmd {
	all d:Drone |
    (one d.commande  && d.commande.destination.position = d.position) =>
	no d.commande
}


// calcul du chemin avec le chemin chaine
pred calculerCheminBis[debut, fin: Receptacle, cheminDeb: Chemin] {
	one cheminFin: Chemin |
	cheminDeb.actuel = debut // le chemin commence par le premier receptacle
	&& cheminFin.actuel = fin // et termine par le dernier
	&& no cheminFin.suivant // le dernier chemin naa pas de suivant
	&& cheminFin in cheminDeb.^suivant // le dernier chemin fait partie des suivants du premier (fermeture transitive)
}


pred trouverPremierReceptacle[d:Drone] {
	some r:Receptacle |	
	verifierDistanceInter[d.position, r.position] 
//	=> d.chemin= d.chemin.add[r]
	=> d.chemin.actuel = r
}

pred verifierDistanceRecep[r1:Receptacle, r2:Receptacle]{
	distance[r1.position, r2.position] < 4
}

pred verifierDistanceInter[i1:Intersection, i2:Intersection]{
	abs[i1.X-i2.X] + abs[i1.Y-i2.Y] < 4
}

// a modifier : il ne va plus a sa destination finale mais au suivant de sa liste de receptacles
pred allerAuReceptacle[d:Drone]{
	d.position.X<d.commande.destination.position.X => d.position.X=d.position.X+1
	else d.position.X>d.commande.destination.position.X => d.position.X=d.position.X-1
	else d.position.Y<d.commande.destination.position.Y => d.position.Y=d.position.Y+1
	else d.position.Y>d.commande.destination.position.Y => d.position.Y=d.position.X-1
	else allerAEntrepot[d]
}

// idem
pred allerAEntrepot[d:Drone]{
	d.position.X<Entrepot.position.X => d.position.X=d.position.X+1
	else d.position.X>Entrepot.position.X => d.position.X=d.position.X-1
	else d.position.Y<Entrepot.position.Y => d.position.Y=d.position.Y+1
	else d.position.Y>Entrepot.position.Y => d.position.Y=d.position.X-1
	else attribuerCommande[d]
}


/***************************************
							Fun
***************************************/

// calcule la valeur absolue
fun abs[x: Int] : Int {
	(x<0) => x.mul[-1] else (x)
}

// calcule la distance entre deux intersections
fun distance[i1,i2: Intersection]: Int {
    abs[i1.X.sub[i2.X]].add[abs[i1.Y.sub[i2.Y]]]
}

run simuler for exactly 1 Drone, exactly 5 Intersection, exactly 2 Receptacle, 3 Commande, 3 EnsembleProduits, 6 int, 5 Chemin


assert Test1 {
	some x : Int |  abs[x]<0
}

check Test1 for 3
