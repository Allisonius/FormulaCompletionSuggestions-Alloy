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

fun step (p: Path): set Step {
	p.firstStep.*nextStep
}

fun transitions (p:Path): set Transition {
	p.firstStep.via + p.firstStep.*nextStep.via
}

pred inheritSystem(s1, s2: System) {
	s1 = s2
}

pred initSystem(s:System) {
	s.output = 0
}

fact Step_facts {
	all s: Step |
		s.via.from = s.from &&
		s.via.to = s.to
}

fact t19_facts {
	t19.from = s3
	t19.to = s2
	inheritSystem[t19.from.system, t19.to.system]
}

fact t35_facts {
	t35.from = s6
	t35.to = s4
	inheritSystem[t35.from.system, t35.to.system]
}

fact t17_facts {
	t17.from = s2
	t17.to = s10
	inheritSystem[t17.from.system, t17.to.system]
}

fact t36_facts {
	t36.from = s7
	t36.to = s1
	inheritSystem[t36.from.system, t36.to.system]
}

fact t18_facts {
	t18.from = s3
	t18.to = s1
	inheritSystem[t18.from.system, t18.to.system]
}

fact t33_facts {
	t33.from = s6
	t33.to = s2
	inheritSystem[t33.from.system, t33.to.system]
}

fact t15_facts {
	t15.from = s2
	t15.to = s7
	inheritSystem[t15.from.system, t15.to.system]
}

fact t34_facts {
	t34.from = s6
	t34.to = s3
	inheritSystem[t34.from.system, t34.to.system]
}

fact t16_facts {
	t16.from = s2
	t16.to = s9
	inheritSystem[t16.from.system, t16.to.system]
}

fact t39_facts {
	t39.from = s7
	t39.to = s6
	inheritSystem[t39.from.system, t39.to.system]
}

fact t13_facts {
	t13.from = s2
	t13.to = s5
	inheritSystem[t13.from.system, t13.to.system]
}

fact t14_facts {
	t14.from = s2
	t14.to = s6
	inheritSystem[t14.from.system, t14.to.system]
}

fact t37_facts {
	t37.from = s7
	t37.to = s3
	inheritSystem[t37.from.system, t37.to.system]
}

fact t11_facts {
	t11.from = s2
	t11.to = s3
	inheritSystem[t11.from.system, t11.to.system]
}

fact t38_facts {
	t38.from = s7
	t38.to = s4
	inheritSystem[t38.from.system, t38.to.system]
}

fact t12_facts {
	t12.from = s2
	t12.to = s4
	inheritSystem[t12.from.system, t12.to.system]
}

fact t21_facts {
	t21.from = s3
	t21.to = s5
	inheritSystem[t21.from.system, t21.to.system]
}

fact t20_facts {
	t20.from = s3
	t20.to = s4
	inheritSystem[t20.from.system, t20.to.system]
}

fact t43_facts {
	t43.from = s9
	t43.to = s1
	inheritSystem[t43.from.system, t43.to.system]
}

fact t42_facts {
	t42.from = s8
	t42.to = s4
	inheritSystem[t42.from.system, t42.to.system]
}

fact t41_facts {
	t41.from = s8
	t41.to = s2
	inheritSystem[t41.from.system, t41.to.system]
}

fact t40_facts {
	t40.from = s8
	t40.to = s1
	inheritSystem[t40.from.system, t40.to.system]
}

fact t45_facts {
	t45.from = s9
	t45.to = s4
	inheritSystem[t45.from.system, t45.to.system]
}

fact t44_facts {
	t44.from = s9
	t44.to = s2
	inheritSystem[t44.from.system, t44.to.system]
}

fact t46_facts {
	t46.from = s10
	t46.to = s6
	inheritSystem[t46.from.system, t46.to.system]
}

fact t22_facts {
	t22.from = s3
	t22.to = s6
	inheritSystem[t22.from.system, t22.to.system]
}

fact t23_facts {
	t23.from = s3
	t23.to = s7
	inheritSystem[t23.from.system, t23.to.system]
}

fact t24_facts {
	t24.from = s3
	t24.to = s9
	inheritSystem[t24.from.system, t24.to.system]
}

fact t25_facts {
	t25.from = s4
	t25.to = s1
	inheritSystem[t25.from.system, t25.to.system]
}

fact t26_facts {
	t26.from = s5
	t26.to = s1
	inheritSystem[t26.from.system, t26.to.system]
}

fact t27_facts {
	t27.from = s5
	t27.to = s2
	inheritSystem[t27.from.system, t27.to.system]
}

fact t28_facts {
	t28.from = s5
	t28.to = s3
	inheritSystem[t28.from.system, t28.to.system]
}

fact t29_facts {
	t29.from = s5
	t29.to = s4
	inheritSystem[t29.from.system, t29.to.system]
}

fact t3_facts {
	t3.from = s1
	t3.to = s4
	inheritSystem[t3.from.system, t3.to.system]
}

fact t2_facts {
	t2.from = s1
	t2.to = s3
	inheritSystem[t2.from.system, t2.to.system]
}

fact t10_facts {
	t10.from = s2
	t10.to = s1
	inheritSystem[t10.from.system, t10.to.system]
}

fact t1_facts {
	t1.from = s1
	t1.to = s2
	inheritSystem[t1.from.system, t1.to.system]
}

fact t0_facts {
	t0.from = Initial
	t0.to = s6
	initSystem[t0.from.system]
	inheritSystem[t0.from.system, t0.to.system]
}

fact t30_facts {
	t30.from = s5
	t30.to = s6
	inheritSystem[t30.from.system, t30.to.system]
}

fact t7_facts {
	t7.from = s1
	t7.to = s8
	inheritSystem[t7.from.system, t7.to.system]
}

fact t6_facts {
	t6.from = s1
	t6.to = s7
	inheritSystem[t6.from.system, t6.to.system]
}

fact t32_facts {
	t32.from = s6
	t32.to = s1
	inheritSystem[t32.from.system, t32.to.system]
}

fact t5_facts {
	t5.from = s1
	t5.to = s6
	inheritSystem[t5.from.system, t5.to.system]
}

fact t31_facts {
	t31.from = s5
	t31.to = s7
	inheritSystem[t31.from.system, t31.to.system]
}

fact t4_facts {
	t4.from = s1
	t4.to = s5
	inheritSystem[t4.from.system, t4.to.system]
}

fact t9_facts {
	t9.from = s1
	t9.to = End
	inheritSystem[t9.from.system, t9.to.system]
}

fact t8_facts {
	t8.from = s1
	t8.to = s9
	inheritSystem[t8.from.system, t8.to.system]
}

fact {
	// test generation properties
	all p:Path | one c:Coverage | p in c.paths // all path belongs to a coverage
	all s:Step | one p:Path | s in p.firstStep.*nextStep // all step belongs to a path

	// model consistency
	all p:Path | p.firstStep.from = Initial // all path starts with an Initial state
	all p:Path | one s:Step | s in step[p] && s.to = End // all path end with End state

	// state machine properties
	all curr:Step, next:curr.nextStep | next.from = curr.to // all step are contionueos
	all sys:System | some s:State | sys = s.system // all system belongs to a state
}

pred state_coverage {
	all s:State | some p:Path | s in step[p].from + step[p].to
}

run state_coverage for 10 but exactly 1 Coverage, 10 System
