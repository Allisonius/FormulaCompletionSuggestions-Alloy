abstract sig TasteType {}
sig GAMES, WALKS, SLEEP, TOYS, PETTING, FOOD, WATER, BATHS, COMPETITIONS, CARE extends TasteType {}

abstract sig Species {}
sig DOG, CAT, FERRET, RABBIT, IGUANA, SNAKE, TURTLE, PARROT, FISH extends Species {}

/**
  * Represents the User class
  */
abstract sig User {
  name : one Name
  
}

sig Owner extends User {
  ownerOf : some Pet
}

sig Pet extends User {
  petOf : some Owner,
  vaccinationRecord : set Vaccine,
  friends : set Pet,
  likes : some TasteType,
  allVaccines : lone VaccinesUpToDate,
  aggression : lone AggressiveBehavior,
  petSpecies : one Species,
  posts : set NormalPost
}

/**
 * This signature represents the Boolean attribute "vaccinesUpToDate" of a pet.
 * It has a
 * If it relates to a pet, that pet has all vaccines up to date -> can publish adoption ads.
 *
 * If it does not relate to a pet, that pet does not have all vaccines up to date -> cannot publish adoption ads.
 */
sig VaccinesUpToDate{
  // represents the Boolean attribute "vaccinesUpToDate" of the pet
}

sig Name{
  // represents the user name
  // needed for fact UniqueName
}

sig Vaccine {
  // represents a vaccine object
}


sig Date{
  // We represent dates as an integer
  DayValue:one Int
}

one sig currentDate {
  // We represent the current date to compare with other dates
  DayValue: one Int
}

one sig AggressiveBehavior{
  // Represents aggressive behavior of a pet
  // needed for behavioral restrictions on pets
}


// A product can be intended for one or more species
sig Product {
  TargetSpecies : some Species
}

sig Veterinarian {
  verifies : set Product
}

	//No contemplabamos que una mascota creara un evento o anuncions
	//entonces lo hemos dividido en dos signaturas
abstract sig Publication {
	tagged : set User,
  publishedDate : one Date
}

sig NormalPost extends Publication {
	publisher : one Pet
}

sig Comment  {
	commentedPost : one Publication,
	author : one Owner
}

sig Event extends Publication {
	participants : set Pet,
	creator : one Owner,
  location : one Location,
  eventDate : one Date,
  eventStatus : lone EventConfirmed
}

sig Location{
  // Represents the location of an event
  // needed for event restrictions
}

one sig EventConfirmed{
  // Represents the confirmation status of an event
}

sig AdoptionAd extends Publication {
  adoptPet : one Pet
}

sig ProductAd extends Publication {
	advertisedProduct : one Product,
	recommendedPets : some Pet
}



// ********************************************** Restricciones para cardinalidades **********************************************


// Cardinality of the relationship between pet and owner -> Pet [1..4] <-> [1..*]Owner
/**
 * Fact that states a pet must be a "pet" of the owner that has it as owner.
 */
// fact ownersSymmetric {
//   all m: Pet | all p: m.petOf | m in p.ownerOf
// }


/**
 * Fact that states friendship must be bidirectional.
 */
// fact FriendshipBidirectional {
// 	  // For two pets to be friends, they must have mutual friendship
//   all m1, m2: Pet | m1 in m2.friends implies m2 in m1.friends
// }


// The publisher of a post must have that post in the posts relation -> NormalPost [0..*] <-> [1]Pet
// fact postsBidirectional{
//   all p: NormalPost | p in p.publisher.posts
// }

// fact anuncioMascota{
//   all aP,aP2: AnuncioAdopcion | aP.mascotaAdopcion != aP2.mascotaAdopcion
// }

// fact OneAdoptionAdPerPet {
//   all m: Pet | lone a: AdoptionAd | a.adoptPet = m
// }

// *********************************************** Restricciones para fechas **********************************************
/**
  * Fact that states any date must be positive.
*/
// fact nonNegativeDate{
//     all f :Date | f.DayValue > 0 
// }
// Suponemos un valor concreto para la fecha actual

// fact currentDateValue{
//   currentDate.DayValue > 4
// }



// fact publicationDateNotAfterCurrent{
//   all p: Publication | p.publishedDate.DayValue =< currentDate.DayValue
// }

/**
   * Function that calculates the day difference between the current date and a given date.
   * Returns an integer.
  */
fun daysRemaining[f1: Date]: Int {
  f1.DayValue.minus[currentDate.DayValue]
}

/**
   * Function that calculates the day difference between two dates.
   * Returns an integer.
  */
