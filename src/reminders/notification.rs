use chrono::Local;
use notify_rust::{Notification, Timeout};

use crate::calendar::CalendarEvent;
use crate::error::{ArgvusError, Result};

pub fn notify_event(event: &CalendarEvent, minutes_before: i64) -> Result<()> {
    let start = event.start.with_timezone(&Local);
    let body = if event.all_day && minutes_before < 0 {
        "All-day event reminder".to_string()
    } else if minutes_before < 0 {
        format!("Event in progress\nStarted at {}", start.format("%H:%M"))
    } else if minutes_before == 0 {
        format!("Starts now\n{}", start.format("%H:%M"))
    } else {
        format!(
            "Starts in {minutes_before} minutes\n{}",
            start.format("%H:%M")
        )
    };
    Notification::new()
        .appname("Argvus Calendar")
        .summary(&event.title)
        .body(&body)
        .icon("x-office-calendar")
        .timeout(Timeout::Milliseconds(8000))
        .show()
        .map_err(|err| ArgvusError::Notification(err.to_string()))?;
    Ok(())
}
