Benchmark Runner
================

You need RVM installed.

To all the benchmarks on all implementations:

```
rake
```

The runner needs to start on a ruby that supports fork (e.g. not JRuby).  Output is automatically prettier if you install the Artii gem (the gem currently only works on 1.8.7...for this reason, starting the suite on 1.8.7 is recommended).

If smcFanControl is installed, the script will spin up the fans to keep the computer as cool as possible.  The script looks for the smc utility in `/Applications/smcFanControl.app/Contents/Resources/smc`.