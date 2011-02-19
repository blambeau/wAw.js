require File.expand_path("../imagick", __FILE__)
class IGallery
  
  # Raised when something goes wrong with the gallery. Typically
  # raised when an action is attempted on existing albums and/or images
  class Error < StandardError; end
  
  # IGallery root folder, containing a subfolder for each album
  attr_reader :root_folder
  
  #
  # Creates a new gallery instance, opens it and normalize albums.
  #
  # All missing thumbnails are created as a side effect.
  #
  def self.open(root_folder)
    g = IGallery.new(root_folder)
    g.normalize_all_albums
    g
  end
  
  #
  # Creates a gallery instance (see ../albums)
  #
  # @param root_folder the root gallery folder, which is expected
  #        to contain one subfolder for each album
  #
  def initialize(root_folder)
    @root_folder = root_folder
  end
  
  ################################################################### Tools about paths
  
  #
  # Expand a relative path with the root gallery folder.
  #
  # Examples:
  #   _('somealbum/someimage') -> /an/absolute/gallery/path/somealbum/someimage
  #   _('somealbum', 'someimage') -> /an/absolute/gallery/path/somealbum/someimage
  #
  def _(*paths)
    File.join(root_folder, *paths)
  end
  
  # 
  # Cuts an absolute path by removing the root_folder part
  #
  def cut_path(path)
    path[(1+root_folder.length)..-1]
  end
  
  ################################################################### Album normalizations
  
  #
  # Normalizes the folder of a given album. 
  #
  # This method ensure that trash and thumbs folder exist, and ensure that
  # all thumbnails are correctly created.
  #
  def normalize_album(albid)
    require 'fileutils'
    FileUtils.mkdir_p(_(albid, 'thumbs'))
    FileUtils.mkdir_p(_(albid, 'trash'))
    all_images(albid).each{|tuple|
      source, target = _(tuple[:path]), _(tuple[:thumb])
      unless File.exists?(target)
        IMagick.create_thumbnail(source, target)
      end
    }
  end
  
  #
  # Applies normalize_album to each folder in the gallery
  #
  def normalize_all_albums
    albums.each{|tuple| normalize_album(tuple[:albid])}
  end
  
  #
  # Returns a tuple with information about an album identified by _albid_.
  #
  # Returned tuple contains the following attributes:
  # - albid: an unique identifier to use when refering to the album later
  # - name: the name of the album
  # - path: path to the album in the gallery (relative to root_folder)
  #
  def album(albid)
    if File.exists?(path = _(albid))
      {:albid => albid, :name => albid, :path => cut_path(path)}
    else
      raise Error, "No such album #{albid}"
    end
  end
  
  ################################################################### Model READ
  
  #
  # Returns a tuple with information about a single image identified by a 
  # couple (albid, imgid).
  #
  # Returned tuple contains the following attributes:
  # - albid: identifier of the album containing the image
  # - imgid: identifier of the image itself
  # - path: path to the image in the gallery (relative to root_folder)
  # - thumb: path to the thumbnail in the gallery (relative to root_folder)
  #
  def image(albid, imgid)
    if File.exists?(path = _(albid, imgid))
      imgid = File.basename(path)
      {:albid   => albid, 
       :imgid   => imgid, 
       :path    => cut_path(path), 
       :thumb   => cut_path(_(albid, 'thumbs', imgid)),
       :deleted => false }
    elsif File.exists?(path = _(albid, 'trash', imgid))
      imgid = File.basename(path)
      {:albid   => albid, 
       :imgid   => imgid, 
       :path    => cut_path(path), 
       :thumb   => cut_path(_(albid, 'thumbs', imgid)),
       :deleted => true }
    else
      raise Error, "No such image #{albid}/#{imgid}"
    end
  end
  
  #
  # Returns a relation with information about albums in the gallery. 
  #
  # Returned relation contains tuples as specified in _album(albid)_
  #
  def albums
    Dir[_("*")].collect do |alb| 
      album(File.basename(alb))
    end
  end
  
  #
  # Returns a relation with information about non-deleted images in a given 
  # album.
  #
  # Returned relation contains tuples as specified in _image(albid, imgid)_
  #
  def kept_images(albid)
    Dir[_(albid, "*.jpg")].collect do |f|
      image(albid, File.basename(f))
    end
  end
  
  #
  # Returns a relation with information about deleted images in a given 
  # album.
  #
  # Returned relation contains tuples as specified in _image(albid, imgid)_
  #
  def deleted_images(albid)
    Dir[_(albid, "trash", "*.jpg")].collect do |f|
      image(albid, File.basename(f))
    end
  end
  
  # Convenient method that returns (images + deleted_images)
  def all_images(albid)
    kept_images(albid) + deleted_images(albid)
  end
  
  ################################################################### Model WRITE
  
  #
  # Pushes an image in trash.
  #
  # Returns true on success. This method has no effect if the image is already 
  # in the trash and returns false in this case
  #
  def delete_image!(albid, imgid) 
    img = image(albid, imgid)
    source, target = _(img[:path]), _(albid, 'trash', imgid)
    FileUtils.mv(source, target) unless img[:deleted]
    !img[:deleted]
  end
  
  #
  # Resurects an image from trash.
  #
  # Returns true on success. This method has no effect if the image is not in the 
  # trash and returns false in this case
  #
  def undelete_image!(albid, imgid)
    img = image(albid, imgid)
    source, target = _(img[:path]), _(albid, imgid)
    FileUtils.mv(source, target) if img[:deleted]
    img[:deleted]
  end
  
  # 
  # Call delete_image! if image exists, undelete_image! otherwise.
  #
  def toggle_delete_image!(albid, imgid)
    if image(albid, imgid)[:deleted]
      undelete_image!(albid, imgid)
      :undeleted
    else
      delete_image!(albid, imgid)
      :deleted
    end
  end
  
  # Rotates an image leftside
  def rotate_image_left!(albid, imgid)
    img = image(albid, imgid)
    IMagick.rotate_left(_(img[:path]))
    IMagick.rotate_left(_(img[:thumb]))
    true
  end
  
  # Rotates an image rightside
  def rotate_image_right!(albid, imgid)
    img = image(albid, imgid)
    IMagick.rotate_right(_(img[:path]))
    IMagick.rotate_right(_(img[:thumb]))
    true
  end
  
end # class IGallery