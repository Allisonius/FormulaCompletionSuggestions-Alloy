module statecoverage
open util/integer
open util/boolean

abstract sig System {}

abstract sig State {system: one System}

abstract sig Transition {from, to: one State}

sig Coverage { paths: some Path }

sig Path { firstStep: one Step }

sig Step {
	from, to: one State,
	via: one Transition,
	nextStep: lone Step
}

/*** GENERATED CODE START ***/
one sig s7, End, s6, s10, s2, s9, s5, s8, Initial, s1, s3, s4 extends State {}

some sig S extends System {
	output: Int
}

lone sig t19 extends Transition {}

lone sig t35 extends Transition {}

lone sig t17 extends Transition {}

lone sig t36 extends Transition {}

lone sig t18 extends Transition {}

lone sig t33 extends Transition {}

lone sig t15 extends Transition {}

lone sig t34 extends Transition {}

lone sig t16 extends Transition {}

lone sig t39 extends Transition {}

lone sig t13 extends Transition {}

lone sig t14 extends Transition {}

lone sig t37 extends Transition {}

lone sig t11 extends Transition {}

lone sig t38 extends Transition {}

lone sig t12 extends Transition {}

lone sig t21 extends Transition {}

lone sig t20 extends Transition {}

lone sig t43 extends Transition {}

lone sig t42 extends Transition {}

lone sig t41 extends Transition {}

lone sig t40 extends Transition {}

lone sig t45 extends Transition {}

lone sig t44 extends Transition {}

lone sig t46 extends Transition {}

lone sig t22 extends Transition {}

lone sig t23 extends Transition {}

lone sig t24 extends Transition {}

lone sig t25 extends Transition {}

lone sig t26 extends Transition {}

lone sig t27 extends Transition {}

lone sig t28 extends Transition {}

lone sig t29 extends Transition {}

lone sig t3 extends Transition {}

lone sig t2 extends Transition {}

lone sig t10 extends Transition {}

lone sig t1 extends Transition {}

lone sig t0 extends Transition {}

lone sig t30 extends Transition {}

lone sig t7 extends Transition {}

lone sig t6 extends Transition {}

lone sig t32 extends Transition {}

lone sig t5 extends Transition {}

lone sig t31 extends Transition {}

lone sig t4 extends Transition {}

lone sig t9 extends Transition {}

lone sig t8 extends Transition {}

/*** GENERATED CODE END ***/
