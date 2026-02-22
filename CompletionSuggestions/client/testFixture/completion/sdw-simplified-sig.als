open util/ordering[StateVector]

abstract sig Value_S_flying {}
one sig flying_S_flying, on_the_ground_S_flying extends Value_S_flying {}

abstract sig Value_S_pylon_inspection {}
one sig complete_S_pylon_inspection, not_complete_S_pylon_inspection extends Value_S_pylon_inspection {}

abstract sig Value_S_at_landing_position {}
one sig yes_S_at_landing_position, no_S_at_landing_position extends Value_S_at_landing_position {}

abstract sig Value_S_communication {}
one sig stable_S_communication, lost_S_communication extends Value_S_communication {}

abstract sig Value_S_battery {}
one sig ok_S_battery, critical_S_battery extends Value_S_battery {}

abstract sig Value_S_critical_battery_notification {}
one sig not_yet_notified_S_critical_battery_notification, notified_S_critical_battery_notification extends Value_S_critical_battery_notification {}

abstract sig Action {}
one sig take_off, land, go_to_landing_zone, execute_mission_task, notify_critical_battery, reset_critical_battery_notification_status extends Action {}

sig StateVector {
    S_flying: Value_S_flying,
    S_pylon_inspection: Value_S_pylon_inspection,
    S_at_landing_position: Value_S_at_landing_position,
    S_communication: Value_S_communication,
    S_battery: Value_S_battery,
    S_critical_battery_notification: Value_S_critical_battery_notification,
    Executing: set Action
}

one sig Constants {
    StartLoop: StateVector
}