# Push to Pushover from MotionEye (or anywhere else)

Call:
- Call with a file attached (%f is path to file)
  `/path/to/main.py file %H:%I:%S %f`
- Call start event
  `/path/to/main.py start %H:%I:%S`
- Call end event
  `/path/to/main.py end %H:%I:%S`

It will take the name of the system in account.

Configure the `.env` in the root of this folder, see the example
