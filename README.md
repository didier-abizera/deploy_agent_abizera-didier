#Automated Project Bootstrapping Script

 
Course = Introduction to Linux and IT Tools  
Project = Student Attendance Tracker Setup Automation  
Date = February 2026


Project Overview

This shell script automates the complete setup of a Student Attendance Tracker application. It demonstrates Infrastructure as Code (IaC) principles by creating a reproducible, efficient deployment system.


Features

Automated Directory Structure** - Creates project folders automatically
File Generation** - Generates Python application with complete source code
Dynamic Configuration** - Allows customization of attendance thresholds
Input Validation** - Ensures numeric input (0-100) before using sed
Signal Handling** - Catches Ctrl+C and creates archive of incomplete work
Health Check** - Verifies Python3 installation and project structure


##How to Run

#Make the script executable

chmod +x setup_project.sh


#Step 2: Run the script

./setup_project.sh

tep 3: Follow the prompts
1. Enter a project name (e.g., `my_project`)
2. Choose whether to customize thresholds (yes/no)
3. If yes, enter warning and failure thresholds (0-100)


Project Structure Created

attendance_tracker_{your_name}/
├── attendance_checker.py       # Main Python application
├── Helpers/
│   ├── assets.csv             # Student attendance data
│   └── config.json            # Configuration settings
└── reports/
    └── reports.log            # Attendance reports

#Testing the Archive Feature (Ctrl+C)

The script includes a trap handler that catches Ctrl+C interruptions.

#To test:

1. Run the script:

   ./setup_project.sh

2. Enter a project name (e.g., `test_interrupt`)

3. **Press Ctrl+C** at any point during setup

4. The script will:
   - Create an archive: `attendance_tracker_test_interrupt_archive.tar.gz`
   - Delete the incomplete directory
   - Exit cleanly

5. Verify the archive was created:

   ls -lh *archive.tar.gz

6. Extract the archive to see contents:

   tar -xzf attendance_tracker_test_interrupt_archive.tar.gz
   ls -la attendance_tracker_test_interrupt/
⚙️ Configuration

Default thresholds:
- **Warning:** 75% (students below this get a warning)
- **Failure:** 50% (students below this fail)

These can be customized during setup or manually edited in:
attendance_tracker_{name}/Helpers/config.json

---

## Running the Python Application

After setup completes:
```bash
cd attendance_tracker_{your_project_name}
python3 attendance_checker.py
```

The application will:
1. Read student data from `Helpers/assets.csv`
2. Check attendance against thresholds in `Helpers/config.json`
3. Generate report in `reports/reports.log`

### Example Output:
```
Logged alert for Bob Smith
Logged alert for Charlie Davis
```

This means alerts were generated for students below the failure threshold.



Requirements

- **Bash** shell (Linux/Unix/macOS)
- **Python 3** (for running the attendance tracker)
- Standard Unix tools: `sed`, `tar`, `mkdir`

#Technical Details

Technologies Used:
- **Bash scripting** - Automation logic
- **sed** - Stream editing for configuration
- **tar** - Archive creation
- **Python 3** - Attendance tracking application

##Key Concepts Demonstrated:
- 
Signal handling with `trap`
- Input validation with regex
- Heredoc for file creation
- Conditional logic and error handling
\

What This Project Does

1. **Catches Interruptions** - Trap handler saves work if user presses Ctrl+C
2. **Validates Input** - Ensures thresholds are numbers between 0-100
3. **Uses sed** - Updates JSON configuration file dynamically
4. **Health Check** - Verifies Python3 and validates file structure
5. **Error Handling** - Provides clear feedback for all edge cases

---

- The script validates that Python3 is installed but does not require it for setup
- Archives are created only when setup is interrupted (Ctrl+C)
- All input is validated before being used
- The script handles edge cases like empty input and invalid thresholds
- Running Python app multiple times archives previous reports automatically