fun dateDifference[f1: Date, f2: Date]: Int {
  // Returns the difference between two dates
  f1.DayValue.minus[f2.DayValue]
}

// ********************************************** Restricciones Generales **********************************************


/**
   * Fact that indicates a product can have at most
  */
// fact oneAdPerProduct{
//     // A product may have an ad or not
//     // If it has an ad, it cannot have more than one
//     all p: Product | lone aP: ProductAd | p in aP.advertisedProduct
// }




// ***************** Restriccion 1 *****************
  // Maximum number of pets per owner
// fact MaxPetsPerOwner {
//   all p: Owner | #p.ownerOf =< 4
// }

// ***************** Restriccion 2 *****************
// Compatibilidad entre mascotas

/**
 * Fact that states two pets must share at least 2 likes to be friends.
 */
// fact FriendshipBasedOnLikes {
//   // For two pets to be friends, they must have at least 2 likes in common
//   all m1, m2: Pet | m2 in m1.friends implies sharedLikes[m1, m2] >= 2
// }

/**
 * Function that calculates the number of shared likes between two pets.
 * Used to verify if two pets can be friends.
 */
// fun sharedLikes[m1, m2: Pet]: Int {
//   #(m1.likes & m2.likes)
// }

// ***************** Restriccion 3 y 13 *****************

// Por simplificar el modelo en alloy, consideramos que un producto es verificado si ha sido revisado por al menos cuatro veterinarios

/**
 * Function that indicates whether a product has been verified.
 */
fun productVerifiedByVet[prod: Product]: Int {
  
  // For simplicity, a product is verified if it has been reviewed by at least four veterinarians
   #{ v: Veterinarian | prod in v.verifies } > 3 implies 1 else 0



}

/**
  * Fact that indicates a ProductAd must be for a veterinarian-verified product.
  * A product is considered verified if it has been reviewed by at least four veterinarians.
  */
// fact ProductVerifiedByVets {
//   all aP: ProductAd | productVerifiedByVet[aP.advertisedProduct] > 0 
// }


// ***************** Restriccion 4 *****************
/**
 * Fact that indicates recommended pets in a product ad must match the product's target species.
 */
fact ProductRecommendedByPet {
  all aP: ProductAd | 
    all m: aP.recommendedPets | 
      // The recommended pet must be of the same species as the product
      #(aP.advertisedProduct.TargetSpecies &
   		m.petSpecies)=1
    
   
}


// ***************** Restriccion 5 *****************

/**
  * Fact that indicates a pet can make at most 3 posts per day.
  */
  // Para cada mascota y cada fecha, limitar a máximo 3 publicaciones en esa fecha
fact PetMaxThreePostsPerDate {
  all m: Pet | all f: Date | #{ p: NormalPost | p in m.posts and p.publishedDate = f } =< 3
}

// ***************** Restriccion 6 *****************
// Pets with aggressive behavior are suspended
// In Alloy, since we don't have attributes, we model pet state with a signature.
// This restriction is irrelevant in this Alloy model


//***************** Restriccion 7 *****************
// Las mascotas puestas en adopcion deben tener todas sus vacunas al día
/**
 * Fact that indicates a pet in an adoption ad must have all vaccines up to date.
 */
// fact AdoptionAdWithValidVaccines {
//   all aa: AdoptionAd | one aa.adoptPet.allVaccines
// }


// ***************** Restriccion 8 *****************
// A pet cannot sign up for two events with the same date
// fact PetCannotJoinTwoEventsSameDate {
//   all m: Pet, e1, e2: Event | 
//     e1 != e2 and m in e1.participants and m in e2.participants implies 
//     e1.eventDate.DayValue != e2.eventDate.DayValue
// }




//***************** Restriccion 9 *****************

//***************** Restriccion 10 *****************

