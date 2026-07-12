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

// <Light>
pred pre_light_off_light_on[s: State] {
  s.light = false
  s.pressed[b] = true
}
pred post_light_off_light_on[s, ss: State] {
  ss.light = true
  ss.display = s.display
  ss.pressed = s.pressed
  ss.waited_2_min = s.waited_2_min
  ss.waited_2_sec = s.waited_2_sec
}
pred light_off_light_on[s, ss: State] {
  pre_light_off_light_on[s]
  post_light_off_light_on[s, ss]
}

pred pre_light_on_light_off[s: State] {
  s.light = true
  s.pressed[b] = false
}
pred post_light_on_light_off[s, ss: State] {
  ss.light = false
  ss.display = s.display
  ss.pressed = s.pressed
  ss.waited_2_min = s.waited_2_min
  ss.waited_2_sec = s.waited_2_sec
}
pred light_on_light_off[s, ss: State] {
  pre_light_on_light_off[s]
  post_light_on_light_off[s, ss]
}
// </Light>

// <Time>
pred pre_time_show_date[s: State] {
  s.display = Time
  s.pressed[d] = true
}
pred post_time_show_date[s, ss: State] {
  ss.display = Date
  ss.light = s.light
  ss.pressed = s.pressed
  ss.waited_2_min = s.waited_2_min
  ss.waited_2_sec = s.waited_2_sec
}
pred time_show_date[s, ss: State] {
  pre_time_show_date[s]
  post_time_show_date[s, ss]
}

pred pre_time_try_update[s: State] {
  s.display = Time
  s.pressed[c] = true
}
pred post_time_try_update[s, ss: State] {
  ss.display = Wait
  ss.light = s.light
  ss.pressed = s.pressed
  ss.waited_2_min = s.waited_2_min
  ss.waited_2_sec = s.waited_2_sec
}
pred time_try_update[s, ss: State] {
  pre_time_try_update[s]
  post_time_try_update[s, ss]
}

pred pre_time_go2alarm1[s: State] {
  s.display = Time
  s.pressed[a] = true
}
pred post_time_go2alarm1[s, ss: State] {
  ss.display = Alarm1
  ss.light = s.light
  ss.pressed = s.pressed
  ss.waited_2_min = s.waited_2_min
  ss.waited_2_sec = s.waited_2_sec
}
pred time_go2alarm1[s, ss: State] {
  pre_time_go2alarm1[s]
  post_time_go2alarm1[s, ss]
}
// </Time>

// <Date>
pred pre_date_show_time[s: State] {
  s.display = Date
  s.pressed[d] = true
}
pred post_date_show_time[s, ss: State] {
  ss.display = Time
  ss.light = s.light
  ss.pressed = s.pressed
  ss.waited_2_min = s.waited_2_min
  ss.waited_2_sec = s.waited_2_sec
}
pred date_show_time[s, ss: State] {
  pre_date_show_time[s]
  post_date_show_time[s, ss]
}

pred pre_date_return_to_time[s: State] {
  s.display = Date
  s.waited_2_min = true
}
pred post_date_return_to_time[s, ss: State] {
  ss.display = Time
  ss.light = s.light
  ss.pressed = s.pressed
  ss.waited_2_min = s.waited_2_min
  ss.waited_2_sec = s.waited_2_sec
}
pred date_return_to_time[s, ss: State] {
  pre_date_return_to_time[s]
  post_date_return_to_time[s, ss]
}
// </Date>

// <Wait>
pred pre_wait_show_time[s: State] {
  s.display = Wait
  s.pressed[c] = false
}
pred post_wait_show_time[s, ss: State] {
  ss.display = Time
  ss.light = s.light
  ss.pressed = s.pressed
  ss.waited_2_min = s.waited_2_min
  ss.waited_2_sec = s.waited_2_sec
}
pred wait_show_time[s, ss: State] {
  pre_wait_show_time[s]
  post_wait_show_time[s, ss]
}

pred pre_wait_show_update[s: State] {
  s.display = Wait
  s.waited_2_sec = true
}
pred post_wait_show_update[s, ss: State] {
  ss.display = Update
  ss.light = s.light
  ss.pressed = s.pressed
  ss.waited_2_min = s.waited_2_min
  ss.waited_2_sec = s.waited_2_sec
}
pred wait_show_update[s, ss: State] {
  pre_wait_show_update[s]
  post_wait_show_update[s, ss]
}
// </Wait>

