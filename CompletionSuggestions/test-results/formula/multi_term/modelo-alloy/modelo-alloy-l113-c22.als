abstract sig TasteType {}
sig GAMES, WALKS, SLEEP, TOYS, PETTING, FOOD, WATER, BATHS, COMPETITIONS, CARE extends TasteType {}

abstract sig Species {}
sig DOG, CAT, FERRET, RABBIT, IGUANA, SNAKE, TURTLE, PARROT, FISH extends Species {}

/**
  * Represents the abstract class User.
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
 * It has a "lone" relationship with Pet:
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

sig ProductAd extends 
	advertisedProduct : one Product,
	recommendedPets : some Pet
}
