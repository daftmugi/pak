#!/usr/bin/env -S ruby -w

load File.expand_path("../../bin/pak", __FILE__)
TEST_PATH = File.expand_path("..", __FILE__)
Dir.chdir(TEST_PATH)

require "minitest/autorun"

class PAKTest < Minitest::Test
  def test_no_pak_file
    pak = PAK.new
    error = assert_raises(RuntimeError) { pak.list_pak() }
    assert_equal("No PAK file given", error.message)
  end

  def test_null_terminated_string
    # Make sure that the special case found in pak0.pak is handled correctly.
    # All path strings are padded with zeros, except one.
    # The string "progs.dat\0" is padded with seemingly random bytes.
    pak = PAK.new(pak_path: "test_data/pak0_progsdat.pak")

    expected = <<~EOS
    progs.dat
    EOS

    assert_output(expected, "") { pak.list_pak() }
  end

  def test_list_very_verbose
    pak = PAK.new(pak_path: "test_data/testpak.pak", very_verbose: true)

    expected = <<~EOS
    Archive: test_data/testpak.pak
       Size       Offset    Path
    ----------  ----------  -----------------------------------
             0          12  emptyfile
             2          12  testdir/a.txt
             2          14  testdir/b.txt
             2          16  testdir/c.txt
            10          18  testfile
    ----------              -----------------------------------
            16              5 files
    EOS

    assert_output(expected, "") { pak.list_pak() }
  end

  def test_extract
    pak = PAK.new(pak_path: "test_data/testpak.pak", root_path: "test_data/outdir", noop: true)

    expected = <<-EOS
   extract    emptyfile
   extract    testdir/a.txt
   extract    testdir/b.txt
   extract    testdir/c.txt
   extract    testfile
    EOS

    assert_output(expected, "") { pak.extract_pak() }
  end

  def test_pipe_extract_single_file
    pak = PAK.new(pak_path: "test_data/testpak.pak", regex: /testfile/)

    expected = <<~EOS
    test file
    EOS

    assert_output(expected, "") { pak.pipe_extract_pak() }
  end

  def test_pipe_extract_multiple_files
    pak = PAK.new(pak_path: "test_data/testpak.pak", regex: /\.txt$/)

    expected = <<~EOS
    a
    b
    c
    EOS

    assert_output(expected, "") { pak.pipe_extract_pak() }
  end

  def test_create_very_verbose
    root_path = "test_data/pak"
    empty_dir = File.join(root_path, "emptydir")
    Dir.mkdir(empty_dir) unless File.exist?(empty_dir)

    pak = PAK.new(pak_path: "testout.pak", root_path: root_path, noop: true, very_verbose: true)

    expected = <<~EOS
     Action      Size       Offset    Path
    --------  ----------  ----------  -----------------------------------
    archive            0          12  emptyfile
    archive            2          12  testdir/a.txt
    archive            2          14  testdir/b.txt
    archive            2          16  testdir/c.txt
    archive           10          18  testfile
    --------  ----------  ----------  -----------------------------------
                      16              5 files
    EOS

    assert_output(expected, "") { pak.create_pak() }
  end

  def test_file_directory_mismatch_on_disk
    pak = PAK.new(pak_path: "test_data/test_conflicts.pak", root_path: "test_data/conflicts", noop: true)

    expected = <<-EOS
     error    test_data/conflicts/testdir exists but is not a directory
              -> skipping testdir/a.txt
     error    test_data/conflicts/testdir exists but is not a directory
              -> skipping testdir/b.txt
     error    test_data/conflicts/testdir exists but is not a directory
              -> skipping testdir/c.txt
     error    test_data/conflicts/testfile/ exists but is not a file
              -> skipping testfile
    EOS

    assert_output(expected, "") { pak.extract_pak() }
  end

  def test_max_path_length
    pak = PAK.new(pak_path: "testout.pak", root_path: "test_data/max_path_length", noop: true)

    error = assert_raises(RuntimeError) { pak.create_pak() }
    assert_equal(
      "Path more than 55 characters: a_very_long_filename_that_is_not_compatible_with_pak.txt",
      error.message
    )
  end

  def test_max_path_length_2
    pak = PAK.new(pak_path: "testout.pak", root_path: "test_data/max_path_length_2", noop: true)

    error = assert_raises(RuntimeError) { pak.create_pak() }
    assert_equal(
      "Path more than 55 characters: a_long_dirname_to_test/a_long_filename_not_compatible.txt",
      error.message
    )
  end

  def test_find_duplicates
    pak = PAK.new

    expected = <<~EOS
    maps/c.bsp: pak3.pak, pak2.pak
    maps/b.bsp: pak2.pak, pak1.pak
    maps/a.bsp: pak1.pak, pak0.pak
    EOS

    Dir.chdir("test_data/dups") do
      assert_output(expected, "") { pak.find_duplicates() }
    end
  end

  def test_find_duplicates_given_exclude
    pak = PAK.new(exclude_paks: ["pak1.pak", "pak2.pak"])

    expected = <<~EOS
    maps/c.bsp: pak3.pak, pak2.pak
    maps/a.bsp: pak1.pak, pak0.pak
    EOS

    Dir.chdir("test_data/dups") do
      assert_output(expected, "") { pak.find_duplicates() }
    end
  end
end
