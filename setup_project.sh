#!/bin/bash

# Automated Project Bootstrapping Script
# Purpose: Set Student Attendance Tracker Project Structure
# Author: Didier Abizera
# Date: February 2026

# Signal handler: Must be first before any other code
cleanup_on_interrupt() {
    echo ""
    echo "The user interrupted this system by pressing (ctrl+c)"

    archive_name="attendance_tracker_${project_name}_archive.tar.gz"

    echo "Creating archive of incomplete setup_project..."

    tar -czf "$archive_name" "$project_dir" 2>/dev/null

    if [ -f "$archive_name" ]; then
        echo "Archive created successfully: $archive_name"
    else
        echo "Creation of archive failed"
    fi

    if [ -d "$project_dir" ]; then
        rm -rf "$project_dir"
        echo "Incomplete directory removed: $project_dir"
    fi

    echo ""
    echo "Exiting script..."
    exit 1
}

trap cleanup_on_interrupt SIGINT






# PART 1: USER INPUT AND DIRECTORY CREATION
echo ""
echo "student attendance tracker - setup"
echo ""

echo "Enter a name of your attendance tracker project: "
read project_name

if [ -z "$project_name" ]; then
        echo "Error: Project name cannot be empty!"
        exit 1
fi

project_dir="attendance_tracker_${project_name}"
echo ""
echo "Creating project: $project_dir"
echo ""

mkdir -p "$project_dir"
mkdir -p "$project_dir/Helpers"
mkdir -p "$project_dir/reports"
echo "Directory structure created successfully"





# CREATE PROJECT FILES
cat > "$project_dir/attendance_checker.py" << 'EOF'
#!/usr/bin/env python3
import csv
import json
import os
from datetime import datetime

def run_attendance_check():
    # 1. Load Config
    with open('Helpers/config.json', 'r') as f:
        config = json.load(f)

    # 2. Archive old reports.log if it exists
    if os.path.exists('reports/reports.log'):
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        os.rename('reports/reports.log', f'reports/reports_{timestamp}.log.archive')

    # 3. Process Data
    with open('Helpers/assets.csv', mode='r') as f, open('reports/reports.log', 'w') as log:
        reader = csv.DictReader(f)
        total_sessions = config['total_sessions']
        log.write(f"--- Attendance Report Run: {datetime.now()} ---\n")

        for row in reader:
            name = row['Names']
            email = row['Email']
            attended = int(row['Attendance Count'])

            # Simple Math: (Attended / Total) * 100
            attendance_pct = (attended / total_sessions) * 100
            message = ""

            if attendance_pct < config['thresholds']['failure']:
                message = f"URGENT: {name}, your attendance is {attendance_pct:.1f}%. You will fail this class."
            elif attendance_pct < config['thresholds']['warning']:
                message = f"WARNING: {name}, your attendance is {attendance_pct:.1f}%. Please be careful."

            if message:
                if config['run_mode'] == "live":
                    log.write(f"[{datetime.now()}] ALERT SENT TO {email}: {message}\n")
                    print(f"Logged alert for {name}")
                else:
                    print(f"[DRY RUN] Email to {email}: {message}")

if __name__ == "__main__":
    run_attendance_check()
EOF
echo "Created attendance_checker.py"






cat > "$project_dir/Helpers/assets.csv" << 'EOF'
Email,Names,Attendance Count,Absence Count
alice@example.com,Alice Johnson,14,1
bob@example.com,Bob Smith,7,8
charlie@example.com,Charlie Davis,4,11
diana@example.com,Diana Prince,15,0
EOF
echo "Created assets.csv"



cat > "$project_dir/Helpers/config.json" << 'EOF'
{
    "thresholds": {
        "warning": 75,
        "failure": 50
    },
    "run_mode": "live",
    "total_sessions": 15
}
EOF
echo "Created config.json"






cat > "$project_dir/reports/reports.log" << 'EOF'
--- Attendance Report Run: 2026-02-06 18:10:01.468726 ---
[2026-02-06 18:10:01.469363] ALERT SENT TO bob@example.com: URGENT: Bob Smith, your attendance is 46.7%. You will fail this class.
[2026-02-06 18:10:01.469424] ALERT SENT TO charlie@example.com: URGENT: Charlie Davis, your attendance is 26.7%. You will fail this class.
EOF
echo "Created reports.log"


# PART 2: DYNAMIC CONFIGURATION WITH SED
echo ""
echo "CONFIGURATION SETUP"
echo ""
echo "Current thresholds:"
echo "  - Warning: 75%"
echo "  - Failure: 50%"
echo ""
echo "Do you want to customize these thresholds? (yes/no)"
read customize_choice

if [ "$customize_choice" = "yes" ] || [ "$customize_choice" = "y" ]; then
    echo ""
    echo "Enter new warning threshold (0-100):"
    read warning_input

    # Validate warning input is numeric
    while ! [[ "$warning_input" =~ ^[0-9]+$ ]] || [ "$warning_input" -lt 0 ] || [ "$warning_input" -gt 100 ]; do
        echo "Error: Please enter a number between 0 and 100"
        read warning_input
    done

    echo ""
    echo "Enter new failure threshold (0-100):"
    read failure_input

    # Validate failure input is numeric
    while ! [[ "$failure_input" =~ ^[0-9]+$ ]] || [ "$failure_input" -lt 0 ] || [ "$failure_input" -gt 100 ]; do
        echo "Error: Please enter a number between 0 and 100"
        read failure_input
    done

    echo ""
    echo "Updating configuration file..."

    # Use sed to update config.json
    sed -i "s/\"warning\": 75/\"warning\": $warning_input/" "$project_dir/Helpers/config.json"
    sed -i "s/\"failure\": 50/\"failure\": $failure_input/" "$project_dir/Helpers/config.json"

    echo "Configuration updated successfully!"
    echo "  Warning threshold: $warning_input%"
    echo "  Failure threshold: $failure_input%"
    else
    echo "Using default configuration"
fi





# PART 4: HEALTH CHECK
echo ""
echo "Running health check....."
echo ""

if command -v python3 &> /dev/null; then
    python_version=$(python3 --version)
    echo "Python3 is installed: $python_version"

    else
    echo "Notice: Python3 is NOT installed on this system"
fi
echo ""
echo "Verifying directory structure..."
if [ -d "$project_dir" ] && [ -d "$project_dir/Helpers" ] && [ -d "$project_dir/reports" ]; then
    echo "All directories created successfully"

    else
    echo "ERROR: Directory structure is incomplete!"
fi

echo ""
echo "Verifying project files..."
if [ -f "$project_dir/attendance_checker.py" ] && [ -f "$project_dir/Helpers/assets.csv" ] && [ -f "$project_dir/Helpers/config.json" ] && [ -f "$project_dir/reports/reports.log" ]; then
    echo "All required files created successfully"
    else
    echo "Error: Some files are missing!"
fi

echo ""
echo "Setup Completed Successfully"
echo ""
