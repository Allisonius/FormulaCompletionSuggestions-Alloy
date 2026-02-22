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
