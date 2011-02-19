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
        :thumb => File.join('Cars', 'thumbs', 'Morgan.jpg'),
        :deleted => false }
    end
    
    it "should work when called on a deleted image" do
      gallery.image('Cars', 'Opel.jpg').should == {
        :albid => 'Cars', :imgid => 'Opel.jpg',
        :path  => File.join('Cars', 'trash', 'Opel.jpg'),
        :thumb => File.join('Cars', 'thumbs', 'Opel.jpg'),
        :deleted => true }
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
         :thumb => File.join('Cars', 'thumbs', 'Morgan.jpg'),
         :deleted => false }
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
         :thumb => File.join('Cars', 'thumbs', 'Opel.jpg'),
         :deleted => true }
      ]
    end

    it 'should return expected relation on Nature' do
      gallery.deleted_images('Nature').should == []
    end
    
  end # albums
  
  context "delete_image!" do
    
    context "when called on a kept image" do
      let(:source){ gallery._('Cars/Test.jpg') }
      let(:target){ gallery._('Cars/trash/Test.jpg') }
      before{ FileUtils.cp gallery._('Cars/Morgan.jpg'), source }
      after { FileUtils.rm_rf(source); FileUtils.rm_rf(target); }

      it 'should move the image to trash and return true' do
        gallery.delete_image!('Cars', 'Test.jpg').should be_true
        File.exists?(source).should be_false
        File.exists?(target).should be_true
      end

    end # on kept
    
    context "when called on a deleted image" do
      let(:source){ gallery._('Cars/Opel.jpg') }
      let(:target){ gallery._('Cars/trash/Opel.jpg') }

      it 'should do nothing and return false' do
        gallery.delete_image!('Cars', 'Opel.jpg').should be_false
        File.exists?(source).should be_false
        File.exists?(target).should be_true
      end

    end # on deleted
    
  end # delete_image!

  context "undelete_image!" do
    
    context "when called on a deleted image" do
      let(:source){ gallery._('Cars/trash/Test.jpg') }
      let(:target){ gallery._('Cars/Test.jpg') }
      before{ FileUtils.cp gallery._('Cars/Morgan.jpg'), source }
      after { FileUtils.rm_rf(source); FileUtils.rm_rf(target); }

      it 'should move the image to main and return true' do
        gallery.undelete_image!('Cars', 'Test.jpg').should be_true
        File.exists?(source).should be_false
        File.exists?(target).should be_true
      end

    end # on deleted
    
    context "when called on a kept image" do
      let(:source){ gallery._('Cars/Morgan.jpg') }
      let(:target){ gallery._('Cars/trash/Margan.jpg') }
    
      it 'should do nothing and return false' do
        gallery.undelete_image!('Cars', 'Morgan.jpg').should be_false
        File.exists?(source).should be_true
        File.exists?(target).should be_false
      end
    
    end # on deleted
    
  end # delete_image!
  
  context "toggle_delete_image!" do

    context "when called on a kept image" do
      let(:source){ gallery._('Cars/Test.jpg') }
      let(:target){ gallery._('Cars/trash/Test.jpg') }
      before{ FileUtils.cp gallery._('Cars/Morgan.jpg'), source }
      after { FileUtils.rm_rf(source); FileUtils.rm_rf(target); }

      it 'should move the image to trash and return :deleted' do
        gallery.toggle_delete_image!('Cars', 'Test.jpg').should == :deleted
        File.exists?(source).should be_false
        File.exists?(target).should be_true
      end
    end # on kept
    
    context "when called on a deleted image" do
      let(:source){ gallery._('Cars/trash/Test.jpg') }
      let(:target){ gallery._('Cars/Test.jpg') }
      before{ FileUtils.cp gallery._('Cars/Morgan.jpg'), source }
      after { FileUtils.rm_rf(source); FileUtils.rm_rf(target); }

      it 'should move the image to main and return true' do
        gallery.toggle_delete_image!('Cars', 'Test.jpg').should == :undeleted
        File.exists?(source).should be_false
        File.exists?(target).should be_true
      end
    end # on deleted
    
  end # toggle_delete_image!
  
  context "rotate_image_left!" do
    
    let(:source){ gallery._('Cars/Test.jpg') }
    let(:thumb) { gallery._('Cars/thumbs/Test.jpg') }
    before{ 
      FileUtils.cp gallery._('Cars/Morgan.jpg'), source 
      FileUtils.cp gallery._('Cars/thumbs/Morgan.jpg'), thumb 
    }
    after { 
      FileUtils.rm_rf(source)
      FileUtils.rm_rf(thumb)
    }
    
    it 'should have modified the file and the thumb' do
      require 'digest/md5'
      bef = [ Digest::MD5.hexdigest(File.read(source)),
              Digest::MD5.hexdigest(File.read(thumb)) ]
      gallery.rotate_image_left!('Cars', 'Test.jpg').should be_true
      aft = [ Digest::MD5.hexdigest(File.read(source)),
              Digest::MD5.hexdigest(File.read(thumb)) ]
      bef[0].should_not == aft[0]
      bef[1].should_not == aft[1]
    end
    
  end

  context "rotate_image_right!" do
    
    let(:source){ gallery._('Cars/Test.jpg') }
    let(:thumb) { gallery._('Cars/thumbs/Test.jpg') }
    before{ 
      FileUtils.cp gallery._('Cars/Morgan.jpg'), source 
      FileUtils.cp gallery._('Cars/thumbs/Morgan.jpg'), thumb 
    }
    after { 
      FileUtils.rm_rf(source)
      FileUtils.rm_rf(thumb)
    }
    
    it 'should have modified the file and the thumb' do
      require 'digest/md5'
      bef = [ Digest::MD5.hexdigest(File.read(source)),
              Digest::MD5.hexdigest(File.read(thumb)) ]
      gallery.rotate_image_right!('Cars', 'Test.jpg').should be_true
      aft = [ Digest::MD5.hexdigest(File.read(source)),
              Digest::MD5.hexdigest(File.read(thumb)) ]
      bef[0].should_not == aft[0]
      bef[1].should_not == aft[1]
    end
    
  end # rotate_image_right!
  
end # describe Gallery