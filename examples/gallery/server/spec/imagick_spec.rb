require File.expand_path('../spec_helper', __FILE__)
describe IMagick do
  
  context "shell_exec" do
    
    it 'should return true on successfull execs' do
      IMagick.shell_exec("ls -lA").should be_true
    end
    
    it 'should raise an error otherwise' do
      lambda{ 
        IMagick.shell_exec("sometHingThatProbably_Shoul_nOTExists") 
      }.should raise_error(IMagick::Error)
    end
    
  end # shell_exec
  
  context "command_str_for" do
    
    it 'should support simple commands' do
      IMagick.command_str_for("convert").should == "convert"
    end
    
    it 'should support options' do
      IMagick.command_str_for("convert", {:thumbnail => "300x300"}).should == "convert -thumbnail 300x300"
    end
    
    it 'should support args' do
      IMagick.command_str_for("convert", ["hello", "12"]).should == "convert hello 12"
    end
    
    it 'should support both args' do
      IMagick.command_str_for("convert", {:thumbnail => "300x300"}, ["hello", "12"]).should == "convert -thumbnail 300x300 hello 12"
    end
    
  end # command_str_for
  
  context 'command_for' do

    it 'should work on create_thumbnail without args' do
      c = IMagick.command_for(:create_thumbnail)
      c.should =~ /^convert /
      c.should =~ /-thumbnail /
      c.should =~ /130x130/
    end

    it 'should work on create_thumbnail with args' do
      c = IMagick.command_for(:create_thumbnail, "file1", "file2")
      c.should =~ /file1 file2$/
    end
    
  end # command_for
  
  context "create_thumnail" do
    let(:source){ File.expand_path('../fixtures/Cars/Morgan.jpg', __FILE__) }
    let(:target){ File.expand_path('../fixtures/Cars/thumbs/Morgan.jpg', __FILE__) }
    
    before{ FileUtils.rm_rf(target) }
    after { FileUtils.rm_rf(target) }
      
    it 'should create the thumbnail file' do
      IMagick.create_thumbnail(source, target)
      File.exists?(target).should be_true
    end
    
  end # command_for
  
end