// Events cannot take place if fewer than 6 pets are registered
fact eventSuspended{
  all e: Event | {
    (daysRemaining[e.eventDate] =< 7 and #{e.participants}=<6) implies #(e.eventStatus)>0
  } 
}


//***************** Restriccion 11 *****************

// There cannot be two users with the same name
// fact UniqueName {
//   // There cannot be two users with the same name
//   all u1, u2: User | u1 != u2 implies u1.name != u2.name
// }

// ***************** Restriccion 12 *****************
// Suspended pets cannot register for events

// fact EventNoAggressive {
//   // There cannot be events that have pets with aggressive behavior
//   all e:Event | no e.participants.aggression
// }


// ***************** Restriccion 14 *****************
// Una mascota no puede ser amiga de sí misma
/**
 * Fact that indicates pets cannot be friends with themselves.
*/
// fact PetNoSelfFriends {
//   // There cannot be pets that are friends with themselves
//   all m: Pet | m !in m.friends
// }

// ***************** Restriccion 15 *****************
// Las mascotas suspendidas no pueden ser adopatadas
/**
 * Fact that indicates a pet with aggressive behavior cannot be adopted.
 */
// fact AggressiveAdoption {
// 	// There cannot be adoption ads that include pets with aggressive behavior
//   all a:AdoptionAd | no a.adoptPet.aggression 
// }

// ***************** Restriccion 16 *****************

// Two events cannot have the same date if they are in the same location

// fact EventsCannotShareDateAndLocation {
//   // Two different events cannot have the same date and location at the same time
//   all e1, e2: Event | e1 != e2 implies 
//     (e1.eventDate != e2.eventDate or e1.location != e2.location)
// }

// ***************** Restriccion 17 *****************
/**
 * Fact that indicates a pet must have at least 3 likes.
 */
// fact MinLikesPerPet {
//   all m: Pet | #m.likes >= 3
// }

// ***************** Restriccion 18 *****************

// All dates generated in the model must be after the current date
/**
  * Fact that indicates an event date must be at least
  * 7 days after the event creation date.
  */
// fact eventWithWeekAdvance {
//   all e: Event | dateDifference[e.eventDate, e.publishedDate] > 7
// }



// fact eventoConSemanaDeAnticipacion {
//   all e: Evento | e.fechaEvento.ValorDias > e.fechaPublicada.ValorDias
// }



// ********************************************** Predicados **********************************************


// pred ProductVerifiedByVetsPred {
//   #ProductAd > 4
//   some a :ProductAd| productVerifiedByVet[a.advertisedProduct] > 0
//   some a2 :ProductAd | productVerifiedByVet[a2.advertisedProduct] = 0
// }
 //run ProductoVerificadoPorVeterinariosPred for 15
// pred oneAdPerProductPred{
//   #ProductAd > 4
//   some p: Product | lone aP: ProductAd | p in aP.advertisedProduct
// }

//run unAnuncioPorProductoPred for 15




// pred petInAdoptionWithoutVaccines {
//   // There must be at least one adoption ad
//   some aa: AdoptionAd | 
//     // The pet in adoption does NOT have vaccines up to date
//     #(aa.adoptPet.allVaccines)=0
  
// }


pred fivePetsOneOwner {
  // There is exactly one owner
  one p: Owner | {
    // There are exactly 5 pets
    #Pet = 5
    
    // Each pet belongs to the owner
    all m: Pet | m in p.
  }
}
pred PetMaxThreePostsPerDatePred{
  one m: Pet | {
    // The pet has exactly 4 posts in one day
    one f: Date | 
      #{ p: NormalPost | p in m.posts and p.publishedDate = f } = 4
  }
}
//run MascotaMaxTresPublicacionesPorFechaPred for 15

// pred minEvents{

//   #Event > 4
//   currentDate.DayValue = 100  
//   one e: Event | #e.eventStatus = 0
// }

// ************************************************ asserts ***********************************************
// assert PetMaxThreePostsPerDateAssert {
//   #NormalPost =4
	 
//   //fechaActual.ValorDias = 100
//   all m: Pet| all f: Date | #{ p: NormalPost | p in m.posts and p.publishedDate = f } =< 3
// }
// check PetMaxThreePostsPerDateAssert for 15 but 8 Int




/**
 * Assert that checks if friendship is bidirectional.
 */
// assert FriendshipBidirectionalAssert {
//   all m: Pet | all p: m.petOf | m in p.ownerOf
// }



// Assert to verify that friendship is symmetric
// assert FriendshipIsSymmetric {
//   all m1, m2: Pet | m1 in m2.friends implies m2 in m1.friends
// }


// assert AdoptionAdWithValidVaccinesAssert {
//   all aa: AdoptionAd | one aa.adoptPet.allVaccines
// }


// assert PetNoSelfFriendsAssert {
//   // There cannot be pets that are friends with themselves
//   all m: Pet | m !in m.friends
// }

// assert MaxPetsPerOwnerAssert {
//   all p: Owner | #p.ownerOf =< 4
//  }

// assert MinLikesPerPetAssert {
//   all m: Pet | #m.likes >= 3
//  }

//  assert ads{
//   // For each product ad, the product must target exactly one species
//   #ProductAd > 4
//   some aa: ProductAd | #aa.advertisedProduct.TargetSpecies = 1

//   // For each product ad, the product targets more than one species
//   some ap: ProductAd | #ap.advertisedProduct.TargetSpecies > 1
// }

// check ads for 15
