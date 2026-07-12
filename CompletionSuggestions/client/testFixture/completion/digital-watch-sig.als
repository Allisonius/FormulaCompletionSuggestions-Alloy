// NANCY

open util/ordering [State] as StateOrdering

abstract sig Key, Display, Bool {}
one sig a, b, c, d extends Key {}
one sig Time, Date, Wait, Update,
        Alarm1, Alarm2, Chime, StopWatch
        extends Display {}
one sig false, true extends Bool {}

sig State {
  light: Bool,
  display: Display,
  pressed: Key one -> one Bool,
  waited_2_min: Bool,
  waited_2_sec: Bool
}
