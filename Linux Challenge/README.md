# Instructions for the Linux Challenge: 
---
## First Part
1. Create a User:
  Create a new user named devuser.
  Assign a secure password to devuser.
2. Developers Group:
  Create a group named developers.
  Add devuser to the developers group.
3. Project Directory:
  Create a directory named /opt/devproject.
  Change the ownership of the directory to devuser and the developers group.
  Assign read, write, and execute permissions to the owner and the group, but only read and execute permissions for other users.
---
## Second Part - Creating a System Maintenance Script

1. Create a Bash script named system_maintenance.sh (you can create it wherever you prefer) that performs the following tasks:
- System Update:
    Update system packages.
- Package Cleanup:
    Remove unnecessary packages and clean the cache.
- Disk Status Check:
    Display disk usage.
- Active Users Check:
    List currently connected users.
- CPU Processes Check:
    Display the top 5 processes consuming the most CPU.
---

# Delivery

On this project you could find 3 files, maintenance_output.txt, system_maintenance.sh, user_folder_creation.txt.

## user_folder_creation.txt

Here you will find the output of the command "ls -l", to verify the actual owner and group of the folder created on the path /opt/ named "devproject"

## maintenance_output.txt

Here you will find the output of the script executed on my ubuntu machine.

## system_maintenance.sh

### Lines 2 - 5

Conditional created to ensure that the user executing the file is root, otherwise the necessary command execution will fail.

### Lines 6 - 9 

Make use of the apt-get update, to ensure that all the system packages get updated

### Lines 10 - 14

Make use of the apt autoremove function, so the system can find those packages that are no longer necessary.

### Lines 17 to 28

This code make sure to free the memory and cached from RAM, by the use of 'awk' to get the amount of free memory (MemFree) and cached memory (Cached) from /proc/meminfo and converts it from kilobytes to megabytes.

Then a conditional was used to verify if sync fails, prints an error message saying "Something went wrong, unable to sync filesystem" and exits the script.

If sync succeeds, it writes 3 to /proc/sys/vm/drop_caches to free up cache memory.

Gets the new amount of free memory after freeing cache, converts it from kilobytes to megabytes. Calculate the delta between free memory before and after operation, and finally printing the result of the current free memory. 

This part of code was coded based on existing github repository: https://gist.github.com/pklaus/837023

### Lines 30 - 32

Shows the actual space of the disks

### Lines 33 to 35

Shows the actual users configured on the system, and using awk to filter and print only the usernames

### Lines 36 to 38

Make use of ps and sort by CPU, to get the first 5 processes generating more CPU consumption

# Notes: 
All of these tests were performed on the following operating system:
```
Distributor ID:	Ubuntu
Description:	Ubuntu 20.04.6 LTS
Release:	20.04
Codename:	focal
```
