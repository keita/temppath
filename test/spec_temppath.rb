require 'temppath'

describe 'Temppath' do
  it 'should get temporary path' do
    Temppath.create.should.kind_of Pathname
    Temppath.create.should != Temppath.create
  end

  it 'should get temporary path with basename' do
    Temppath.create("A_").basename.to_s[0,2].should == "A_"
  end

  it 'should get temporary path with tmpdir' do
    dir = Dir.tmpdir
    Temppath.create(nil, dir).dirname.should == Pathname.new(dir)
  end

  it 'should be in the temporary directory' do
    Temppath.create.dirname.should == Temppath.dir
  end

  it 'should get unlink mode' do
    Temppath.unlink.should == true
  end

  it 'should set unlink mode' do
    Temppath.unlink = false
    Temppath.unlink.should == false
    Temppath.unlink = true
  end
end
