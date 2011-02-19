require File.expand_path('../spec_helper', __FILE__)
describe Gallery do
  
  let(:fixtures){ 
    File.expand_path('../fixtures', __FILE__) 
  }
  let(:nature){ 
    File.join(fixtures, 'Nature') 
  }
  let(:gallery){ 
    Gallery.new fixtures
  }
  
  context "_" do

    it 'should correctly resolve single paths' do
      gallery._('Cars').should == File.join(fixtures, 'Cars')
    end

    it 'should correctly resolve inline sub paths' do
      gallery._('Cars/pict.jpg').should == File.join(fixtures, 'Cars', 'pict.jpg')
    end

    it 'should correctly resolve non inline sub paths' do
      gallery._('Cars', 'pict.jpg').should == File.join(fixtures, 'Cars', 'pict.jpg')
    end
    
  end # _
  
  context "cut_path" do
    
    it 'should work fine when roundtripping with _' do
      gallery.cut_path(gallery._('Cars/pict.jpg')).should == File.join('Cars', 'pict.jpg')
      gallery.cut_path(gallery._('Cars', 'pict.jpg')).should == File.join('Cars', 'pict.jpg')
    end
    
  end # cut_path
  
  context "normalize_album" do
    before { FileUtils.rm_rf nature }
    after  { FileUtils.rm_rf nature; FileUtils.mkdir_p nature }
    
    it 'should create thumbs and trash folders' do
      gallery.normalize_album('Nature')
      File.exists?(File.join(nature, 'trash')).should be_true
      File.exists?(File.join(nature, 'thumbs')).should be_true
    end
    
  end # normalize_album
  
  context "normalize_all_albums" do
    
    context "on the Nature album" do
      before { FileUtils.rm_rf nature; FileUtils.mkdir_p nature }
      after  { FileUtils.rm_rf nature; FileUtils.mkdir_p nature }
      it 'should create thumbs and trash folders' do
        gallery.normalize_all_albums
        File.exists?(File.join(nature, 'trash')).should be_true
        File.exists?(File.join(nature, 'thumbs')).should be_true
      end
    end
    
    context "on the Cars album" do
      let(:thumb){ gallery._("Cars/thumbs/Morgan.jpg") }
      before{ FileUtils.rm_rf thumb }
      after{ FileUtils.rm_rf thumb }
      
      it 'should create thumbnails' do
        gallery.normalize_all_albums
        File.exists?(thumb).should be_true
      end
    end
    
  end # normalize_all_albums
  
  context "albums" do
    
    it 'should return expected relation' do
      gallery.albums.should == [
        {:albid => 'Cars', :name => 'Cars', :path => 'Cars'},
        {:albid => 'Nature', :name => 'Nature', :path => 'Nature'}
      ]
    end
    
  end # albums
  
  context 'album' do
    
    it 'should return expected tuple on existing album' do
      gallery.album('Cars').should == {
        :albid => 'Cars', :name => 'Cars', :path => 'Cars'
      }
    end
    
    it 'should raise an error on non-existing album' do
      lambda{ 
        gallery.album('NonExisting') 
      }.should raise_error(Gallery::Error)
    end
    
  end # album 
  
  context "image" do
    
    it "should work when called on a kept image" do
      gallery.image('Cars', 'Morgan.jpg').should == {
        :albid => 'Cars', :imgid => 'Morgan.jpg',
        :path  => File.join('Cars', 'Morgan.jpg'),
        :thumb => File.join('Cars', 'thumbs', 'Morgan.jpg') }
    end
    
    it "should work when called on a deleted image" do
      gallery.image('Cars', 'Opel.jpg').should == {
        :albid => 'Cars', :imgid => 'Opel.jpg',
        :path  => File.join('Cars', 'trash', 'Opel.jpg'),
        :thumb => File.join('Cars', 'thumbs', 'Opel.jpg') }
    end
    
    it 'should raise an error on non-existing album/image' do
      lambda{ 
        gallery.image('NonExisting', "Opel.jpg") 
      }.should raise_error(Gallery::Error)
      lambda{ 
        gallery.image('Cars', 'NoSuch.jpg') 
      }.should raise_error(Gallery::Error)
    end
    
  end
  
  context "kept_images" do
    
    it 'should return expected relation on Cars' do
      gallery.kept_images('Cars').should == [
        {:albid => 'Cars', :imgid => 'Morgan.jpg',
         :path  => File.join('Cars', 'Morgan.jpg'),
         :thumb => File.join('Cars', 'thumbs', 'Morgan.jpg') }
      ]
    end

    it 'should return expected relation on Nature' do
      gallery.kept_images('Nature').should == []
    end
    
  end # albums
  
  context "deleted_images" do
    
    it 'should return expected relation on Cars' do
      gallery.deleted_images('Cars').should == [
        {:albid => 'Cars', :imgid => 'Opel.jpg',
         :path  => File.join('Cars', 'trash', 'Opel.jpg'),
         :thumb => File.join('Cars', 'thumbs', 'Opel.jpg') }
      ]
    end

    it 'should return expected relation on Nature' do
      gallery.deleted_images('Nature').should == []
    end
    
  end # albums
  
end