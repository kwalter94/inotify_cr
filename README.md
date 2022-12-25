# inotify_cr

Tracks file creations and deletions in a directory. This project was meant
to help me learn a bit about creating C library bindings. Don't take it
too seriously. If you need a properly built tool with similar functionality
then please look at
[inotify-tools](https://github.com/inotify-tools/inotify-tools).

## Building

Building this requires Crystal 1.6.1 or better and `Linux` with
GNU libc

```sh
crystal build src/watch.cr
```

## Usage

```sh
./watch path-to-directory
```

Once you start the application, it will log lines as below for
every file create and delete. This will only work on file systems
that `inotify` supports.

    DELETED: file1
    DELETED: file2
    DELETED: file3
    DELETED: file5
    CREATED: file1

## Contributing

1. Fork it (<https://github.com/kwalter94/inotify_cr/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Walter Kaunda](https://github.com/kwalter94) - creator and maintainer
