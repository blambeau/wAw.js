class See < WawJS::Brick
  
  def initialize(gallery)
    super
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
  
  set :public, File.expand_path("../public", __FILE__)

  post '/:what' do
    content_type :json
    send(params[:what], params[:albid], params[:imgid]).to_json
  end

end