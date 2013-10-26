require 'temppath'

describe Temppath do
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
    new_dir.should.exist
  end

  it 'should update current base directory to specific directory' do
    old_dir = Temppath.basedir
    new_dir = Pathname.new(Dir.mktmpdir("ruby-temppath-test"))
    _new_dir = Temppath.update_basedir(new_dir)
    old_dir.should != _new_dir
    old_dir.should.not.exist
    _new_dir.should.exist
    _new_dir.should == new_dir
  end

  it 'should remove current base directory' do
    dir = Temppath.basedir
    Temppath.remove_basedir
    dir.should.not.exist
  end

  it 'should get basename' do
    Temppath.basename.should == ""
  end

  it 'should set basename' do
    Temppath.basename = "test_"
    Temppath.basename.should == "test_"
    Temppath.create.basename.to_s.should.start_with "test_"
    Temppath.basename = ""
    Temppath.create.basename.to_s.should.not.start_with "test_"
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

describe Temppath::Generator do
  before do
    Temppath.update_basedir
    @dir = Dir.mktmpdir("ruby-temppath-generator-test")
    @generator = Temppath::Generator.new(@dir, basename: "test_")
  end

  it "should generate a path" do
    path = @generator.create
    path.should.kind_of Pathname
    path.dirname.to_s.should == @dir
    path.should.not.exist
  end

  it "should make a directory" do
    path = @generator.mkdir
    path.should.kind_of Pathname
    path.dirname.to_s.should == @dir
    path.should.exist
    path.should.directory
  end

  it "should make a file" do
    path = @generator.touch
    path.should.kind_of Pathname
    path.dirname.to_s.should == @dir
    path.should.exist
    path.should.file
  end

  it "should have own base directory" do
    Temppath.basedir.should != @generator.basedir

    dir = Pathname.new(Dir.mktmpdir("ruby-temppath-generator-test"))
    generator = Temppath::Generator.new(dir)
    generator.basedir.should != @generator.basedir
  end

  it "should make base directory with #create if it doesn't exist" do
    dir = Pathname.new(Dir.mktmpdir("ruby-temppath-generator-test"))
    generator = Temppath::Generator.new(dir + "create")
    generator.basedir.should.not.exist
    generator.create
    generator.basedir.should.exist
  end

  it "should make base directory with #mkdir if it doesn't exist" do
    dir = Pathname.new(Dir.mktmpdir("ruby-temppath-generator-test"))
    generator = Temppath::Generator.new(dir + "mkdir")
    generator.basedir.should.not.exist
    generator.create
    generator.basedir.should.exist
  end

  it "should make base directory with #touch if it doesn't exist" do
    dir = Pathname.new(Dir.mktmpdir("ruby-temppath-generator-test"))
    generator = Temppath::Generator.new(dir + "touch")
    generator.basedir.should.not.exist
    generator.create
    generator.basedir.should.exist
  end

  it "should make base directory and parents" do
    dir = Pathname.new(Dir.mktmpdir("ruby-temppath-generator-test"))
    generator = Temppath::Generator.new(dir + "a" + "b" + "c")
    generator.basedir.should.not.exist
    path = generator.create
    generator.basedir.should.exist
    ("%o" % (dir + "a").stat.mode).should == "40700"
    ("%o" % (dir + "a" + "b").stat.mode).should == "40700"
    ("%o" % (dir + "a" + "b" + "c").stat.mode).should == "40700"
  end

  it "should make path with generator's basename" do
    @generator.create.basename.to_s.should.start_with "test_"
  end
end
