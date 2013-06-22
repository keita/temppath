require 'temppath'

describe 'Temppath' do
  before do
    Temppath.update_basedir
  end

  it 'should get temporary path' do
    Temppath.create.should.kind_of Pathname
    Temppath.create.should != Temppath.create
  end

  it 'should get temporary path with basename' do
    Temppath.create(basename: "A_").basename.to_s[0,2].should == "A_"
  end

  it 'should get base directory path with basedir' do
    dir = Dir.mktmpdir
    Temppath.create(basedir: dir).dirname.should == Pathname.new(dir)
  end

  it 'should be in the base directory' do
    Temppath.create.dirname.should == Temppath.basedir
  end

  it 'should update current base directory' do
    old_dir = Temppath.basedir
    new_dir = Temppath.update_basedir
    old_dir.should != new_dir
    old_dir.should.not.exist
  end

  it 'should remove current base directory' do
    dir = Temppath.basedir
    Temppath.remove_basedir
    dir.should.not.exist
  end

  it 'should get unlink mode' do
    Temppath.unlink.should == true
  end

  it 'should set unlink mode' do
    Temppath.unlink = false
    Temppath.unlink.should == false
    Temppath.unlink = true
  end

  it 'should create a file with permission 0600 by default' do
    path = Temppath.create
    path.open("w")
    ("%o" % path.stat.mode).should == "100600"
  end

  it 'should create a file with permission 0644 explicitly' do
    path = Temppath.create
    path.open("w", 0644)
    ("%o" % path.stat.mode).should == "100644"
  end

  it 'should create a directory with permission 0700 by default' do
    path = Temppath.create
    path.mkdir
    ("%o" % path.stat.mode).should == "40700"
  end

  it 'should create a directory with permission 0755 explicitly' do
    path = Temppath.create
    path.mkdir(0755)
    ("%o" % path.stat.mode).should == "40755"
  end

  it 'should do mkpath with permission 0700 by default' do
    path = Temppath.create
    path.mkpath
    ("%o" % path.stat.mode).should == "40700"
  end

  it 'should do mkpath with permission 0755 explicitly' do
    path = Temppath.create
    path.mkpath(mode: 0755)
    ("%o" % path.stat.mode).should == "40755"
  end

  it 'should do sysopen with permission 0600 by default' do
    path = Temppath.create
    path.sysopen("w")
    ("%o" % path.stat.mode).should == "100600"
  end

  it 'should do sysopen with permission 0644 explicitly' do
    path = Temppath.create
    path.sysopen("w", 0644)
    ("%o" % path.stat.mode).should == "100644"
  end

  it 'should make a directory' do
    path = Temppath.mkdir
    path.should.directory
    ("%o" % path.stat.mode).should == "40700"
  end

  it 'should touch a file' do
    path = Temppath.touch
    path.should.file
    ("%o" % path.stat.mode).should == "100600"
  end
end
