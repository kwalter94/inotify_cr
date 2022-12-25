# TODO: Write documentation for `InotifyCr`
require "./dir_watcher"

module InotifyCr
  VERSION = "0.1.0"

  if ARGV.size != 1
    print("Error: Invalid number of arguments")
    print("USAGE: #{ARGV[0]} <path-to-dir>")
    exit(255)
  end

  watcher = DirWatcher.new(ARGV[0])
  watcher.watch do |event, path|
    puts("#{event.upcase}: #{path}")
  end
end