// <Update>
pred pre_update_show_time[s: State] {
  s.display = Update
  s.pressed[b] = true
}
pred post_update_show_time[s, ss: State] {
  ss.display = Time
  ss.light = s.light
  ss.pressed = s.pressed
  ss.waited_2_min = s.waited_2_min
  ss.waited_2_sec = s.waited_2_sec
}
pred update_show_time[s, ss: State] {
  pre_update_show_time[s]
  post_update_show_time[s, ss]
}
// </Update>

// <Alarm1>
pred pre_alarm1_go2alarm2[s: State] {
  s.display = Alarm1
  s.pressed[a] = true
}
pred post_alarm1_go2alarm2[s, ss: State] {
  ss.display = Alarm2
  ss.light = s.light
  ss.pressed = s.pressed
  ss.waited_2_min = s.waited_2_min
  ss.waited_2_sec = s.waited_2_sec
}
pred alarm1_go2alarm2[s, ss: State] {
  pre_alarm1_go2alarm2[s]
  post_alarm1_go2alarm2[s, ss]
}
// </Alarm1>

// <Alarm2>
pred pre_alarm2_go2chime[s: State] {
  s.display = Alarm2
  s.pressed[a] = true
}
pred post_alarm2_go2chime[s, ss: State] {
  ss.display = Chime
  ss.light = s.light
  ss.pressed = s.pressed
  ss.waited_2_min = s.waited_2_min
  ss.waited_2_sec = s.waited_2_sec
}
pred alarm2_go2chime[s, ss: State] {
  pre_alarm2_go2chime[s]
  post_alarm2_go2chime[s, ss]
}
// </Alarm2>

// <Chime>
pred pre_chime_go2Stopwatch[s: State] {
  s.display = Chime
  s.pressed[a] = true
}
pred post_chime_go2Stopwatch[s, ss: State] {
  ss.display = StopWatch
  ss.light = s.light
  ss.pressed = s.pressed
  ss.waited_2_min = s.waited_2_min
  ss.waited_2_sec = s.waited_2_sec
}
pred chime_go2Stopwatch[s, ss: State] {
  pre_chime_go2Stopwatch[s]
  post_chime_go2Stopwatch[s, ss]
}
// </Chime>

// <StopWatch>
pred pre_Stopwatch_go2time[s: State] {
  s.display = StopWatch
  s.pressed[a] = true
}
pred post_Stopwatch_go2time[s, ss: State] {
  ss.display = Time
  ss.light = s.light
  ss.pressed = s.pressed
  ss.waited_2_min = s.waited_2_min
  ss.waited_2_sec = s.waited_2_sec
}
pred Stopwatch_go2time[s, ss: State] {
  pre_Stopwatch_go2time[s]
  post_Stopwatch_go2time[s, ss]
}
// </StopWatch>

// <Alarms_Beep>
// </Alarms_Beep>


pred init[s: State] {
  s.light = false
  s.display = Time
  all k: Key | s.pressed[k] = false
  s.waited_2_min = false
  s.waited_2_sec = false
}

pred next[s, ss: State] {
     light_off_light_on[s, ss]
  or light_on_light_off[s, ss]
  or time_show_date[s, ss]
  or time_try_update[s, ss]
  or time_go2alarm1[s, ss]
  or date_show_time[s, ss]
  or date_return_to_time[s, ss]
  or wait_show_time[s, ss]
  or wait_show_update[s, ss]
  or update_show_time[s, ss]
  or alarm1_go2alarm2[s, ss]
  or alarm2_go2chime[s, ss]
  or chime_go2Stopwatch[s, ss]
  or Stopwatch_go2time[s, ss]
}


fact traces {
  init[StateOrdering/first]
  all s: State-StateOrdering/last |
    let ss = s.StateOrdering/next |
      next[s, ss]
}


check eventually_time {
  all s: State-StateOrdering/last |
      s.pressed[a] = true implies some ss: s.*StateOrdering/next |
        ss.display = Time
} for 10
