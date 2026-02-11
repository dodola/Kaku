#![cfg(target_os = "linux")]
use crate::ToastNotification;

pub fn show_notif(toast: ToastNotification) -> Result<(), Box<dyn std::error::Error>> {
    let mut cmd = std::process::Command::new("notify-send");

    cmd.arg(&toast.title).arg(&toast.message);

    if let Some(timeout) = &toast.timeout {
        cmd.arg("-t")
            .arg(format!("{}", timeout.as_millis()));
    }

    match cmd.spawn() {
        Ok(mut child) => {
            std::thread::spawn(move || {
                let _ = child.wait();
            });
        }
        Err(err) => {
            log::error!("Failed to exec notify-send: {}", err);
        }
    }

    if let Some(url) = &toast.url {
        log::info!("Notification URL (click not supported on Linux): {}", url);
    }

    Ok(())
}
