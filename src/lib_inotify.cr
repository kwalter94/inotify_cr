lib LibInotify
  # Notify init flags
  IN_CLOEXEC = 0o2000000
  IN_NONBLOCK = 0o0004000

  # Notify event watch flags
  IN_CREATE = 0x00000100
  IN_DELETE = 0x00000200

  struct Inotify_Event
    wd : LibC::Int
    mask : UInt32
    cookie : UInt32
    len : UInt32
    name : LibC::Char
    # NOTE: name is defined as a C99 flex array member (ie. char name[]).
    # Crystal doesn't seem to natively support binding to these kinds of fields
    # as of version 1.6.1. In order to access this field, we have to get the
    # address of this field at runtime and initialise a pointer from it.
    # See: method LibInotifyHelpers#extract_name.
  end

  type Event = Inotify_Event

  fun init = inotify_init : LibC::Int

  fun init1 = inotify_init1(flags : LibC::Int) : LibC::Int

  fun add_watch = inotify_add_watch(fd : LibC::Int, pathname : Pointer(LibC::Char), mask : UInt32) : LibC::Int

  fun rm_watch = inotify_rm_watch(fd : LibC::Int, wd : LibC::Int) : LibC::Int

  fun read(fd : LibC::Int, buf : Pointer(Void), count : LibC::SizeT) : LibC::SSizeT # return type should be ssize_t
end

module LibInotifyHelpers
  def self.extract_name(event_p : Pointer(LibInotify::Event)) : Pointer(LibC::Char)
    offset = offsetof(LibInotify::Inotify_Event, @name)
    address = event_p.address + offset

    Pointer(LibC::Char).new(address)
  end
end
