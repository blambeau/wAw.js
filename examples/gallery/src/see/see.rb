class See
  
  def initialize(gallery)
    @gallery = gallery
  end
  
  def rotate_left(albid, imgid)
    @gallery.rotate_image_left!(albid, imgid)
  end
  
  def rotate_right(albid, imgid)
    @gallery.rotate_image_right!(albid, imgid)
  end
  
  def toggle_delete(albid, imgid)
    @gallery.toggle_delete_image!(albid, imgid)
  end
  
end