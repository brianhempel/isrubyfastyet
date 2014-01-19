#!/usr/bin/env ruby

App = Struct.new(:pid, :parent_pid, :command)

# list all processes with pid, parent pid, and command, sorted by memory usage
apps = `ps -em -o pid,ppid,comm`.lines.to_a.map do |line|
  line.chomp =~ /^\s*(\d+)\s+(\d+)\s+(\/.+)$/
  pid, parent_pid, command = $1, $2, $3
  App.new(pid, parent_pid, command)
end

finder = apps.find { |app| app.command == "/System/Library/CoreServices/Finder.app/Contents/MacOS/Finder" }
launchd_pid = finder.parent_pid

apps_to_close = apps.select { |app| app.parent_pid == launchd_pid && app.command =~ /\.app\b/ && app.command !~ /Terminal|^\/System/}

apps_to_close.each { |app| Process.kill("HUP", app.pid.to_i) }
