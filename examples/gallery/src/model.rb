class Model
  
  def initialize(gallery)
    @gallery = gallery
  end
  
  def albums(*args)
    @gallery.albums
  end
  
  def images(albid, *args)
    @gallery.all_images(albid)
  end
  
end # class Model