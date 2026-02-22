package alloy.language.server.models.presets;

import alloy.language.server.models.CompletionModelBuilder;

public class ModeloAlloyModel {
	public static CompletionModelBuilder modelBuilder() {
		/*
		abstract sig TasteType {}
sig GAMES, WALKS, SLEEP, TOYS, PETTING, FOOD, WATER, BATHS, COMPETITIONS, CARE extends TasteType {}

abstract sig Species {}
sig DOG, CAT, FERRET, RABBIT, IGUANA, SNAKE, TURTLE, PARROT, FISH extends Species {}

/**
  * Represents the

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

		 */
		CompletionModelBuilder builder = CompletionModelBuilder.modelBuilder();
		builder.withContent("abstract sig TasteType {}")
				.withContent("sig GAMES, WALKS, SLEEP, TOYS, PETTING, FOOD, WATER, BATHS, COMPETITIONS, CARE extends TasteType {}")
				.withContent("abstract sig Species {}")
				.withContent("sig DOG, CAT, FERRET, RABBIT, IGUANA, SNAKE, TURTLE, PARROT, FISH extends Species {}")
				.withContent("abstract sig User {")
				.withContent("name : one Name")
				.withContent("}")
				.withContent("sig Owner extends User {")
				.withContent("ownerOf : some Pet")
				.withContent("}")
				.withContent("sig Pet extends User {")
				.withContent("petOf : some Owner,")
				.withContent("vaccinationRecord : set Vaccine,")
				.withContent("friends : set Pet,")
				.withContent("likes : some TasteType,")
				.withContent("allVaccines : lone VaccinesUpToDate,")
				.withContent("aggression : lone AggressiveBehavior,")
				.withContent("petSpecies : one Species,")
				.withContent("posts : set NormalPost")
				.withContent("}")
				.withContent("sig VaccinesUpToDate{")
				.withContent("}")
				.withContent("sig Name{")
				.withContent("}")
				.withContent("sig Vaccine {")
				.withContent("}")
				.withContent("sig Date{")
				.withContent("DayValue:one Int")
				.withContent("}")
				.withContent("one sig currentDate {")
				.withContent("DayValue: one Int")
				.withContent("}")
				.withContent("one sig AggressiveBehavior{")
				.withContent("}")
				.withContent("sig Product {")
				.withContent("TargetSpecies : some Species")
				.withContent("}")
				.withContent("sig Veterinarian {")
				.withContent("verifies : set Product")
				.withContent("}")
				.withContent("abstract sig Publication {")
				.withContent("tagged : set User,")
				.withContent("publishedDate : one Date")
				.withContent("}")
				.withContent("sig NormalPost extends Publication {")
				.withContent("publisher : one Pet")
				.withContent("}")
				.withContent("sig Comment  {")
				.withContent("commentedPost : one Publication,")
				.withContent("author : one Owner")
				.withContent("}")
				.withContent("sig Event extends Publication {")
				.withContent("participants : set Pet,")
				.withContent("creator : one Owner,")
				.withContent("location : one Location,")
				.withContent("eventDate : one Date,")
				.withContent("eventStatus : lone EventConfirmed")
				.withContent("}")
				.withContent("sig Location{")
				.withContent("}")
				.withContent("one sig EventConfirmed{")
				.withContent("}")
				.withContent("sig AdoptionAd extends Publication {")
				.withContent("adoptPet : one Pet")
				.withContent("}")
				.withContent("sig ProductAd extends Publication {")
				.withContent("advertisedProduct : one Product,")
				.withContent("recommendedPets : some Pet")
				.withContent("}");
		return builder;
	}
}
