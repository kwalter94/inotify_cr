require "./lib_inotify"

require "errno"
require "path"

class InotifyCr::DirWatcher
  FILENAME_MAX_LENGTH = 255

  def initialize(dir_path : String)
    raise "Path is not directory" unless File.directory?(dir_path)

    @file_descriptor = LibInotify.init
    raise "Could not initialise inotify" if @file_descriptor.negative?

    @watch_descriptor = LibInotify.add_watch(@file_descriptor, dir_path, LibInotify::IN_CREATE | LibInotify::IN_DELETE)
    raise "Could not initialise inotify watcher" if @watch_descriptor.negative?
  end

  def watch
    loop do
      event_p = Pointer
                  .malloc(sizeof(LibInotify::Event) + FILENAME_MAX_LENGTH + 1, UInt8)
                  .as(Pointer(LibInotify::Event))
      status = LibInotify.read(@file_descriptor, event_p, sizeof(LibInotify::Event) + FILENAME_MAX_LENGTH + 1)
      raise "Failed to read inotify event: errno(#{Errno.value})" if status.negative?

      event_type = parse_event_type(event_p.value.mask)
      filename = LibInotifyHelpers.extract_name(event_p)

      yield event_type, String.new(filename)
    end
  end

  def close
    LibInotify.rm_watch(@file_descriptor, @watch_descriptor)
  end

  private def parse_event_type(event_mask : UInt32) : String
    [{LibInotify::IN_CREATE, "Created"}, {LibInotify::IN_DELETE, "Deleted"}].each do |flag, event|
      return event if flag & event_mask == flag
    end

    "unknown_event"
  end
end
