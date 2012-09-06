#!/usr/bin/env ruby

App = Struct.new(:pid, :ppid, :command)

# list all processes with pid, parent pid, and command, sorted by memory usage
apps = `ps -em -o pid,ppid,comm`.lines.to_a.map do |line|
  line.chomp =~ /^\s*(\d+)\s+(\d+)\s+(\/.+)$/
  pid, ppid, command = $1, $2, $3
  App.new(pid, ppid, command)
end

finder = apps.find { |app| app.command == "/System/Library/CoreServices/Finder.app/Contents/MacOS/Finder" }
launchd_pid = finder.ppid

apps_to_close = apps.select { |app| app.ppid == launchd_pid && app.command =~ /^\/Applications\// && app.command !~ /Terminal/}

apps_to_close.each { |app| Process.kill("HUP", app.pid.to_i) }
